const db = require("../helpers/sql.js");
const medicineModel = require("./models/medicine.js");

const { selectMedicineCharges } = require("../cf4/index.js");

const _removeForbiddenChars = (val) => {
  return typeof val === "string"
    ? val
        .replace(/ñ/g, "n")
        .replace(/Ñ/g, "N")
        .replace(/[^a-zA-Z0-9\s.,+\-=~"'/&%#@*:;()_]/g, "")
    : val;
};

const dumpMeds = async (caseNo, txn) => {
  if (!caseNo || !txn) throw "meds-dump: `caseNo` and `txn` are required.";

  const eClaimsDbConn = db.getConn("eclaims");

  if (!eClaimsDbConn) {
    console.log("Unable to dump CF4 data. EClaims server is not available.");
    return null;
  }

  const _case =
    (
      await db.query(
        `SELECT
            caseNo,
            patientNo,
            patientType,
            DateAd dateTimeAdmitted,
            DateDis dateTimeDischarged,
            CASE WHEN (UDF_CASEDEPT = 'ER') THEN 1 ELSE 0 END isEmergency
          FROM
            UERMMMC..Cases
          WHERE
            CaseNo = ?;`,
        [caseNo],
        txn,
        false,
      )
    )[0] ?? null;

  if (!_case) {
    return { warning: `meds-dump: case ${caseNo} cannot be found.` };
  }

  const claim = await db.selectOne(
    ["id", "code"],
    "DocumentMgt..Cf4Claims",
    { caseNo },
    txn,
  );

  if (!claim) {
    return { warning: `meds-dump: claim for ${caseNo} cannot be found.` };
  }

  const meds = await selectMedicineCharges(caseNo, txn);

  if (meds.length === 0) {
    return { warning: `meds-dump: no meds available for ${caseNo}.` };
  }

  const userCode = process.env.DEV
    ? "64c9e2d4-93e8-462d-8225-7ce30c2b2a36"
    : "ccfd0310-37b4-4153-afd4-5b6d2e3797b7";

  const sanitizedMeds = meds.map((med) => {
    return Object.entries(med).reduce((acc, entry) => {
      const key = entry[0];
      const val = entry[1];
      acc[key] = _removeForbiddenChars(val);
      return acc;
    }, {});
  });

  const formattedMeds = medicineModel.format(sanitizedMeds);
  // console.log(formattedMeds);

  const insertedMeds = await db.transact(async (txn) => {
    const consultation = await db.selectOne(
      "*",
      "EasyClaimsOffline..Consultation",
      { eClaimId: caseNo },
      txn,
    );

    if (consultation) {
      const insertedMeds = [];

      for (const med of formattedMeds) {
        insertedMeds.push(
          await medicineModel.insert(userCode, consultation.id, med, txn),
        );
      }

      return insertedMeds;
    }

    return [];
  }, eClaimsDbConn);

  if (insertedMeds.error) throw insertedMeds.error;
  return insertedMeds;
};

module.exports = dumpMeds;

const db = require("../helpers/sql.js");

const patientModel = require("./models/patient.js");
const profileModel = require("./models/profile.js");
const medHistModel = require("./models/med-hist.js");
const mensHistModel = require("./models/mens-hist.js");

const consultationModel = require("./models/consultation.js");
// const eClaimModel = require("./e-claim.js");
// const cf4ClaimModel = require("./cf4-claim.js");

const pePertModel = require("./models/pe-pert.js");
const peModel = require("./models/pe.js");
const subjectiveModel = require("./models/subjective.js");
const courseWardModel = require("./models/course-ward.js");
const medicineModel = require("./models/medicine.js");

const modelsMap = {
  [patientModel.table]: patientModel,
  [profileModel.table]: profileModel,
  [medHistModel.table]: medHistModel,
  [mensHistModel.table]: mensHistModel,

  [consultationModel.table]: consultationModel,
  // [eClaimModel.table]: eClaimModel,
  // [cf4ClaimModel.table]: cf4ClaimModel,

  [pePertModel.table]: pePertModel,
  [peModel.table]: peModel,
  [subjectiveModel.table]: subjectiveModel,
  [courseWardModel.table]: courseWardModel,
  [medicineModel.table]: medicineModel,
};

const columns = Object.values(modelsMap).reduce((prev, curr) => {
  if (curr.columns) prev.push(...curr.columns);
  return prev;
}, []);

const _removeForbiddenChars = (val) => {
  return typeof val === "string"
    ? val
        .replace(/ñ/g, "n")
        .replace(/Ñ/g, "N")
        .replace(/[^a-zA-Z0-9\s.,+\-=~"'/&%#@*:;()_]/g, "")
    : val;
};

const _parseJson = (val) => {
  if (!val) return null;

  // IF WEIRD JSON
  if (
    (val.startsWith('["[') && val.endsWith(']"]')) ||
    (val.startsWith('["{') && val.endsWith('}"]'))
  ) {
    // const jsonStr = val.substring(2, val.length - 2).replace(/\\"/g, '"');
    // return JSON.parse(jsonStr, (key, value) => _removeForbiddenChars(value));

    // const jsonStr = val.substring(1, val.length - 1);

    // return JSON.parse(JSON.parse(jsonStr), (key, value) =>
    //   _removeForbiddenChars(value),
    // );

    return JSON.parse(JSON.parse(val)[0], (key, value) =>
      _removeForbiddenChars(value),
    );
  }

  // IF JSON
  try {
    return JSON.parse(val, (key, value) => _removeForbiddenChars(value));
  } catch (e) {}

  // IF PRIMITIVE
  return _removeForbiddenChars(val);
};

const dumpClaim = async (caseNo, txn) => {
  if (!caseNo || !txn) throw "cf4-db-dump: `caseNo` and `txn` are required.";

  const cf4DbDumpConn = db.getConn("eclaims");

  if (!cf4DbDumpConn) {
    console.log("Unable to dump CF4 data. EClaims server is not available.");
    return null;
  }

  const eClaim = await db.selectOne(
    "*",
    "EasyClaimsOffline..Consultation",
    {
      eClaimId: caseNo,
    },
    cf4DbDumpConn,
  );

  if (eClaim) {
    return { warning: `cf4-db-dump: eClaim for ${caseNo} already exists.` };
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

  // const cf4 =
  //   (
  //     await db.query(
  //       `SELECT
  //           a.firstName,
  //           a.middleName,
  //           a.lastName,
  //           a.isMember,
  //           a.sex,
  //           a.dob,
  //           b.id_no pin,
  //           b.add_bgy addBrgy,
  //           b.add_municipality addMun,
  //           b.add_province addProv,
  //           b.add_zip addZip,
  //           c.TransNo transmittalNo
  //         FROM
  //           UERMMMC_PHILHEALTH..PATIENT_INFO a
  //           LEFT JOIN UERMMMC_PHILHEALTH..MEMBERS_INFO b ON b.CaseNo = a.CaseNo
  //           LEFT JOIN UERMMMC_PHILHEALTH..TRANSMITTAL_MAIN c ON c.CaseNo = a.CaseNo
  //         WHERE
  //           a.CaseNo = ?;`,
  //       [caseNo],
  //       null,
  //       false
  //     )
  //   )[0] ?? null;

  if (!_case) {
    return { warning: `cf4-db-dump: case ${caseNo} cannot be found.` };
  }

  const pxInfo =
    (
      await db.query(
        `SELECT
            p.firstName,
            p.middleName,
            p.lastName,
            CASE WHEN (ISNULL(TRIM(p.UDF_PHILHEALTHNO), '') = '') THEN 0 ELSE 1 END isMember,
            p.sex gender,
            p.DBIRTH dateOfBirth,
            p.bPlace placeOfBirth,
            p.UDF_PHILHEALTHNO pin,
            p.Barangay addBrgy,
            p.Municipality addMun,
            '' addProv,
            p.ZipCode addZip,
            r.DESCRIPTION religion
          FROM
            UERMMMC..PATIENTINFO p
            LEFT JOIN UERMMMC..RELIGION r ON r.Code = p.Religion
          WHERE
            p.PatientNo = ?;`,
        [_case.patientNo],
        txn,
        false,
      )
    )[0] ?? null;

  const pxProfile = await profileModel.select(_case.patientNo, txn);
  const pxMedHist = await medHistModel.selectMedHist(_case.patientNo, txn);

  const pxFamMedHist = await medHistModel.selectFamMedHist(
    _case.patientNo,
    txn,
  );

  const pxMensHist = await mensHistModel.select(
    {
      code: _case.patientNo,
      gender: pxInfo.gender,
    },
    txn,
  );

  const cf4 =
    (
      await db.query(
        `SELECT
            id,
            code
          FROM
            DocumentMgt..Cf4Claims
          WHERE
            CaseNo = ?;`,
        [caseNo],
        txn,
        false,
      )
    )[0] ?? null;

  let cf4DetailsArr = [];

  if (cf4) {
    cf4DetailsArr = await db.query(
      `SELECT
          fieldCode,
          value
        FROM
          DocumentMgt..Cf4ClaimDetails
        WHERE
          Status = 1
          AND ClaimId = ?;`,
      [cf4.code],
      txn,
      false,
    );
  }

  if (!cf4 || cf4DetailsArr.length === 0) {
    return { warning: `cf4-db-dump: claim for ${caseNo} cannot be found.` };
  }

  // let firstCaseRateCode = null;
  // let secondCaseRateCode = null;
  const rowsToInsertMap = {};

  // Pre-process cf4 special case rows [START]
  const toRemoveFields = [];

  for (const cf4Detail of cf4DetailsArr) {
    cf4Detail.value = _parseJson(cf4Detail.value);

    if (cf4Detail.fieldCode === "courseInTheWardResult") {
      rowsToInsertMap[courseWardModel.table] = courseWardModel.format(
        cf4Detail.value,
      );
      continue;
    }

    if (cf4Detail.fieldCode === "drugsOrMedicinesResult") {
      rowsToInsertMap[medicineModel.table] = medicineModel.format(
        cf4Detail.value,
      );

      continue;
    }

    // if (cf4Detail.fieldCode === "firstCaseRateResult") {
    //   firstCaseRateCode = cf4Detail.value;
    //   toRemoveFields.push(cf4Detail.fieldCode);
    //   continue;
    // }

    // if (cf4Detail.fieldCode === "secondCaseRateResult") {
    //   secondCaseRateCode = cf4Detail.value;
    //   toRemoveFields.push(cf4Detail.fieldCode);
    //   continue;
    // }
  }

  cf4DetailsArr = cf4DetailsArr.filter(
    (row) => !toRemoveFields.includes(row.fieldCode),
  );
  // Pre-process cf4 special case rows [END]

  for (const column of columns) {
    const cf4Detail = cf4DetailsArr.find((e) => {
      return e.fieldCode === column.source;
    });

    if (cf4Detail) {
      if (!rowsToInsertMap[column.table]) {
        rowsToInsertMap[column.table] = [{}];
      }

      rowsToInsertMap[column.table][0][column.name] = column.format
        ? column.format(cf4Detail.value)
        : cf4Detail.value;
    }
  }

  // console.log(rowsToInsertMap);
  // return { error: false };

  // eclaims admin account
  const userCode = process.env.DEV
    ? "64c9e2d4-93e8-462d-8225-7ce30c2b2a36"
    : "ccfd0310-37b4-4153-afd4-5b6d2e3797b7";

  const pmccNo = "300837";
  const hospitalCode = "H93005943";

  const addedConsultation = await db.transact(async (txn) => {
    console.log("Adding patient...");
    const addedPatient = await patientModel.insert(
      userCode,
      pmccNo,
      pxInfo,
      _case,
      txn,
    );

    console.log("Adding profile...");
    const addedProfile = await profileModel.insert(
      userCode,
      addedPatient.id,
      {
        ...(pxProfile ?? {}),
        profDate: _case.dateTimeAdmitted,
        // patientPOB: pxInfo.placeOfBirth,
        // patientAge: getAge(pxInfo.dateOfBirth),
        // patientReligion: pxInfo.religion,
      },
      txn,
    );

    console.log("Adding med hist...");
    if (pxMedHist) {
      const addedMedHist = await medHistModel.insert(
        userCode,
        addedPatient.id,
        true,
        false,
        pxMedHist,
        txn,
      );
    }

    console.log("Adding fam med hist...");
    if (pxFamMedHist) {
      const addedFamMedHist = await medHistModel.insert(
        userCode,
        addedPatient.id,
        false,
        true,
        pxFamMedHist,
        txn,
      );
    }

    console.log("Adding mens hist...");
    const addedMensHist = await mensHistModel.insert(
      userCode,
      addedPatient.id,
      pxInfo.gender,
      pxMensHist,
      txn,
    );

    // console.log("Adding eclaim...");
    // const addedEClaim = await eClaimModel.insert(
    //   hospitalCode,
    //   null,
    //   userCode,
    //   pxInfo,
    //   _case,
    //   firstCaseRateCode,
    //   secondCaseRateCode,
    //   txn
    // );

    console.log("Adding consultation..");
    const addedConsultation = await consultationModel.insert(
      userCode,
      _case.caseNo,
      {
        patientId: addedPatient.id,
        soapDate: _case.dateTimeAdmitted,
      },
      txn,
    );

    // console.log("Adding cf4claim...");
    // const addedCf4Claim = await cf4ClaimModel.insert(
    //   addedPatient.id,
    //   addedConsultation.id,
    //   addedEClaim.id,
    //   txn
    // );

    // CF4 DETAILS
    for (const table in rowsToInsertMap) {
      for (const item of rowsToInsertMap[table]) {
        console.log(`Inserting into table ${table}...`);

        await modelsMap[table].insert(
          userCode,
          addedConsultation.id,
          item,
          txn,
        );
      }
    }

    // return addedCf4Claim;
    return addedConsultation;
  }, cf4DbDumpConn);

  if (addedConsultation.error) throw addedConsultation.error;
  return addedConsultation;
};

module.exports = { dumpClaim };

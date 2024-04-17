const db = require("../helpers/sql.js");

const _extractQDRFromMed = (med) => {
  if (!med["Quantity/Dosage/Route"]) return {};
  const props = ["Quantity", "Dosage", "Route"];

  return med["Quantity/Dosage/Route"].value
    .split("/")
    .map((v) => v?.trim())
    .reduce((acc, el, idx) => {
      const propName = props[idx];

      acc[propName] = el
        .replace("QTY:", "")
        .replace("DOSAGE:", "")
        .replace("ROUTE:", "")
        .trim();

      return acc;
    }, {});
};

const _extractDateFromMed = (med) => {
  if (med["Generic Name"]?.value) {
    const genName = med["Generic Name"].value;
    const dateTimeChargedRegExp = new RegExp(" - [0-9]{2}/[0-9]{2}/[0-9]{4}");

    const dateTimeCharged =
      med["Date & Time Charged"]?.value ??
      med["initialChargeDateTime"]?.value ??
      genName.match(dateTimeChargedRegExp)?.at(0)?.replace(" - ", "");

    return {
      genericName: {
        code: "genericName",
        value: genName.replace(dateTimeChargedRegExp, ""),
      },
      ...(dateTimeCharged
        ? {
            dateTimeCharged: {
              code: "dateTimeCharged",
              value: dateTimeCharged,
            },
          }
        : {}),
    };
  }

  return {};
};

const _fixMeds = (meds) => {
  const props = [
    // OLD FORMAT
    ["initialChargeDateTime", "dateTimeCharged"],
    ["Date & Time Charged", "dateTimeCharged"],
    ["Generic Name", "genericName"],
    ["Quantity", "quantity"],
    ["Dosage", "strength"],
    ["Strength", "strength"],
    ["Form", "form"],
    ["Package", "package"],
    ["Route", "route"],
    ["Total Cost", "totalCost"],
    // NEW FORMAT (ADDED LAST TO PRIORITIZE)
    ["dateTimeCharged", "dateTimeCharged"],
    ["genericName", "genericName"],
    ["quantity", "quantity"],
    ["strength", "strength"],
    ["form", "form"],
    ["package", "package"],
    ["route", "route"],
    ["totalCost", "totalCost"],
  ];

  return meds.map((med) => {
    const parsedMed = {
      ...med,
      ..._extractDateFromMed(med),
      ..._extractQDRFromMed(med),
    };

    return props.reduce((acc, prop) => {
      const oldPropName = prop[0];
      const newPropName = prop[1];

      if (
        parsedMed[oldPropName] &&
        parsedMed[oldPropName].value != null &&
        parsedMed[oldPropName].value !== ""
      ) {
        acc[newPropName] = parsedMed[oldPropName].value;
      }

      return acc;
    }, {});
  });
};

const _formatMedsJson = (value) => {
  if (!value) return [];

  // FOR BACKWARD COMPATIBILITY
  if (typeof value === "string") {
    // IF WEIRD JSON
    if (
      (value.startsWith('["[') && value.endsWith(']"]')) ||
      (value.startsWith('["{') && value.endsWith('}"]'))
    ) {
      const meds = JSON.parse(JSON.parse(value)[0]);
      return _fixMeds(meds);
    }

    try {
      // IF NORMAL JSON
      return JSON.parse(value);
    } catch (e) {
      throw "UNKNOWN MEDS FORMAT! FIX ASAP!";
    }
  }

  // IF VALID JS ARRAY
  return value;
};

const _selectMedicineCharges = async (caseNo, txn) => {
  const sql = `
    SELECT
      --T0.caseNo,
      --T0.CHARGESLIPNO chargeSlipNo,
      --T3.itemCode,
      --T3.brandName,
      MIN(T0.CHARGEDATETIME) dateTimeCharged,
      MIN(T3.GenName) genericName,
      MIN(T3.MG) strength,
      MIN(T3.DosageForm) form,
      MIN(CASE WHEN T3.CategoryCode = 'MED' THEN
        T4.Description
      ELSE
        ''
      END) route,
      --T2.SellingPrice sellingPrice,
      --T2.DiscAmt discountAmount,
      SUM(T2.Qty) quantity,
      SUM((T2.SellingPrice * T2.Qty) - T2.DiscAmt) totalCost
    FROM 
      [UERMMMC]..[CHARGES_MAIN] T0 WITH(NOLOCK)
      INNER JOIN [UERMMMC]..[PHAR_Sales_Parent] T1 WITH(NOLOCK) ON T0.CHARGESLIPNO = T1.CSNo
      INNER JOIN [UERMMMC]..[PHAR_Sales_Details] T2 WITH(NOLOCK) ON T1.SalesNo = T2.SalesNo
      INNER JOIN [UERMMMC]..[PHAR_ITEMS] T3 WITH(NOLOCK) ON T2.ItemCode = T3.ItemCode
      LEFT JOIN UERMMMC..PHAR_CATEGORY T4 ON T3.Category = T4.Code
    WHERE
      --T0.CANCELED = 'N'
      T0.CANCELED <> 'Y'
      AND T1.Cancelled = 0
      AND T3.PhicGroupCode = 'MED'
      AND T0.CASENO = ?
    GROUP BY
      T3.ItemCode;
    `;

  return await db.query(sql, [caseNo], txn, false);
};

const selectClaimDetails = async (caseNo, txn) => {
  const _case = await db.selectOne(
    ["caseNo", "patientType"],
    "UERMMMC..Cases",
    { caseNo },
    txn,
  );

  const claim = await db.selectOne(
    "*",
    "DocumentMgt..Cf4Claims",
    { caseNo, status: 4 },
    txn,
    { camelized: true },
  );

  // const origMeds =
  //   (
  //     await db.selectOne(
  //       "*",
  //       "DocumentMgt..Cf4ClaimDetails",
  //       {
  //         claimId: claim.code,
  //         fieldCode: "drugsOrMedicinesResult",
  //         status: 1,
  //       },
  //       txn,
  //       { camelized: true },
  //     )
  //   )?.value ?? null;

  const newMeds = await _selectMedicineCharges(caseNo, txn);
  // const meds = newMeds.length > 0 ? newMeds : _formatMedsJson(origMeds);

  return [_case, claim, newMeds];
};

const updateCf4Meds = async (claimCode, meds, txn) => {
  // console.log({ value: JSON.stringify(meds), updatedBy: "8225" });
  // console.log({ claimId: claimCode, fieldCode: "drugsOrMedicinesResult" });
  // return {};

  if (claimCode && meds && meds.length > 0) {
    return await db.updateOne(
      "DocumentMgt..Cf4ClaimDetails",
      {
        value: JSON.stringify(meds),
        updatedBy: "8225",
      },
      {
        claimId: claimCode,
        fieldCode: "drugsOrMedicinesResult",
      },
      txn,
    );
  }

  return null;
};

module.exports = {
  selectClaimDetails,
  updateCf4Meds,
};

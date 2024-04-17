const db = require("../../helpers/sql.js");
const { buildHashTable } = require("../../helpers/util.js");

const tableName = "EasyClaimsOffline..medicine";

const columns = [
  { name: "facilityType", required: true, default: "" },
  { name: "drugCode", required: true, default: "" },
  { name: "genericCode", required: true, default: "" },
  { name: "saltCode", required: true, default: "" },
  { name: "strengthCode", required: true, default: "" },
  { name: "formCode", required: true, default: "" },
  { name: "unitCode", required: true, default: "" },
  { name: "packageCode", required: true, default: "" },
  { name: "instructionStrength", required: true, default: "" },
  { name: "instructionFrequency", required: true, default: "AS NEEDED" },

  { name: "genericName", required: true, size: 500 },
  { name: "quantity", required: true },
  { name: "route", required: true, size: 500 },
  { name: "totalAmtPrice", required: true },

  { name: "isApplicable", required: true, default: "Y" },
  { name: "dateAdded", required: true, default: "" },
  { name: "module", required: true, default: "CF4" },

  { name: "reportStatus", default: "U" },
  { name: "deficiencyRemarks", default: "" },
];

for (const column of columns) {
  column.table = tableName;
}

const columnsMap = buildHashTable(columns, "name", (val) => {
  return {
    ...val,
    table: tableName,
  };
});

// const fixMed = (med) => {
//   const medPropsMap = {
//     "Date & Time Charged": "dateTimeCharged",
//     "Generic Name": "genericName",
//     Strength: "strength",
//     Form: "form",
//     Route: "route",
//     Quantity: "quantity",
//     "Total Cost": "cost",
//   };

//   return Object.values(med).reduce((prev, curr) => {
//     // FOR BACKWARD COMPATIBILITY [START]
//     if (curr.code === "Quantity/Dosage/Route" && curr.value) {
//       const qdrArr = curr.value.split(" / ");

//       if (qdrArr.length > 0) {
//         prev.dosage = qdrArr
//           .find((el) => el.trim().startsWith("DOSAGE: "))
//           ?.trim()
//           .replace("DOSAGE: ", "");

//         prev.qty = qdrArr
//           .find((el) => el.trim().startsWith("QTY: "))
//           ?.trim()
//           .replace("QTY: ", "");
//       }
//     }

//     // REMOVE DATE FROM GENERIC NAME
//     prev.genericName = prev.genericName
//       ? prev.genericName.replace(/ - [0-9]{2}\/[0-9]{2}\/[0-9]{4}/g, "").trim()
//       : "";
//     // FOR BACKWARD COMPATIBILITY [END]

//     if (medPropsMap[curr.code]) prev[medPropsMap[curr.code]] = curr.value;
//     return prev;
//   }, {});
// };

const format = (val) => {
  if (!val) return [];
  if (!Array.isArray(val) || val.length === 0) return [];

  return val
    .map((el) => {
      // const med = fixMed(el);
      const med = el;

      const genericName = med.genericName ? med.genericName.toUpperCase() : "";
      // const salt = "";
      const strength = med.strength ?? med.dosage; // 10, 500, 2.5, etc.
      const form = med.form; // ie vial, tablet, etc.
      // const unit = med.unit ? med.unit.toUpperCase() : ""; // mg, ml, etc.
      // const _package = med.package ? med.package.toUpperCase() : ""; // box, bottle, etc.

      return {
        // genericName: `${genericName}|${salt}|${strength}|${form}|${unit}|${_package}`,
        genericName: `${genericName}${
          strength ? ` ${strength.toUpperCase()}` : ""
        }${form ? ` ${form.toUpperCase()}` : ""}|||||`,
        quantity: med.quantity ?? med.qty ?? 0,
        route: med.route ? med.route.toUpperCase() : "",
        totalAmtPrice: med.cost ?? med.totalCost ?? 0,
        dateAdded: med.dateTimeCharged ? new Date(med.dateTimeCharged) : null,
      };
    })
    .filter((med) => {
      // EXCLUDE MEDS WITH INCOMPLETE DETAILS
      return med.genericName && med.totalAmtPrice > 0 && med.dateAdded;
    });
};

const select = async (caseNo) => {
  if (!caseNo) throw "`caseNo` is required.";

  const sql = `
    SELECT
      T0.caseNo,
      T0.CHARGESLIPNO chargeSlipNo,
      T0.CHARGEDATETIME dateTimeCharged,
      T3.itemCode,
      T3.brandName,
      T3.GenName genericName,
      T3.MG strength, /* IN PHAR_ITEMS strength AND/OR unit CAN BE FOUND IN Mg */
      T3.MG unit,
      T3.DosageForm form, /* IN PHAR_ITEMS form AND/OR package CAN BE FOUND IN DosageForm */
      T3.DosageForm package,
      '' route,
      T2.SellingPrice sellingPrice,
      T2.DiscAmt discountAmount,
      T2.Qty quantity,
      ((T2.SellingPrice * T2.Qty) - T2.DiscAmt) totalCost
    FROM 
      [UERMMMC]..[CHARGES_MAIN] T0 WITH(NOLOCK)
      INNER JOIN [UERMMMC]..[PHAR_Sales_Parent] T1 WITH(NOLOCK) ON T0.CHARGESLIPNO = T1.CSNo
      INNER JOIN [UERMMMC]..[PHAR_Sales_Details] T2 WITH(NOLOCK) ON T1.SalesNo = T2.SalesNo
      INNER JOIN [UERMMMC]..[PHAR_ITEMS] T3 WITH(NOLOCK) ON T2.ItemCode = T3.ItemCode
    WHERE
      (T0.CANCELED = 'N' AND T1.Cancelled = 0)
      AND T3.PhicGroupCode = 'MED'
      AND T0.CASENO = ?;
  `;

  // const prodDbConn = db.getConn("prod");
  const rows = await db.query(
    sql,
    [caseNo],
    // prodDbConn
  );

  if (rows.error) {
    console.log(rows.error);
    return [];
  }

  return rows;
};

const insert = async (userCode, consultationId, item, txn) => {
  if (!userCode) throw "`userCode` is required.";
  if (!consultationId) throw "`consultationId` is required.";
  if (!txn) throw "`txn` is required.";

  if (!item) item = {};
  console.log(item);
  db.createRow(item, columns, true);

  const genericName = item.genericName;

  return await db.upsert(
    tableName,
    item,
    {
      consultationId,
      genericName,
    },
    userCode,
    txn,
    "CreatedBy",
    "Created",
    "UpdatedBy",
    "Updated",
  );
};

module.exports = {
  table: tableName,
  columns,
  columnsMap,
  format,
  select,
  insert,
};

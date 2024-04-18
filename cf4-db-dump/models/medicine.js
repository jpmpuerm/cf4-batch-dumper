const db = require("../../helpers/sql.js");
const { buildHashTable, jsDateToISOString } = require("../../helpers/util.js");

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
        totalAmtPrice: Number(med.cost ?? med.totalCost ?? 0),
        dateAdded: med.dateTimeCharged ? new Date(med.dateTimeCharged) : null,
      };
    })
    .filter((med) => {
      // EXCLUDE MEDS WITH INCOMPLETE DETAILS
      return med.genericName && med.totalAmtPrice > 0 && med.dateAdded;
    });
};

const insert = async (userCode, consultationId, item, txn) => {
  if (!userCode) throw "`userCode` is required.";
  if (!consultationId) throw "`consultationId` is required.";
  if (!txn) throw "`txn` is required.";

  if (!item) item = {};
  db.createRow(item, columns);

  const genericName = item.genericName;
  const dateAdded = jsDateToISOString(item.dateAdded);

  delete item.genericName;
  delete item.dateAdded;

  const existingMed =
    (
      await db.query(
        `SELECT
            *
          FROM 
            ${tableName}
          WHERE
            ConsultationId = ?
            AND GenericName = ?
            AND DateAdded = ?;`,
        [consultationId, genericName, dateAdded],
        txn,
      )
    )[0] ?? null;

  if (existingMed) {
    // console.log("Med exists. Updating the existing...");
    return await db.update(
      tableName,
      { ...item, updatedBy: userCode },
      { consultationId, genericName, dateAdded },
      txn,
      "Updated",
    );
  }

  // console.log("Inserting new med...");
  return await db.insert(
    tableName,
    {
      ...item,
      createdBy: userCode,
      consultationId,
      genericName,
      dateAdded,
    },
    txn,
    "Created",
  );
};

module.exports = {
  table: tableName,
  columns,
  columnsMap,
  format,
  insert,
};

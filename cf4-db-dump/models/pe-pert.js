const db = require("../../helpers/sql.js");
const { buildHashTable } = require("../../helpers/util.js");

const tableName = "EasyClaimsOffline..pePert";

const getNumberPart = (val) => {
  return val.match(/[0-9]*\.?[0-9]+/)[0];
};

const columns = [
  {
    name: "systolic",
    default: "",
    source: "physicalExaminationOnAdmissionVitalSignsBP",
    format: (val) => {
      if (!val) return "";
      const arr = val.split("/");
      return arr[0].trim();
    },
  },
  {
    name: "diastolic",
    default: "",
    source: "physicalExaminationOnAdmissionVitalSignsBP",
    format: (val) => {
      if (!val) return "";
      const arr = val.split("/");
      return arr[1].trim();
    },
  },
  {
    name: "hr",
    required: true,
    source: "physicalExaminationOnAdmissionVitalSignsHR",
    // format: (val) => {
    //   return getNumberPart(val);
    // },
  },
  {
    name: "rr",
    required: true,
    source: "physicalExaminationOnAdmissionVitalSignsRR",
    // format: (val) => {
    //   return getNumberPart(val);
    // },
  },
  {
    name: "temp",
    required: true,
    source: "physicalExaminationOnAdmissionVitalSignsTemp",
    // format: (val) => {
    //   return getNumberPart(val);
    // },
  },
  {
    name: "height",
    default: null,
    source: "physicalExaminationOnAdmissionHeight",
    format: (val) => {
      if (!val) return 0;
      return (getNumberPart(val) ?? 0) * 100;
    },
  },
  {
    name: "weight",
    default: null,
    source: "physicalExaminationOnAdmissionWeight",
    format: (val) => {
      return getNumberPart(val);
    },
  },
  {
    name: "vision",
    default: "",
  },
  {
    name: "headCirc",
    default: null,
  },
  {
    name: "reportStatus",
    default: "U",
  },
  {
    name: "deficiencyRemarks",
    default: "",
  },
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

const insert = async (userCode, consultationId, item, txn) => {
  db.createRow(item, columns);

  return await db.upsert(
    tableName,
    item,
    {
      consultationId,
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
  insert,
};

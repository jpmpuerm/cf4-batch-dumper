const mssql = require("mssql");

const {
  empty,
  isStr,
  isArr,
  isObj,
  objEmpty,
  changeCase,
  pascalToCamel,
  generateNumber,
  allPropsEmpty,
  addEllipsis,
} = require("./util.js");

const __conns = {};

// Validates and supplies default column values to the given row object
// column format:
// {
//   identity: true,
//   required: true,
//   default: null,
//   absoluteValue: "X"
// }
const createRow = (item, columns) => {
  for (const column of columns) {
    // false, "", 0 are valid values, only check for null or undefined
    if (item[column.name] == null) item[column.name] = column.default;

    if (column.absoluteValue !== undefined)
      item[column.name] = column.absoluteValue;

    if (
      column.size &&
      item[column.name] &&
      item[column.name].length > column.size
    )
      item[column.name] = addEllipsis(item[column.name], column.size);

    // null and undefined are not allowed if required = true
    if (column.required && item[column.name] == null) {
      throw `${column.name} column is required.`;
    }
  }
};

const formatQueryError = (error) => {
  const isSqlError =
    error instanceof mssql.ConnectionError ||
    error instanceof mssql.TransactionError ||
    error instanceof mssql.RequestError ||
    error instanceof mssql.PreparedStatementError;

  return { error: isSqlError ? "Database Error" : error };
};

const addConn = async (name, config) => {
  const newConn = new mssql.ConnectionPool(config);

  process.stdout.write(`Connecting to ${name} db connection... `);
  await newConn.connect();
  console.log("Connected.");

  __conns[name] = newConn;
};

const getConn = (name) => {
  return __conns[name];
};

const where = (obj, colPrefix = "") => {
  if (empty(obj)) {
    return ["", []];
  }

  if (!isStr(colPrefix)) throw "`colPrefix` should be a string.";
  if (!isObj(obj)) throw "`obj` should be an object.";

  const prefix = colPrefix ? colPrefix.concat(".") : "";
  const whereStrArr = [];
  const whereArgs = [];

  for (const key in obj) {
    const colName = `${prefix}${key}`;

    if (obj[key] == null) {
      whereStrArr.push(`${colName} IS NULL`);
      continue;
    }

    whereStrArr.push(`${colName} = ?`);
    whereArgs.push(obj[key]);
  }

  return [`WHERE ${whereStrArr.join(" AND ")}`, whereArgs];
};

const query = async (command, args, conn, camelized) => {
  if (!command) throw "`command` is required.";
  if (!args) args = [];
  if (!conn) conn = __conns.default;
  if (camelized == null) camelized = true;

  if (
    !(conn instanceof mssql.ConnectionPool) &&
    !(conn instanceof mssql.Transaction)
  )
    throw "`conn` argument must be a ConnectionPool or a Transaction.";

  // console.log("query helper, command: ", command);
  // console.log("query helper, args: ", args);

  try {
    const result = (await conn.request().query(command.split("?"), ...args))
      .recordset;

    if (result) {
      if (camelized) return result.map((row) => changeCase(row, pascalToCamel));
      return result;
    }

    return null;
  } catch (error) {
    console.log("`query` helper: ", error);
    // Let `transact` handle the error if this is ran inside `transact`
    if (conn instanceof mssql.Transaction) throw error;
    return formatQueryError(error);
  }
};

const transact = async (commands, conn) => {
  if (!conn) conn = __conns.default;

  try {
    const txn = new mssql.Transaction(conn);

    // IMPORTANT: begin transaction here as rolling back a transaction that
    // has not been started throws an error
    // console.log("Starting transaction...");
    await txn.begin();

    try {
      // IMPORTANT: Throw an error inside the `commands` arg to force a "rollback"
      const ret = await commands(txn);
      // console.log("Committing transaction...");
      await txn.commit();

      return ret;
    } catch (error) {
      console.log("`transact` helper: ", error);
      // console.log("Error occured in a transaction. Rolling back...");
      await txn.rollback();
      // console.log("Rolled back.");
      return formatQueryError(error);
    }
  } catch (error) {
    console.log("`transact` helper: ", error);
    return formatQueryError(error);
  }
};

const select = async (columns, table, conditions, txn, options) => {
  if (empty(columns) || !table)
    throw "`columns` and `table` arguments are required.";

  if (!options) options = {};

  //  For backward compatibility [START]
  if (options.order) options.orderBy = options.order;
  delete options.order;
  //  For backward compatibility [END]

  const [whereStr, whereArgs] = where(conditions);

  const command = `
    SELECT ${options.limitTo ? "TOP (".concat(options.limitTo, ")") : ""}
      ${isArr(columns) ? columns.join(",") : columns}
    FROM ${table}
    ${empty(conditions) ? "" : whereStr}
    ${options.orderBy ? `ORDER BY ${options.orderBy}` : ""};
  `;

  return await query(command, whereArgs, txn, options.camelized);
};

const selectOne = async (columns, table, conditions, txn, options) => {
  return (
    (
      await select(columns, table, conditions, txn, {
        ...(options ?? {}),
        limitTo: 1,
      })
    )[0] ?? null
  );
};

const insertMany = async (table, items, txn, options) => {
  if (!table || !items) throw "`table` and `items` arguments are required.";

  if (!options) options = {};
  if (!options.timestampColName) options.timestampColName = "dateTimeCreated";

  const cols = [options.timestampColName, ...Object.keys(items[0])];
  const args = [];
  const values = [];

  for (const item of items) {
    const placeholders = [];
    placeholders.push("GETDATE()");

    for (const key in item) {
      placeholders.push("?");
      args.push(item[key]);
    }

    values.push(`(${placeholders.join(",")})`);
  }

  const command = `
    INSERT INTO ${table} (${cols.join(",")})
    OUTPUT INSERTED.*
    VALUES ${values.join(",")};
  `;

  return await query(command, args, txn, options.camelized);
};

const insertOne = async (table, item, txn, options) => {
  return (await insertMany(table, [item], txn, options))[0] ?? null;
};

const insert = async (table, item, txn, timestampColName, camelized) => {
  return (
    (
      await insertMany(table, [item], txn, { timestampColName, camelized })
    )[0] ?? null
  );
};

const updateMany = async (table, item, conditions, txn, options) => {
  if (!table || empty(item) || empty(conditions))
    throw "`table`, `item` and `conditions` arguments are required.";

  if (allPropsEmpty(conditions)) throw "All props of `conditions` are empty.";
  if (!options) options = {};
  if (!options.timestampColName) options.timestampColName = "dateTimeUpdated";

  const setClauseArr = [`${options.timestampColName} = GETDATE()`];
  const setClauseArgs = [];

  for (const key in item) {
    if (item[key] !== undefined) {
      setClauseArr.push(`${key} = ?`);
      setClauseArgs.push(item[key]);
    }
  }

  const [whereStr, whereArgs] = where(conditions);

  const sqlCommand = `
    ${options.limitTo ? "SET ROWCOUNT ".concat(options.limitTo) : ""}

    UPDATE ${table} SET
    ${setClauseArr.join(",")}
    OUTPUT INSERTED.*
    ${whereStr}

    ${options.limitTo ? "SET ROWCOUNT 0" : ""}
  `;

  const sqlArgs = [...setClauseArgs, ...whereArgs];

  return await query(sqlCommand, sqlArgs, txn, options.camelized);
};

const updateOne = async (table, item, conditions, txn, options) => {
  return (
    (
      await updateMany(table, item, conditions, txn, {
        ...(options ?? {}),
        limitTo: 1,
      })
    )[0] ?? null
  );
};

const update = async (
  table,
  item,
  conditions,
  txn,
  timestampColName,
  camelized,
) => {
  return (
    (
      await updateMany(table, item, conditions, txn, {
        timestampColName,
        camelized,
        limitTo: 1,
      })
    )[0] ?? null
  );
};

const upsert = async (
  table,
  item,
  identityColumnsMap,
  createdOrUpdatedBy,
  txn,
  creatorColName,
  creationDateTimeColName,
  updatorColName,
  updateDateTimeColName,
  camelized,
) => {
  if (
    !table ||
    objEmpty(item) ||
    objEmpty(identityColumnsMap) ||
    !createdOrUpdatedBy ||
    !txn
  )
    throw "`table`, `item`, `identityColumnsMap`, `createdOrUpdatedBy` and `txn` arguments are required.";

  if (!creatorColName) creatorColName = "createdBy";
  if (!creationDateTimeColName) creationDateTimeColName = "dateTimeCreated";
  if (!updatorColName) updatorColName = "updatedBy";
  if (!updateDateTimeColName) updateDateTimeColName = "dateTimeUpdated";

  if (Object.keys(identityColumnsMap).length === 0)
    throw "`identityColumnsMap` should have one or more items.";

  const existingItem = await selectOne("*", table, identityColumnsMap, txn);

  if (existingItem) {
    let noChanges = true;

    for (const key in item) {
      if (item[key] !== existingItem[key]) {
        noChanges = false;
        break;
      }
    }

    if (noChanges) {
      // console.log("No Changes to the item. Returning the existing one...");
      return existingItem;
    }

    // console.log("upsert: Updating existing item...");
    return await updateOne(
      table,
      { ...item, [updatorColName]: createdOrUpdatedBy },
      identityColumnsMap,
      txn,
      { timestampColName: updateDateTimeColName, camelized },
    );
  }

  // console.log("upsert: Inserting new item...");
  return await insertOne(
    table,
    { ...item, ...identityColumnsMap, [creatorColName]: createdOrUpdatedBy },
    txn,
    { timestampColName: creationDateTimeColName, camelized },
  );
};

const del = async (table, conditions, txn, options) => {
  if (!table || empty(conditions) || !txn)
    throw "`table`, `conditions` and `txn` arguments are required.";

  if (!options) options = {};
  if (allPropsEmpty(conditions)) throw "All props of `conditions` are empty.";
  const [whereStr, whereArgs] = where(conditions);

  return await query(
    `DELETE FROM ${table} 
      OUTPUT DELETED.*
      ${whereStr};`,
    whereArgs,
    txn,
    options.camelized,
  );
};

const generateRowCode = async (table, column, prefix, seriesLength, txn) => {
  if (!txn) throw "generateRowCode: `txn` arg is required.";

  if (!seriesLength) seriesLength = 5;
  let code = "";
  let codeExists = true;

  // const dateTimeStr = (
  //   await query(`SELECT FORMAT(GETDATE(), 'yyyyMMddhhmmssfff') dateTimeStr;`)
  // )[0].dateTimeStr;

  const dateTimeStr = (
    await query(`SELECT FORMAT(GETDATE(), 'yyyyMMddhhmmss') dateTimeStr;`)
  )[0].dateTimeStr;

  while (codeExists) {
    code = `${prefix}${dateTimeStr}${generateNumber(seriesLength)}`;
    codeExists = await selectOne("*", table, { [column]: code }, txn, {
      camelized: false,
    });
  }

  return code;
};

const getDateTime = async (txn) => {
  return (await query(`SELECT GETDATE() AS now;`, [], txn, false))[0].now;
};

const getTime = async (txn) => {
  return (
    await query(
      `SELECT CONVERT(VARCHAR(5), GETDATE(), 108) AS currentTime;`,
      [],
      txn,
      false,
    )
  )[0].currentTime;
};

module.exports = {
  createRow,
  addConn,
  getConn,
  where,
  query,
  transact,
  select,
  selectMany: select, // ALIAS
  selectOne,
  insert,
  insertOne,
  insertMany,
  update,
  updateOne,
  updateMany,
  upsert,
  del,
  generateRowCode,
  getDateTime,
  getTime,
};

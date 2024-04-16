require("dotenv").config();

const db = require("./helpers/sql.js");

const prodDbConfig = require("./config/databaseConfig.js");
const devDbConfig = require("./config/databaseTestingConfig.js");

const eClaimsConfig = require("./config/databaseEclaimsConfig.js").prod;
const eClaimsConfigTest = require("./config/databaseEclaimsConfig.js").dev;

module.exports = async () => {
  await db.addConn("default", process.env.DEV ? devDbConfig : prodDbConfig);

  await db.addConn(
    "eclaims",
    process.env.DEV ? eClaimsConfigTest : eClaimsConfig,
  );

  console.log(`Using ${process.env.DEV ? "TEST" : "LIVE"} UERM CF4 database.`);

  console.log(
    `Using ${process.env.DEV ? "TEST" : "LIVE"} EasyClaims database.`,
  );
};

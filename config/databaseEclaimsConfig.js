const baseConfig = {
  options: {
    enableArithAbort: true,
    encrypt: false,
    appName: "node-rest-api",
    useUTC: false,
  },
  dialectOptions: {
    appName: "node-rest-api",
  },
  connectionTimeout: 10000,
  requestTimeout: 30000,
  pool: {
    idleTimeoutMillis: 30000,
    max: 100,
  },
};

module.exports = {
  prod: {
    server: process.env.DB_HOST_ECLAIMS,
    database: process.env.DB_DB_ECLAIMS,
    user: process.env.DB_USER_ECLAIMS,
    password: process.env.DB_PASS_ECLAIMS,
    ...baseConfig,
  },
  dev: {
    server: process.env.DB_HOST_ECLAIMS_DEV,
    database: process.env.DB_DB_ECLAIMS_DEV,
    user: process.env.DB_USER_ECLAIMS_DEV,
    password: process.env.DB_PASS_ECLAIMS_DEV,
    ...baseConfig,
  },
};

const initConn = require("../init-conns.js");
const db = require("../helpers/sql.js");
const { delay } = require("../helpers/util.js");
const dumpMeds = require("../cf4-db-dump/dump-meds.js");

const caseNos = ["0098203"];

(async () => {
  await initConn();

  for (const caseNo of caseNos) {
    let message = "SUCCESS.";

    await delay(150);
    process.stdout.write(`Dumping meds for ${caseNo}... `);

    const result = await db.transact(async (txn) => {
      return await dumpMeds(caseNo, txn);
    });

    if (result?.error) {
      message = `[ERROR] ${result.error}`;
    }

    if (result?.warning) {
      message = `[WARNING] ${result.warning.toUpperCase()}`;
    }

    console.log(message);
  }

  console.log("Done.");
  process.exit();
})();

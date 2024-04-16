const initConn = require("./init-conns.js");
const db = require("./helpers/sql.js");
const caseNos = require("./case-nos.js");
const { delay } = require("./helpers/util.js");

const { selectClaimDetails, updateCf4Meds } = require("./cf4/index.js");
const { dumpClaim } = require("./cf4-db-dump/index.js");
let message = "Done.";

(async () => {
  await initConn();

  for (const caseNo of caseNos) {
    console.log(`Dumping case ${caseNo}...`);

    const result = await db.transact(async (txn) => {
      const [_case, claim, newMeds] = await selectClaimDetails(caseNo, txn);

      if (!_case) {
        return { warning: `Case ${caseNo} not found.` };
      }

      if (_case.patientType !== "IPD") {
        return { warning: `Case ${caseNo} is not IPD.` };
      }

      if (!claim) {
        return { warning: `Claim for case ${caseNo} not found.` };
      }

      if (newMeds && newMeds.length > 0) {
        await updateCf4Meds(claim.code, newMeds, txn);
      }

      return await dumpClaim(caseNo, txn);
    });

    await delay(150);

    if (result?.error) {
      console.log(result.error);
      message = "Error.";
      break;
    }

    if (result.warning) {
      console.log("WARNING: ", result.warning);
      continue;
    }

    console.log(`Successfully dumped case ${caseNo}.`);
  }

  console.log(message);
  process.exit();
})();

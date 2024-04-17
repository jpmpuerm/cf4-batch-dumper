const path = require("path");
const fs = require("fs/promises");
const initConn = require("./init-conns.js");
const db = require("./helpers/sql.js");
const caseNosMap = require("./case-nos.js");
const { delay, generateFileName } = require("./helpers/util.js");

const { selectClaimDetails, updateCf4Meds } = require("./cf4/index.js");
const { dumpClaim } = require("./cf4-db-dump/index.js");

const appendCSV = async (fileName, cols) => {
  try {
    process.stdout.write(`Appending to ${fileName}... `);

    await fs.appendFile(
      path.resolve(process.cwd(), fileName),
      cols
        .map((col) => `"${col}"`)
        .join("\t")
        .concat("\n"),
    );

    console.log("Success.");
    return true;
  } catch (err) {
    console.log(err);
    return false;
  }
};

(async () => {
  await initConn();
  // const errors = [];

  for (const key in caseNosMap) {
    const dateCharged = key;
    const caseNos = caseNosMap[key];

    for (const caseNo of caseNos) {
      let message = "SUCCESS.";
      let status = "DUMPED.";
      let statusDescription = "SUCCESSFULLY DUMPED.";

      await delay(150);
      process.stdout.write(`Dumping case ${caseNo}... `);

      const result = await db.transact(async (txn) => {
        const [_case, claim, newMeds] = await selectClaimDetails(caseNo, txn);

        if (!_case) {
          return { warning: `Case ${caseNo} not found.` };
        }

        if (_case.patientType !== "IPD") {
          return { error: `CASE ${caseNo} IS NOT IPD.` };
        }

        if (!claim) {
          return {
            warning: `Claim for case ${caseNo} not found or not yet completed.`,
          };
        }

        if (newMeds && newMeds.length > 0) {
          await updateCf4Meds(claim.code, newMeds, txn);
        }

        return await dumpClaim(caseNo, txn);
      });

      if (result?.error) {
        message = `[ERROR] ${result.error}`;
        status = `NOT DUMPED.`;
        statusDescription = result.error;
      }

      if (result?.warning) {
        message = `[WARNING] ${result.warning.toUpperCase()}`;
        status = `NOT DUMPED.`;
        statusDescription = result.warning.toUpperCase();
      }

      console.log(message);

      await appendCSV("./logs/status-logs.csv", [
        dateCharged,
        caseNo,
        status,
        statusDescription,
      ]);

      // errors.push({
      //   dateCharged,
      //   caseNo,
      //   ...(result.warning
      //     ? { warning: result.warning }
      //     : { error: result.error }),
      // });

      if (!result?.error) {
        await appendCSV("./logs/status-logs-billing.csv", [
          dateCharged,
          caseNo,
          status,
          statusDescription,
        ]);
      }
    }
  }

  // try {
  //   process.stdout.write("Writing error-logs.json... ");
  //   await fs.writeFile(
  //     path.resolve(
  //       process.cwd(),
  //       `./logs/${generateFileName("error-logs", "json")}`,
  //     ),
  //     JSON.stringify(errors),
  //   );
  //   console.log("Success.");
  // } catch (err) {
  //   console.log(err);
  // }

  console.log("Done.");
  process.exit();
})();

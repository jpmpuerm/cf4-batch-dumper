const initConn = require("../init-conns.js");
const db = require("../helpers/sql.js");

(async () => {
  await initConn();

  const claimsWithDuplicatedMeds = await db.query(
    `
      SELECT
        MIN(claimId) claimCode,
        COUNT(fieldCode) cnt
      FROM
        DocumentMgt..CF4ClaimDetails
      WHERE
        fieldCode = 'drugsOrMedicinesResult'
        AND status = 1
        --AND value like '%dateTimeCharged%'
      GROUP BY
        claimId, fieldCode
      HAVING
        COUNT(fieldCode) > 1;
    `,
  );

  for (const dupedMed of claimsWithDuplicatedMeds) {
    const meds = await db.select(
      "*",
      "DocumentMgt..Cf4ClaimDetails",
      {
        claimId: dupedMed.claimCode,
        fieldCode: "drugsOrMedicinesResult",
      },
      null,
      { orderBy: "id" },
    );

    console.log(meds.length);
    console.log(meds.pop());
    console.log(meds.length);
    break;
  }

  console.log("Done.");
  process.exit();
})();

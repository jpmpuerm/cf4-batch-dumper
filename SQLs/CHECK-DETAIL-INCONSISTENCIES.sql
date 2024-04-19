select
  MIN(claimId) claimId,
  COUNT(fieldCode) cnt
from
  DocumentMgt..CF4ClaimDetails
where
  fieldCode = 'drugsOrMedicinesResult'
  and status = 1
  and value like '%dateTimeCharged%'
group by
  claimId, fieldCode
having
  COUNT(fieldCode) > 1
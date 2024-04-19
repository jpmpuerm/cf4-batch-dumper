-- CLAIM DETAILS
select
  cd.*
from
  DocumentMgt..CF4ClaimDetails cd
  left join DocumentMgt..CF4Claims c ON c.Code = cd.ClaimId
where
  c.caseNo = '0098254'
  --cd.DeletedBy = '8225'
  and cd.fieldCode = 'drugsOrMedicinesResult'
  --and cd.status = 1




-- ECLAIMS
SELECT DISTINCT
  c.eClaimId,
  c.Id ConsultationId,
  p.Id PatientId,
  p.PatientLname,
  p.PatientFName,
  p.PatientMName,
  m.InstructionFrequency
FROM
  EasyClaimsOffline..medicine m
  LEFT JOIN EasyClaimsOffline..Consultation c on c.id = m.ConsultationId
  LEFT JOIN EasyClaimsOffline..Patient p on p.id = c.PatientId
  LEFT JOIN EasyClaimsOffline..PePert pe on pe.ConsultationId = c.id
  LEFT JOIN EasyClaimsOffline..PhysicalExamination pe2 on pe2.ConsultationId = c.id
WHERE
  m.module = 'CF4'
  AND convert(date, c.created) = '2024-04-17'
  AND c.CreatedBy = 'ccfd0310-37b4-4153-afd4-5b6d2e3797b7';
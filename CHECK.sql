-- CLAIM DETAILS
select * from uermmmc..cases where caseNo = '1225047B'
select * from DocumentMgt..CF4Claims where caseNo = '0098074'


-- ECLAIMS

select * from EasyClaimsOffline..patient where id = 1962;
select * from EasyClaimsOffline..Consultation where eClaimId = '0098078'
select * from EasyClaimsOffline..Medicine where consultationId = 44254


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
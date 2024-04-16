SELECT
  c.EClaimsTransmittalId,
  c.EClaimId CaseNo,
  p.Id PatientId,
  p.HciCaseNo,
  p.HciTransNo,
  e.HospitalCode,
  e.TransmittalNo,
  e.ReceiptTicketNo
FROM
  EasyClaimsOffline..Consultation c
  LEFT JOIN EasyClaimsOffline..Patient p ON p.Id = c.PatientId
  LEFT JOIN EasyClaimsOffline..Profile pro ON pro.PatientId = p.Id

  LEFT JOIN EasyClaimsOffline..PePert pePert ON pePert.ConsultationId = c.Id
  LEFT JOIN EasyClaimsOffline..PhysicalExamination pe ON pe.ConsultationId = c.Id
  LEFT JOIN EasyClaimsOffline..Medicine m ON m.ConsultationId = c.Id
  LEFT JOIN EasyClaimsOffline..CourseWard w ON w.ConsultationId = c.Id

  LEFT JOIN EasyClaimsOffline..Eclaim e ON e.ClaimNo = c.EClaimId

  LEFT JOIN EasyClaimsOffline..Cf4Claim cf4 ON
    cf4.PatientId = p.Id
    AND cf4.ConsultationId = c.Id 
    AND cf4.EClaimId = e.Id
WHERE
  c.EClaimId = '0097169';
-- SELECT TEST PATIENT WITH PHIC PIN, CF4 AND OTHER CRITERIA
SELECT DISTINCT
  cf4.Code,
  c.CaseNo,
  p.PatientNo,
  cf4d.FieldCode,
  cf4d.Value
FROM
  UERMMMC..PatientInfo p
  LEFT JOIN UERMMMC..Cases c on c.patientNo = p.patientNo
  LEFT JOIN DocumentMgt..CF4Claims cf4 ON cf4.CaseNo = c.caseNo
  LEFT JOIN DocumentMgt..CF4ClaimDetails cf4d ON cf4d.ClaimId = cf4.Code
WHERE
  ISNULL(p.UDF_PHILHEALTHNO, '') <> ''
  AND c.patientType = 'IPD'
  AND ISNULL(c.DateDis, '') <> ''
  AND ISNULL(cf4.id, '') <> ''
  AND cf4.Status = 3
  --AND cf4d.FieldCode = 'symptomsPainRemarks'
  AND cf4d.Value LIKE '%Quantity%'
  AND CONVERT(DATE, c.DateAd) BETWEEN '2024-02-01' AND '2024-03-07';
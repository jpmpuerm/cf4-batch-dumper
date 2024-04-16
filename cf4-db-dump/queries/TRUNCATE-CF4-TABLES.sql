/* DECLARE @UserCode NVARCHAR(50) = '7679'
DECLARE @From DATE = '2024-04-11'
DECLARE @To DATE = '2024-04-11'

UPDATE DocumentMgt..CF4Claims SET
  Status = 3,
  CompletedBy = NULL,
  DateTimeCompleted = NULL
WHERE
  CONVERT(DATE, dateTimeCompleted) BETWEEN @From AND @To
  AND CompletedBy = @UserCode

DELETE FROM
  DocumentMgt..ClaimHistories
WHERE
  CONVERT(DATE, DateTimeCreated) BETWEEN @From AND @To
  AND CreatedBy = @UserCode */

TRUNCATE TABLE DocumentMgt..CF4Claims;
TRUNCATE TABLE DocumentMgt..CF4ClaimDetails;
TRUNCATE TABLE DocumentMgt..ClaimHistories;


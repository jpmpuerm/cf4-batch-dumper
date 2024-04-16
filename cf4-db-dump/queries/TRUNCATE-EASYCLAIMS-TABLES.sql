-- TABLES NOT INCLUDED IN THE DEV KIT BUT SHOULD BE TRUNCATED TO TRUNCATE EasyClaimsOffline..EClaim
DELETE FROM EasyClaimsOffline..ProfessionalUseForCf4;
DBCC CHECKIDENT ('EasyClaimsOffline..ProfessionalUseForCf4', RESEED, 0);

DELETE FROM EasyClaimsOffline..DocumentAttachment;
DBCC CHECKIDENT ('EasyClaimsOffline..DocumentAttachment', RESEED, 0);

-- CONSULTATION
DELETE FROM EasyClaimsOffline..Subjective;

DELETE FROM EasyClaimsOffline..PePert;
DBCC CHECKIDENT ('EasyClaimsOffline..PePert', RESEED, 0);

DELETE FROM EasyClaimsOffline..PhysicalExamination;
DBCC CHECKIDENT ('EasyClaimsOffline..PhysicalExamination', RESEED, 0);

DELETE FROM EasyClaimsOffline..CourseWard;
DBCC CHECKIDENT ('EasyClaimsOffline..CourseWard', RESEED, 0);

DELETE FROM EasyClaimsOffline..Medicine;
DBCC CHECKIDENT ('EasyClaimsOffline..Medicine', RESEED, 0);

DELETE FROM EasyClaimsOffline..Consultation;
DBCC CHECKIDENT ('EasyClaimsOffline..Consultation', RESEED, 0);


-- PATIENT PROFILE
DELETE FROM EasyClaimsOffline..MenstrualHistory;

DELETE FROM EasyClaimsOffline..MedicalHistory;
DBCC CHECKIDENT ('EasyClaimsOffline..MedicalHistory', RESEED, 0);

DELETE FROM EasyClaimsOffline..Profile;

DELETE FROM EasyClaimsOffline..Patient;
DBCC CHECKIDENT ('EasyClaimsOffline..Patient', RESEED, 0);



-- PHIC CF4
DELETE FROM EasyClaimsOffline..CF4Claim;

DELETE FROM EasyClaimsOffline..EClaim;
DBCC CHECKIDENT ('EasyClaimsOffline..EClaim', RESEED, 0);


USE [EasyClaimsOffline]
GO
/****** Object:  Table [dbo].[CF4Claim]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CF4Claim](
	[PatientId] [int] NOT NULL,
	[ConsultationId] [int] NOT NULL,
	[EClaimId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.CF4Claim] PRIMARY KEY CLUSTERED 
(
	[PatientId] ASC,
	[ConsultationId] ASC,
	[EClaimId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Consultation]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Consultation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NOT NULL,
	[SOAPDate] [datetime] NOT NULL,
	[SOAPATC] [nvarchar](10) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[EClaimsTransmittalId] [nvarchar](50) NULL,
	[EClaimId] [nvarchar](12) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.Consultation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CourseWard]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseWard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConsultationId] [int] NOT NULL,
	[DateAction] [datetime] NOT NULL,
	[DoctorsAction] [nvarchar](2000) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.CourseWard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EClaim]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HospitalCode] [nvarchar](12) NOT NULL,
	[TransmittalNo] [nvarchar](50) NULL,
	[ReceiptTicketNo] [nvarchar](20) NULL,
	[ClaimNo] [nvarchar](12) NOT NULL,
	[ClaimSeriesLHIO] [nvarchar](15) NULL,
	[TrackingNo] [nvarchar](20) NULL,
	[PatientLastName] [nvarchar](60) NOT NULL,
	[PatientFirstName] [nvarchar](60) NOT NULL,
	[PatientMiddleName] [nvarchar](60) NOT NULL,
	[PatientSuffix] [nvarchar](7) NULL,
	[AdmissionDate] [datetime] NOT NULL,
	[DischargeDate] [datetime] NOT NULL,
	[ClaimType] [int] NOT NULL,
	[PatientType] [int] NOT NULL,
	[IsEmergency] [bit] NOT NULL,
	[IsFinal] [bit] NOT NULL,
	[IsOffline] [bit] NOT NULL,
	[XmlData] [nvarchar](max) NOT NULL,
	[IsProcessed] [bit] NOT NULL,
	[Processed] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
	[DocReference] [nvarchar](256) NULL,
	[VoucherNo] [nvarchar](16) NULL,
	[VoucherDate] [datetime] NULL,
	[ChequeNo] [nvarchar](10) NULL,
	[ChequeDate] [datetime] NULL,
	[IsComplete] [bit] NULL,
	[IsRefiled] [bit] NULL,
	[Refiled] [datetime] NULL,
	[FirstCaseRateCode] [nvarchar](6) NULL,
	[FirstCaseRateType] [nvarchar](3) NULL,
	[FirstItemCode] [nvarchar](15) NULL,
	[FirstCaseRateAmount] [decimal](18, 2) NULL,
	[SecondCaseRateCode] [nvarchar](6) NULL,
	[SecondCaseRateType] [nvarchar](3) NULL,
	[SecondItemCode] [nvarchar](15) NULL,
	[SecondCaseRateAmount] [decimal](18, 2) NULL,
	[TotalCaseRateAmount] [decimal](18, 2) NULL,
	[TotalClaimAmountPaid] [decimal](18, 2) NULL,
	[ProfessionalFeesSummary] [nvarchar](max) NULL,
	[XmlCharges] [nvarchar](max) NULL,
	[ChargesSummary] [nvarchar](max) NULL,
	[HISRefNo] [nvarchar](50) NULL,
	[EnoughBenefits] [bit] NULL,
	[HCIFees] [decimal](18, 2) NULL,
	[ProfFees] [decimal](18, 2) NULL,
	[SessionCount] [int] NULL,
	[SessionSummary] [nvarchar](max) NULL,
	[XmlCF4] [nvarchar](max) NULL,
	[WithCF4] [bit] NULL,
	[BypassValidation] [bit] NULL,
	[Reason] [nvarchar](max) NULL,
	[MedEncId] [int] NULL,
	[SOAPNoteId] [int] NULL,
	[ProcessedBy] [nvarchar](128) NULL,
	[RefiledBy] [nvarchar](128) NULL,
	[IsExported] [bit] NULL,
	[StatusAsOf] [datetime] NULL,
	[PatientDOB] [datetime] NULL,
	[IsNewBorn] [bit] NULL,
	[IsAutoComputeBenefits] [bit] NULL,
	[RTHDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.EClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MedicalHistory]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NOT NULL,
	[Patient] [bit] NULL,
	[Family] [bit] NULL,
	[Allergy] [bit] NULL,
	[AllergySpecDesc] [nvarchar](max) NULL,
	[Asthma] [bit] NULL,
	[AsthmaSpecDesc] [nvarchar](max) NULL,
	[Cancer] [bit] NULL,
	[CancerSpecDesc] [nvarchar](max) NULL,
	[CerebrovascularDisease] [bit] NULL,
	[CerebrovascularDiseaseSpecDesc] [nvarchar](max) NULL,
	[CoronaryArteryDisease] [bit] NULL,
	[CoronaryArteryDiseaseSpecDesc] [nvarchar](max) NULL,
	[DiabetesMellitus] [bit] NULL,
	[DiabetesMellitusSpecDesc] [nvarchar](max) NULL,
	[Emphysema] [bit] NULL,
	[EmphysemaSpecDesc] [nvarchar](max) NULL,
	[EpilepsySeizureDisorder] [bit] NULL,
	[EpilepsySeizureDisorderSpecDesc] [nvarchar](max) NULL,
	[Hepatitis] [bit] NULL,
	[HepatitisSpecDesc] [nvarchar](max) NULL,
	[Hyperlipidemia] [bit] NULL,
	[HyperlipidemiaSpecDesc] [nvarchar](max) NULL,
	[Hypertension] [bit] NULL,
	[HypertensionSpecDesc] [nvarchar](max) NULL,
	[PepticUlcer] [bit] NULL,
	[PepticUlcerSpecDesc] [nvarchar](max) NULL,
	[Pneumonia] [bit] NULL,
	[PneumoniaSpecDesc] [nvarchar](max) NULL,
	[ThyroidDisease] [bit] NULL,
	[ThyroidDiseaseSpecDesc] [nvarchar](max) NULL,
	[PulmonaryTuberculosis] [bit] NULL,
	[PulmonaryTuberculosisSpecDesc] [nvarchar](max) NULL,
	[ExtrapulmonaryTuberculosis] [bit] NULL,
	[ExtrapulmonaryTuberculosisSpecDesc] [nvarchar](max) NULL,
	[UrinaryTractInfection] [bit] NULL,
	[UrinaryTractInfectionSpecDesc] [nvarchar](max) NULL,
	[MentalIllness] [bit] NULL,
	[MentalIllnessSpecDesc] [nvarchar](max) NULL,
	[Others] [bit] NULL,
	[OthersSpecDesc] [nvarchar](max) NULL,
	[None] [bit] NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.MedicalHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Medicine]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicine](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[ConsultationId] [int] NULL,
	[FacilityType] [nvarchar](1) NOT NULL,
	[DrugCode] [nvarchar](30) NOT NULL,
	[GenericCode] [nvarchar](5) NOT NULL,
	[SaltCode] [nvarchar](5) NOT NULL,
	[GenericName] [nvarchar](500) NOT NULL,
	[StrengthCode] [nvarchar](5) NOT NULL,
	[FormCode] [nvarchar](5) NOT NULL,
	[UnitCode] [nvarchar](5) NOT NULL,
	[PackageCode] [nvarchar](5) NOT NULL,
	[Route] [nvarchar](500) NOT NULL,
	[Quantity] [float] NOT NULL,
	[ActualUnitPrice] [decimal](18, 2) NULL,
	[CoPayment] [decimal](18, 2) NULL,
	[TotalAmtPrice] [decimal](18, 2) NOT NULL,
	[InstructionQuantity] [float] NULL,
	[InstructionStrength] [nvarchar](50) NOT NULL,
	[InstructionFrequency] [nvarchar](50) NOT NULL,
	[PrescPhysician] [nvarchar](max) NULL,
	[IsApplicable] [nvarchar](1) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[Module] [nvarchar](4) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
	[MedicineLibraryId] [int] NULL,
 CONSTRAINT [PK_dbo.Medicine] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenstrualHistory]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenstrualHistory](
	[PatientId] [int] NOT NULL,
	[MenarchePeriod] [int] NULL,
	[LastMensPeriod] [datetime] NULL,
	[PeriodDuration] [int] NULL,
	[MensInterval] [int] NULL,
	[PadsPerDay] [int] NULL,
	[OnsetSexIc] [int] NULL,
	[BirthCtrlMethod] [nvarchar](21) NULL,
	[IsMenopause] [nvarchar](1) NOT NULL,
	[IsApplicable] [nvarchar](1) NOT NULL,
	[MenopauseAge] [int] NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.MenstrualHistory] PRIMARY KEY CLUSTERED 
(
	[PatientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Patient]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HciCaseNo] [nvarchar](21) NOT NULL,
	[HciTransNo] [nvarchar](21) NULL,
	[EffYear] [nvarchar](4) NOT NULL,
	[EnlistStat] [nvarchar](1) NULL,
	[EnlistDate] [datetime] NOT NULL,
	[PackageType] [nvarchar](1) NOT NULL,
	[MemPin] [nvarchar](12) NOT NULL,
	[MemFname] [nvarchar](60) NOT NULL,
	[MemMname] [nvarchar](60) NOT NULL,
	[MemLname] [nvarchar](60) NOT NULL,
	[MemExtname] [nvarchar](60) NULL,
	[MemDob] [datetime] NULL,
	[MemCat] [nvarchar](1) NULL,
	[MemNcat] [nvarchar](5) NULL,
	[PatientPin] [nvarchar](12) NOT NULL,
	[PatientFname] [nvarchar](60) NOT NULL,
	[PatientMname] [nvarchar](60) NOT NULL,
	[PatientLname] [nvarchar](60) NOT NULL,
	[PatientExtname] [nvarchar](60) NULL,
	[PatientType] [nvarchar](2) NOT NULL,
	[PatientSex] [nvarchar](1) NOT NULL,
	[PatientContactno] [nvarchar](15) NOT NULL,
	[PatientDob] [datetime] NOT NULL,
	[PatientAddbrgy] [nvarchar](3) NOT NULL,
	[PatientAddmun] [nvarchar](2) NOT NULL,
	[PatientAddprov] [nvarchar](2) NOT NULL,
	[PatientAddreg] [nvarchar](2) NOT NULL,
	[PatientAddzipcode] [nvarchar](max) NOT NULL,
	[CivilStatus] [nvarchar](1) NOT NULL,
	[WithConsent] [nvarchar](1) NOT NULL,
	[WithLoa] [nvarchar](1) NOT NULL,
	[WithDisability] [nvarchar](1) NOT NULL,
	[DependentType] [nvarchar](1) NOT NULL,
	[TransDate] [datetime] NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[AvailFreeService] [nvarchar](1) NOT NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.Patient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PEPERT]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEPERT](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[ConsultationId] [int] NULL,
	[Systolic] [float] NULL,
	[Diastolic] [float] NULL,
	[Hr] [float] NOT NULL,
	[Rr] [float] NOT NULL,
	[Temp] [float] NOT NULL,
	[Height] [float] NULL,
	[Weight] [float] NULL,
	[Vision] [nvarchar](10) NOT NULL,
	[Length] [float] NULL,
	[HeadCirc] [float] NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
	[SystolicDiastolicBp] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.PEPERT] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalExamination]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalExamination](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[ConsultationId] [int] NULL,
	[GenSurveyId] [nvarchar](1) NOT NULL,
	[GenSurveyRem] [nvarchar](2000) NOT NULL,
	[SkinEssentiallyNormal] [bit] NULL,
	[Clubbing] [bit] NULL,
	[ColdClammy] [bit] NULL,
	[CyanosisMottledSkin] [bit] NULL,
	[EdemaSwelling] [bit] NULL,
	[DecreasedMobility] [bit] NULL,
	[PaleNailbeds] [bit] NULL,
	[PoorSkinTurgor] [bit] NULL,
	[RashesPetechiae] [bit] NULL,
	[WeakPulses] [bit] NULL,
	[SkinOthers] [bit] NULL,
	[AnictericSclerae] [bit] NULL,
	[IntactTympanicMebrane] [bit] NULL,
	[PupilsBriskyReactiveToLight] [bit] NULL,
	[TonsillopharyngealCongestion] [bit] NULL,
	[HypertropicTonsils] [bit] NULL,
	[AlarFlaring] [bit] NULL,
	[NasalDischarge] [bit] NULL,
	[AuralDischarge] [bit] NULL,
	[HeentPalpableMass] [bit] NULL,
	[Exudates] [bit] NULL,
	[HeentEssentiallyNormal] [bit] NULL,
	[AbnormalPupillaryReaction] [bit] NULL,
	[CervicalLympadenopathy] [bit] NULL,
	[DryMucousMembrane] [bit] NULL,
	[IctericSclerae] [bit] NULL,
	[PaleConjunctivae] [bit] NULL,
	[SunkenEyeballs] [bit] NULL,
	[SunkenFontanelle] [bit] NULL,
	[HeentOthers] [bit] NULL,
	[SymmetricalChestExpansion] [bit] NULL,
	[ClearBreathSounds] [bit] NULL,
	[Retractions] [bit] NULL,
	[CracklesRales] [bit] NULL,
	[Wheezes] [bit] NULL,
	[ChestEssentiallyNormal] [bit] NULL,
	[AsymmetricalChestExpansion] [bit] NULL,
	[DecreasedBreathSounds] [bit] NULL,
	[EnlargeAxillaryLymphNodes] [bit] NULL,
	[LumpsOverBreasts] [bit] NULL,
	[ChestOthers] [bit] NULL,
	[AdynamicPrecordium] [bit] NULL,
	[NormalRateRegularRhythm] [bit] NULL,
	[HeavesTrills] [bit] NULL,
	[Murmurs] [bit] NULL,
	[HeartEssentiallyNormal] [bit] NULL,
	[DisplacedApexBeat] [bit] NULL,
	[IrregularRhythm] [bit] NULL,
	[MuffledHeartSounds] [bit] NULL,
	[PericardialBulge] [bit] NULL,
	[HeartOthers] [bit] NULL,
	[Flat] [bit] NULL,
	[Flabby] [bit] NULL,
	[Globullar] [bit] NULL,
	[MuscleGuarding] [bit] NULL,
	[Tenderness] [bit] NULL,
	[AbdomenPalpableMass] [bit] NULL,
	[AbdomenEssentiallyNormal] [bit] NULL,
	[AbdominalRigidity] [bit] NULL,
	[AbdominalTenderness] [bit] NULL,
	[HyperactiveBowelSounds] [bit] NULL,
	[AbdomenPalpableMasses] [bit] NULL,
	[TympaniticDullAbdomen] [bit] NULL,
	[UterineContraction] [bit] NULL,
	[AbdomenOthers] [bit] NULL,
	[DevelopmentalDelay] [bit] NULL,
	[Seizures] [bit] NULL,
	[Normal] [bit] NULL,
	[MotorDeficit] [bit] NULL,
	[SensoryDeficit] [bit] NULL,
	[NeuroEssentiallyNormal] [bit] NULL,
	[AbnormalGait] [bit] NULL,
	[AbnormalPositionSense] [bit] NULL,
	[AbnormalSensation] [bit] NULL,
	[AbnormalReflexes] [bit] NULL,
	[PoorAlteredMemory] [bit] NULL,
	[PoorMuscleToneStrength] [bit] NULL,
	[PoorCoordination] [bit] NULL,
	[NeuroOthers] [bit] NULL,
	[RectalEssentiallyNormal] [bit] NULL,
	[EnlargeProspate] [bit] NULL,
	[Mass] [bit] NULL,
	[Hemorrhoids] [bit] NULL,
	[Pus] [bit] NULL,
	[GenitourinaryEssentiallyNormal] [bit] NULL,
	[BloodStainedInExamFinger] [bit] NULL,
	[CervicalDilatation] [bit] NULL,
	[PresenceOfAbnormalDischarge] [bit] NULL,
	[GenitourinaryOthers] [bit] NULL,
	[SkinRem] [nvarchar](2000) NULL,
	[HeentRem] [nvarchar](2000) NULL,
	[ChestRem] [nvarchar](2000) NULL,
	[HeartRem] [nvarchar](2000) NULL,
	[AbdomenRem] [nvarchar](2000) NULL,
	[NeuroRem] [nvarchar](2000) NULL,
	[RectalRem] [nvarchar](2000) NULL,
	[GuRem] [nvarchar](2000) NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.PhysicalExamination] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Profile]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[PatientId] [int] NOT NULL,
	[ProfDate] [datetime] NOT NULL,
	[PatientPob] [nvarchar](4) NOT NULL,
	[PatientAge] [nvarchar](30) NOT NULL,
	[PatientOccupation] [nvarchar](100) NOT NULL,
	[PatientEducation] [nvarchar](1) NOT NULL,
	[PatientReligion] [nvarchar](250) NOT NULL,
	[PatientMotherMnln] [nvarchar](50) NOT NULL,
	[PatientMotherFn] [nvarchar](250) NOT NULL,
	[PatientMotherMnmi] [nvarchar](50) NOT NULL,
	[PatientMotherExtn] [nvarchar](50) NULL,
	[PatientMotherBday] [datetime] NULL,
	[PatientFatherLn] [nvarchar](50) NOT NULL,
	[PatientFatherFn] [nvarchar](250) NOT NULL,
	[PatientFatherMi] [nvarchar](50) NOT NULL,
	[PatientFatherExtn] [nvarchar](50) NULL,
	[PatientFatherBday] [datetime] NULL,
	[Remarks] [nvarchar](2000) NULL,
	[ProfileATC] [nvarchar](10) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_dbo.Profile] PRIMARY KEY CLUSTERED 
(
	[PatientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subjective]    Script Date: 3/1/2024 3:41:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subjective](
	[ConsultationId] [int] NOT NULL,
	[ChiefComplaint] [nvarchar](2000) NOT NULL,
	[IllnessHistory] [nvarchar](2000) NOT NULL,
	[OtherComplaint] [nvarchar](2000) NOT NULL,
	[SignsSymptoms] [nvarchar](2000) NOT NULL,
	[PainSite] [nvarchar](2000) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
CONSTRAINT [PK_dbo.Subjective] PRIMARY KEY CLUSTERED 
(
	[ConsultationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CF4Claim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CF4Claim_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[CF4Claim] CHECK CONSTRAINT [FK_dbo.CF4Claim_dbo.Consultation_ConsultationId]
GO
ALTER TABLE [dbo].[CF4Claim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CF4Claim_dbo.EClaim_EClaimId] FOREIGN KEY([EClaimId])
REFERENCES [dbo].[EClaim] ([Id])
GO
ALTER TABLE [dbo].[CF4Claim] CHECK CONSTRAINT [FK_dbo.CF4Claim_dbo.EClaim_EClaimId]
GO
ALTER TABLE [dbo].[CF4Claim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CF4Claim_dbo.Patient_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[CF4Claim] CHECK CONSTRAINT [FK_dbo.CF4Claim_dbo.Patient_PatientId]
GO
ALTER TABLE [dbo].[Consultation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Consultation_dbo.Patient_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[Consultation] CHECK CONSTRAINT [FK_dbo.Consultation_dbo.Patient_PatientId]
GO
ALTER TABLE [dbo].[CourseWard]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CourseWard_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[CourseWard] CHECK CONSTRAINT [FK_dbo.CourseWard_dbo.Consultation_ConsultationId]
GO
ALTER TABLE [dbo].[EClaim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EClaim_dbo.AspNetUsers_ProcessedBy] FOREIGN KEY([ProcessedBy])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[EClaim] CHECK CONSTRAINT [FK_dbo.EClaim_dbo.AspNetUsers_ProcessedBy]
GO
ALTER TABLE [dbo].[EClaim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EClaim_dbo.AspNetUsers_RefiledBy] FOREIGN KEY([RefiledBy])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[EClaim] CHECK CONSTRAINT [FK_dbo.EClaim_dbo.AspNetUsers_RefiledBy]
GO
ALTER TABLE [dbo].[EClaim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EClaim_dbo.MedicalEncounter_MedEncId] FOREIGN KEY([MedEncId])
REFERENCES [dbo].[MedicalEncounter] ([MedicalEncId])
GO
ALTER TABLE [dbo].[EClaim] CHECK CONSTRAINT [FK_dbo.EClaim_dbo.MedicalEncounter_MedEncId]
GO
ALTER TABLE [dbo].[EClaim]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EClaim_dbo.SOAPNote_SOAPNoteId] FOREIGN KEY([SOAPNoteId])
REFERENCES [dbo].[SOAPNote] ([Id])
GO
ALTER TABLE [dbo].[EClaim] CHECK CONSTRAINT [FK_dbo.EClaim_dbo.SOAPNote_SOAPNoteId]
GO
ALTER TABLE [dbo].[MedicalHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MedicalHistory_dbo.Profile_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Profile] ([PatientId])
GO
ALTER TABLE [dbo].[MedicalHistory] CHECK CONSTRAINT [FK_dbo.MedicalHistory_dbo.Profile_PatientId]
GO
ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Medicine_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [FK_dbo.Medicine_dbo.Consultation_ConsultationId]
GO
ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [FK_dbo.Medicine_dbo.MedicineLibrary_MedicineLibraryId]
GO
ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Medicine_dbo.Profile_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Profile] ([PatientId])
GO
ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [FK_dbo.Medicine_dbo.Profile_PatientId]
GO
ALTER TABLE [dbo].[MenstrualHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MenstrualHistory_dbo.Profile_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Profile] ([PatientId])
GO
ALTER TABLE [dbo].[MenstrualHistory] CHECK CONSTRAINT [FK_dbo.MenstrualHistory_dbo.Profile_PatientId]
GO
ALTER TABLE [dbo].[PEPERT]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PEPERT_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[PEPERT] CHECK CONSTRAINT [FK_dbo.PEPERT_dbo.Consultation_ConsultationId]
GO
ALTER TABLE [dbo].[PEPERT]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PEPERT_dbo.Profile_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Profile] ([PatientId])
GO
ALTER TABLE [dbo].[PEPERT] CHECK CONSTRAINT [FK_dbo.PEPERT_dbo.Profile_PatientId]
GO
ALTER TABLE [dbo].[PhysicalExamination]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PhysicalExamination_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[PhysicalExamination] CHECK CONSTRAINT [FK_dbo.PhysicalExamination_dbo.Consultation_ConsultationId]
GO
ALTER TABLE [dbo].[PhysicalExamination]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PhysicalExamination_dbo.Profile_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Profile] ([PatientId])
GO
ALTER TABLE [dbo].[PhysicalExamination] CHECK CONSTRAINT [FK_dbo.PhysicalExamination_dbo.Profile_PatientId]
GO
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Profile_dbo.Patient_PatientId] FOREIGN KEY([PatientId])
REFERENCES [dbo].[Patient] ([Id])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_dbo.Profile_dbo.Patient_PatientId]
GO
ALTER TABLE [dbo].[Subjective]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Subjective_dbo.Consultation_ConsultationId] FOREIGN KEY([ConsultationId])
REFERENCES [dbo].[Consultation] ([Id])
GO
ALTER TABLE [dbo].[Subjective] CHECK CONSTRAINT [FK_dbo.Subjective_dbo.Consultation_ConsultationId]
GO

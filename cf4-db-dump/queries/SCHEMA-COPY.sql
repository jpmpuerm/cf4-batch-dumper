USE [PhicEasyClaims]
GO
/****** Object:  Table [dbo].[CF4Claim]    Script Date: 07/03/2024 5:13:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CF4Claim](
	[PatientId] [int] NOT NULL,
	[ConsultationId] [int] NOT NULL,
	[EClaimId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Consultation]    Script Date: 07/03/2024 5:13:28 pm ******/
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
 CONSTRAINT [PK_Consultation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseWard]    Script Date: 07/03/2024 5:13:28 pm ******/
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
 CONSTRAINT [PK_CourseWard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EClaim]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[PatientSuffix] [nvarchar](5) NULL,
	[AdmissionDate] [datetime] NOT NULL,
	[DischargeDate] [datetime] NOT NULL,
	[ClaimType] [int] NOT NULL,
	[PatientType] [int] NOT NULL,
	[IsEmergency] [bit] NOT NULL,
	[IsFinal] [bit] NOT NULL,
	[IsOffline] [bit] NOT NULL,
	[XmlData] [nvarchar](max) NULL,
	[IsProcessed] [bit] NOT NULL,
	[Processed] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
	[DocReference] [nchar](10) NULL,
	[VoucherNo] [nvarchar](16) NULL,
	[VoucherDate] [datetime] NULL,
	[ChequeNo] [nvarchar](10) NULL,
	[ChequeDate] [datetime] NULL,
	[IsComplete] [bit] NOT NULL,
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
	[HISRefNo] [nchar](10) NULL,
	[EnoughBenefits] [bit] NULL,
	[HCIFees] [decimal](18, 2) NULL,
	[SessionCount] [int] NULL,
	[SessionSummary] [nvarchar](max) NULL,
	[XmlCF4] [nvarchar](max) NULL,
	[WithCF4] [bit] NULL,
 CONSTRAINT [PK_EClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalHistory]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[Updated] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medicine]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[Module] [nvarchar](4) NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL,
 CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenstrualHistory]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[IsApplicable] [nvarchar](1) NULL,
	[MenopauseAge] [int] NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[MemFName] [nvarchar](60) NOT NULL,
	[MemMName] [nvarchar](60) NOT NULL,
	[MemLName] [nvarchar](60) NOT NULL,
	[MemExtName] [nvarchar](60) NULL,
	[MemDob] [datetime] NULL,
	[MemCat] [nvarchar](1) NULL,
	[MemNCat] [nvarchar](5) NULL,
	[PatientPin] [nvarchar](12) NOT NULL,
	[PatientFName] [nvarchar](60) NOT NULL,
	[PatientMName] [nvarchar](60) NOT NULL,
	[PatientLName] [nvarchar](60) NOT NULL,
	[PatientExtName] [nvarchar](60) NULL,
	[PatientType] [nvarchar](2) NOT NULL,
	[PatientSex] [nvarchar](1) NOT NULL,
	[PatientContactNo] [nvarchar](15) NOT NULL,
	[PatientDob] [datetime] NOT NULL,
	[PatientAddBrgy] [nvarchar](1000) NOT NULL,
	[PatientAddMun] [nvarchar](1000) NOT NULL,
	[PatientAddProv] [nvarchar](1000) NOT NULL,
	[PatientAddReg] [nvarchar](1000) NOT NULL,
	[PatientAddZipCode] [nvarchar](10) NOT NULL,
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
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PEPERT]    Script Date: 07/03/2024 5:13:28 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PEPERT](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PatientId] [int] NULL,
	[ConsultationId] [int] NULL,
	[Systolic] [float] NOT NULL,
	[Diastolic] [float] NOT NULL,
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
 CONSTRAINT [PK_PEPERT] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhysicalExamination]    Script Date: 07/03/2024 5:13:28 pm ******/
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
 CONSTRAINT [PK_PhysicalExamination] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Profile]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[ReportStatus] [nvarchar](10) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subjective]    Script Date: 07/03/2024 5:13:28 pm ******/
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
	[PainSite] [nvarchar](1000) NOT NULL,
	[ReportStatus] [nvarchar](1) NOT NULL,
	[DeficiencyRemarks] [nvarchar](2000) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[Created] [datetime] NOT NULL,
	[UpdatedBy] [nvarchar](128) NULL,
	[Updated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Consultation] ADD  CONSTRAINT [DF_Consultation_SOAPATC]  DEFAULT ('') FOR [SOAPATC]
GO
ALTER TABLE [dbo].[Consultation] ADD  CONSTRAINT [DF_Consultation_ReportStatus]  DEFAULT ('U') FOR [ReportStatus]
GO
ALTER TABLE [dbo].[Consultation] ADD  CONSTRAINT [DF_Consultation_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[CourseWard] ADD  CONSTRAINT [DF_CourseWard_ReportStatus]  DEFAULT ('U') FOR [ReportStatus]
GO
ALTER TABLE [dbo].[CourseWard] ADD  CONSTRAINT [DF_CourseWard_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_HospitalCode]  DEFAULT ('') FOR [HospitalCode]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_PatientMiddleName]  DEFAULT ('N/A') FOR [PatientMiddleName]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_ClaimType]  DEFAULT ((1)) FOR [ClaimType]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_IsEmergency]  DEFAULT ((0)) FOR [IsEmergency]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_IsOffline]  DEFAULT ((1)) FOR [IsOffline]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_IsProcessed]  DEFAULT ((0)) FOR [IsProcessed]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_Updated]  DEFAULT (getdate()) FOR [Updated]
GO
ALTER TABLE [dbo].[EClaim] ADD  CONSTRAINT [DF_EClaim_IsComplete]  DEFAULT ((1)) FOR [IsComplete]
GO
ALTER TABLE [dbo].[Medicine] ADD  CONSTRAINT [DF_Medicine_Module]  DEFAULT ('CF4') FOR [Module]
GO
ALTER TABLE [dbo].[Medicine] ADD  CONSTRAINT [DF_Medicine_ReportStatus]  DEFAULT ('U') FOR [ReportStatus]
GO
ALTER TABLE [dbo].[MenstrualHistory] ADD  CONSTRAINT [DF_MenstrualHistory_IsMenopause]  DEFAULT ('') FOR [IsMenopause]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_MemMName]  DEFAULT ('') FOR [MemMName]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientMName]  DEFAULT ('') FOR [PatientMName]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientContactNo]  DEFAULT ('NA') FOR [PatientContactNo]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientAddBrgy]  DEFAULT ('') FOR [PatientAddBrgy]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientAddMun]  DEFAULT ('') FOR [PatientAddMun]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientAddProv]  DEFAULT ('') FOR [PatientAddProv]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientAddReg]  DEFAULT ('') FOR [PatientAddReg]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_PatientAddZipCode]  DEFAULT ('') FOR [PatientAddZipCode]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_CivilStatus]  DEFAULT ('U') FOR [CivilStatus]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_WithConsent]  DEFAULT ('X') FOR [WithConsent]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_WithLoa]  DEFAULT ('X') FOR [WithLoa]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_WithDisability]  DEFAULT ('X') FOR [WithDisability]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_DependentType]  DEFAULT ('X') FOR [DependentType]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_ReportStatus]  DEFAULT ('U') FOR [ReportStatus]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_AvailFreeService]  DEFAULT ('X') FOR [AvailFreeService]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF_Patient_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientPob]  DEFAULT ('') FOR [PatientPob]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientAge]  DEFAULT ('') FOR [PatientAge]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientOccupation]  DEFAULT ('') FOR [PatientOccupation]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientEducation]  DEFAULT ('') FOR [PatientEducation]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientReligion]  DEFAULT ('') FOR [PatientReligion]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientMotherMnln]  DEFAULT ('') FOR [PatientMotherMnln]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientMotherFn]  DEFAULT ('') FOR [PatientMotherFn]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientMotherMnmi]  DEFAULT ('') FOR [PatientMotherMnmi]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientFatherLn]  DEFAULT ('') FOR [PatientFatherLn]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientFatherFn]  DEFAULT ('') FOR [PatientFatherFn]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_PatientFatherMi]  DEFAULT ('') FOR [PatientFatherMi]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_ProfileATC]  DEFAULT ('') FOR [ProfileATC]
GO
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_ReportStatus]  DEFAULT ('U') FOR [ReportStatus]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = INPATIENT, 2 = OUTPATIENT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EClaim', @level2type=N'COLUMN',@level2name=N'PatientType'
GO

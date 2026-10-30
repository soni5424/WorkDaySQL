USE [Hartono]
GO

/****** Object:  View [dbo].[VBWMasterMember_ALL]    Script Date: 14/10/2026 14.45.57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Arnol
-- Create date	: 06/03/2024
-- Description	: Connect MasterMember & [10.50.5.59] temp table from PostgreSQL
-- =============================================
-- =============================================
-- Modified	By	: Soni
-- Modified Date: 07/10/2026
-- Description	: Add Status (HPC, HRM, Corporate, Payer)
-- SELECT distinct status FROM VBWMasterMember_ALL
-- =============================================
-- =============================================
-- Modified	By	: Soni
-- Modified Date: 14/10/2026
-- Description	: Edit Email dan NoTelp agar ambil dari table 
--                  HPC         -> MasterMemberHPC
--                  HRM         -> MasterMemberHRM
--                  Corporate   -> MasterMemberCorporate
-- =============================================

-- SELECT top 10 * FROM VBWMasterMember_ALL
-- select count(*) from VBWMasterMember_ALL
-- SELECT distinct Email, NoTelp FROM VBWMasterMember_ALL


ALTER VIEW [dbo].[VBWMasterMember_ALL] 
AS

	-- HPC
	SELECT m.[NoMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaMember]) [NamaMember]
      ,m.[NoKTP]
      ,m.[NoSIM]
      ,m.[NoKartuMember]
      ,CONVERT(VARCHAR(10), m.[TglLahirMember], 112) [TglLahirMember]
      ,CONVERT(VARCHAR(10), m.[TglJadiMember], 112) [TglJadiMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat]) [Alamat]
      ,m.[Kota]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.phone_number) [NoTelp]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoHP]) [NoHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.email) [Email]
      ,m.[JenisKelamin]
      ,m.[StatusPerkawinan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaIbuKandung]) [NamaIbuKandung]
      ,m.[KreditLimit]
      ,m.[RewardPoint]
      ,m.[KodeStore]
      ,m.[Piutang]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatLama]) [AlamatLama]
      ,m.[TipeMember]
      ,CONVERT(VARCHAR(10), m.[TglBatasKartuMember], 112) [TglBatasKartuMember]
      ,m.[ContactPerson]
      ,m.[PaymentTerms]
      ,m.[JenisMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Fax]) [Fax]
      ,m.[KodePos]
      ,m.[lamaTinggal]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Pekerjaan]) [Pekerjaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Perusahaan]) [Perusahaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPHP]) [CPHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPJabatan]) [CPJabatan]
--      ,m.[UserID]
      ,hpc.created_by [UserID]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatTagih]) [AlamatTagih]
      ,m.[BlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[KetBlackList]) [KetBlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Question]) [Question]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Answer]) [Answer]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaBank]) [NamaBank]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoAplikasi]) [NoAplikasi]
      ,m.[NamaPanggilan]
      ,m.[StatusRumah]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TempatLahir]) [TempatLahir]
      ,m.[InfoPromo]
      ,m.[rowguid]
      ,m.[CustID_KUNNR]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccGroup_KTOKD]) [AccGroup_KTOKD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NPWP_STCEG]) [NPWP_STCEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name2_NAME_2]) [Name2_NAME_2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name3_NAME_3]) [Name3_NAME_3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name4_NAME_4]) [Name4_NAME_4]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat2_STR_SUPPL3]) [Alamat2_STR_SUPPL3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat3_LOCATION]) [Alamat3_LOCATION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat4_STR_SUPPL1]) [Alamat4_STR_SUPPL1]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat5_STR_SUPPL2]) [Alamat5_STR_SUPPL2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Country_COUNTRY]) [Country_COUNTRY]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Region_REGION]) [Region_REGION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Zone_TRANSPZONE]) [Zone_TRANSPZONE]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Langu_LANGU]) [Langu_LANGU]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Company_BUKRS]) [Company_BUKRS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SortKey_ZUAWA]) [SortKey_ZUAWA]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RecAcc_AKONT]) [RecAcc_AKONT]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CashMgn_FDGRV]) [CashMgn_FDGRV]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TOP_ZTERM]) [TOP_ZTERM]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_XZVER]) [Credit_XZVER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SalesOrg_VKORG]) [SalesOrg_VKORG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DistChannel_VTWEG]) [DistChannel_VTWEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Division_SPART]) [Division_SPART]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Curr_WAERS]) [Curr_WAERS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustStatGrp_VERSG]) [CustStatGrp_VERSG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustPricProc_KALKS]) [CustPricProc_KALKS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RegionPL_PLTYP]) [RegionPL_PLTYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[ShipCond_VSBED]) [ShipCond_VSBED]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelPriority_LPRIO]) [DelPriority_LPRIO]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_KKBER]) [Credit_KKBER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccAssgtGroup_KTGRD]) [AccAssgtGroup_KTGRD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[OrderBlock_AUFSD]) [OrderBlock_AUFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelBlock_LIFSD]) [DelBlock_LIFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[BillBlock_FAKSD]) [BillBlock_FAKSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DepartureCountry_ALAND]) [DepartureCountry_ALAND]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxCategory_TATYP]) [TaxCategory_TATYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxClass_TAXKD]) [TaxClass_TAXKD]
      ,CONVERT(VARCHAR(10), m.[LastModified], 112) [LastModified]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AttachmentKTP]) [AttachmentKTP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Keterangan]) [Keterangan]

	  --MasterMemberHPC
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.no_member_hpc) no_member_hpc
	  --,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.member_type) member_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('HPC') member_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.id_type) id_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.first_name) first_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.last_name) last_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.myhartono_id) myhartono_id
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.province) province
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.city) city
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.subdistrict) subdistrict
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.village) village
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.province_name) province_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.city_name) city_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.subdistrict_name) subdistrict_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.village_name) village_name
	  ,hpc.credit_limit
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.npwp_number) npwp_number
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.profession) profession
	  ,CONVERT(VARCHAR(10), CONVERT(DATETIME, hpc.expiry_date, 103), 112) expiry_date
	  ,hpc.status_blacklist
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.blacklist_description) blacklist_description
	  ,hpc.status_suspend
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.suspend_description) suspend_description
	  ,hpc.is_underage
	  ,CONVERT(VARCHAR(10), hpc.created_on, 112) created_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.created_by) created_by
	  ,CONVERT(VARCHAR(10), hpc.modified_on, 112) modified_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.modified_by) modified_by
	  ,CONVERT(VARCHAR(10), hpc.verified_phone_number_on, 112) verified_phone_number_on
	  ,CONVERT(VARCHAR(10), hpc.verified_email_on, 112) verified_email_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.ocr_id) ocr_id
	  ,hpc.is_ocr_success
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hpc.no_member_old) no_member_old
	  ,CASE
		    WHEN hpc.status_blacklist = 1 THEN 'Blacklist'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc and is_revised=0 and hpc.status_suspend='1')  THEN 'Request Revise'
		    WHEN hpc.status_suspend = 1 THEN 'Lengkapi Data'
		    WHEN hpc.verified_phone_number = 0 and hpc.verified_email = 0 THEN 'Waiting For Email & Phone No Verification'
		    WHEN hpc.verified_phone_number = 0 THEN 'Waiting For Phone No Verification'
		    WHEN hpc.verified_email = 0 THEN 'Waiting For Email Verification'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc AND ApprovalNewMemberHPC.is_approve_manager = 1) THEN 'Active - Verified'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc AND ApprovalNewMemberHPC.is_approve_cso = 1) THEN 'Active - Approved'
		    WHEN hpc.verified_phone_number = 1 AND hpc.verified_email = 1 THEN 'Waiting For Approval'
	    END AS StatusHPC
       ,'' AS StatusHRM
       ,'' AS StatusHCR
	  ,CASE
		    WHEN hpc.status_blacklist = 1 THEN 'Blacklist'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc and is_revised=0 and hpc.status_suspend='1')  THEN 'Request Revise'
		    WHEN hpc.status_suspend = 1 THEN 'Lengkapi Data'
		    WHEN hpc.verified_phone_number = 0 and hpc.verified_email = 0 THEN 'Waiting For Email & Phone No Verification'
		    WHEN hpc.verified_phone_number = 0 THEN 'Waiting For Phone No Verification'
		    WHEN hpc.verified_email = 0 THEN 'Waiting For Email Verification'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc AND ApprovalNewMemberHPC.is_approve_manager = 1) THEN 'Active - Verified'
		    WHEN EXISTS(SELECT 1 FROM [10.50.5.59].Hartono.dbo.ApprovalNewMemberHPC WHERE no_member_hpc = hpc.no_member_hpc AND ApprovalNewMemberHPC.is_approve_cso = 1) THEN 'Active - Approved'
		    WHEN hpc.verified_phone_number = 1 AND hpc.verified_email = 1 THEN 'Waiting For Approval'
	    END AS StatusMember
       ,1 AS Qty
  FROM 
    [dbo].[MasterMember] m
    INNER JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON m.NoMember = hpc.no_member_old
--JOIN langsung ke temporary table untuk membatasi data tanpa merusak memori Optimizer
--INNER JOIN [dbo].[z_missing_no_member_hpc] f  ON hpc.no_member_hpc = f.no_member_hpc


  UNION

  --HRM
  SELECT m.[NoMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaMember]) [NamaMember]
      ,m.[NoKTP]
      ,m.[NoSIM]
      ,m.[NoKartuMember]
      ,CONVERT(VARCHAR(10), m.[TglLahirMember], 112) [TglLahirMember]
--      ,CONVERT(VARCHAR(10), m.[TglJadiMember], 112) [TglJadiMember]
      ,CONVERT(VARCHAR(10), hrm.[created_on], 112) [TglJadiMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat]) [Alamat]
      ,m.[Kota]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.phone_number) [NoTelp]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoHP]) [NoHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.email) [Email]
      ,m.[JenisKelamin]
      ,m.[StatusPerkawinan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaIbuKandung]) [NamaIbuKandung]
      ,m.[KreditLimit]
      ,m.[RewardPoint]
      ,m.[KodeStore]
      ,m.[Piutang]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatLama]) [AlamatLama]
      ,m.[TipeMember]
      ,CONVERT(VARCHAR(10), m.[TglBatasKartuMember], 112) [TglBatasKartuMember]
      ,m.[ContactPerson]
      ,m.[PaymentTerms]
      ,m.[JenisMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Fax]) [Fax]
      ,m.[KodePos]
      ,m.[lamaTinggal]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Pekerjaan]) [Pekerjaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Perusahaan]) [Perusahaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPHP]) [CPHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPJabatan]) [CPJabatan]
--      ,m.[UserID]
      ,hrm.created_by [UserID]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatTagih]) [AlamatTagih]
      ,m.[BlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[KetBlackList]) [KetBlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Question]) [Question]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Answer]) [Answer]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaBank]) [NamaBank]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoAplikasi]) [NoAplikasi]
      ,m.[NamaPanggilan]
      ,m.[StatusRumah]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TempatLahir]) [TempatLahir]
      ,m.[InfoPromo]
      ,m.[rowguid]
      ,m.[CustID_KUNNR]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccGroup_KTOKD]) [AccGroup_KTOKD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NPWP_STCEG]) [NPWP_STCEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name2_NAME_2]) [Name2_NAME_2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name3_NAME_3]) [Name3_NAME_3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name4_NAME_4]) [Name4_NAME_4]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat2_STR_SUPPL3]) [Alamat2_STR_SUPPL3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat3_LOCATION]) [Alamat3_LOCATION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat4_STR_SUPPL1]) [Alamat4_STR_SUPPL1]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat5_STR_SUPPL2]) [Alamat5_STR_SUPPL2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Country_COUNTRY]) [Country_COUNTRY]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Region_REGION]) [Region_REGION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Zone_TRANSPZONE]) [Zone_TRANSPZONE]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Langu_LANGU]) [Langu_LANGU]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Company_BUKRS]) [Company_BUKRS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SortKey_ZUAWA]) [SortKey_ZUAWA]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RecAcc_AKONT]) [RecAcc_AKONT]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CashMgn_FDGRV]) [CashMgn_FDGRV]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TOP_ZTERM]) [TOP_ZTERM]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_XZVER]) [Credit_XZVER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SalesOrg_VKORG]) [SalesOrg_VKORG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DistChannel_VTWEG]) [DistChannel_VTWEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Division_SPART]) [Division_SPART]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Curr_WAERS]) [Curr_WAERS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustStatGrp_VERSG]) [CustStatGrp_VERSG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustPricProc_KALKS]) [CustPricProc_KALKS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RegionPL_PLTYP]) [RegionPL_PLTYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[ShipCond_VSBED]) [ShipCond_VSBED]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelPriority_LPRIO]) [DelPriority_LPRIO]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_KKBER]) [Credit_KKBER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccAssgtGroup_KTGRD]) [AccAssgtGroup_KTGRD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[OrderBlock_AUFSD]) [OrderBlock_AUFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelBlock_LIFSD]) [DelBlock_LIFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[BillBlock_FAKSD]) [BillBlock_FAKSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DepartureCountry_ALAND]) [DepartureCountry_ALAND]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxCategory_TATYP]) [TaxCategory_TATYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxClass_TAXKD]) [TaxClass_TAXKD]
      ,CONVERT(VARCHAR(10), m.[LastModified], 112) [LastModified]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AttachmentKTP]) [AttachmentKTP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Keterangan]) [Keterangan]

	  --MasterMemberHRM
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.no_member_hrm) as no_member_hpc
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('HRM') member_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') id_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.first_name) first_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.last_name) last_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.myhartono_id) myhartono_id
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') province
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') city
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') subdistrict
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') village
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') province_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') city_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') subdistrict_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') village_name
	  ,null credit_limit
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') npwp_number
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') profession
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') expiry_date
	  ,null status_blacklist
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') blacklist_description
	  ,hrm.status_suspend status_suspend
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.suspend_description) suspend_description
	  ,null is_underage
	  ,CONVERT(VARCHAR(10), hrm.created_on, 112) created_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.created_by) created_by
	  ,CONVERT(VARCHAR(10), hrm.modified_on, 112) modified_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.modified_by) modified_by
	  ,CONVERT(VARCHAR(10), hrm.verified_phone_number_on, 112) verified_phone_number_on
	  ,CONVERT(VARCHAR(10), hrm.verified_email_on, 112) verified_email_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') ocr_id
	  ,null is_ocr_success
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(hrm.no_member_old) no_member_old
      ,'' AS StatusHPC
      ,case
		when hrm.status_suspend = 1 then 'Deactive'
		when hrm.myhartono_id is not null then 'Regular Member MyHartono'
		else 'Regular Member Offline'
	  end StatusHRM
      , '' AS StatusHCR
      ,case
		when hrm.status_suspend = 1 then 'Deactive'
		when hrm.myhartono_id is not null then 'Regular Member MyHartono'
		else 'Regular Member Offline'
	  end StatusMember
      , 1 AS Qty
  FROM 
    [10.50.5.59].Hartono.dbo.MasterMemberHRM hrm 
    INNER JOIN [dbo].[MasterMember] m ON m.NoMember = hrm.no_member_old
    --INNER JOIN [dbo].[z_missing_no_member_hrm] f  on f.no_member_hrm=hrm.no_member_hrm


  UNION 

  --Corporate
  SELECT m.[NoMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaMember]) [NamaMember]
      ,m.[NoKTP]
      ,m.[NoSIM]
      ,m.[NoKartuMember]
      ,CONVERT(VARCHAR(10), m.[TglLahirMember], 112) [TglLahirMember]
      ,CONVERT(VARCHAR(10), m.[TglJadiMember], 112) [TglJadiMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat]) [Alamat]
      ,m.[Kota]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.phone_number) [NoTelp]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoHP]) [NoHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.Email) [Email]
      ,m.[JenisKelamin]
      ,m.[StatusPerkawinan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaIbuKandung]) [NamaIbuKandung]
      ,m.[KreditLimit]
      ,m.[RewardPoint]
      ,m.[KodeStore]
      ,m.[Piutang]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatLama]) [AlamatLama]
      ,m.[TipeMember]
      ,CONVERT(VARCHAR(10), m.[TglBatasKartuMember], 112) [TglBatasKartuMember]
      ,m.[ContactPerson]
      ,m.[PaymentTerms]
      ,m.[JenisMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Fax]) [Fax]
      ,m.[KodePos]
      ,m.[lamaTinggal]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Pekerjaan]) [Pekerjaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Perusahaan]) [Perusahaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPHP]) [CPHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPJabatan]) [CPJabatan]
--      ,m.[UserID]
      ,cor.created_by [UserID]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatTagih]) [AlamatTagih]
      ,m.[BlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[KetBlackList]) [KetBlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Question]) [Question]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Answer]) [Answer]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaBank]) [NamaBank]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoAplikasi]) [NoAplikasi]
      ,m.[NamaPanggilan]
      ,m.[StatusRumah]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TempatLahir]) [TempatLahir]
      ,m.[InfoPromo]
      ,m.[rowguid]
      ,m.[CustID_KUNNR]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccGroup_KTOKD]) [AccGroup_KTOKD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NPWP_STCEG]) [NPWP_STCEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name2_NAME_2]) [Name2_NAME_2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name3_NAME_3]) [Name3_NAME_3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name4_NAME_4]) [Name4_NAME_4]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat2_STR_SUPPL3]) [Alamat2_STR_SUPPL3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat3_LOCATION]) [Alamat3_LOCATION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat4_STR_SUPPL1]) [Alamat4_STR_SUPPL1]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat5_STR_SUPPL2]) [Alamat5_STR_SUPPL2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Country_COUNTRY]) [Country_COUNTRY]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Region_REGION]) [Region_REGION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Zone_TRANSPZONE]) [Zone_TRANSPZONE]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Langu_LANGU]) [Langu_LANGU]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Company_BUKRS]) [Company_BUKRS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SortKey_ZUAWA]) [SortKey_ZUAWA]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RecAcc_AKONT]) [RecAcc_AKONT]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CashMgn_FDGRV]) [CashMgn_FDGRV]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TOP_ZTERM]) [TOP_ZTERM]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_XZVER]) [Credit_XZVER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SalesOrg_VKORG]) [SalesOrg_VKORG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DistChannel_VTWEG]) [DistChannel_VTWEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Division_SPART]) [Division_SPART]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Curr_WAERS]) [Curr_WAERS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustStatGrp_VERSG]) [CustStatGrp_VERSG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustPricProc_KALKS]) [CustPricProc_KALKS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RegionPL_PLTYP]) [RegionPL_PLTYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[ShipCond_VSBED]) [ShipCond_VSBED]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelPriority_LPRIO]) [DelPriority_LPRIO]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_KKBER]) [Credit_KKBER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccAssgtGroup_KTGRD]) [AccAssgtGroup_KTGRD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[OrderBlock_AUFSD]) [OrderBlock_AUFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelBlock_LIFSD]) [DelBlock_LIFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[BillBlock_FAKSD]) [BillBlock_FAKSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DepartureCountry_ALAND]) [DepartureCountry_ALAND]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxCategory_TATYP]) [TaxCategory_TATYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxClass_TAXKD]) [TaxClass_TAXKD]
      ,CONVERT(VARCHAR(10), m.[LastModified], 112) [LastModified]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AttachmentKTP]) [AttachmentKTP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Keterangan]) [Keterangan]

	  --MasterMemberCorporate
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.no_member_corporate) no_member_corporate
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('Corporate') member_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') id_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.corporate_name) first_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') last_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') myhartono_id
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.province) province
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.city) city
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.subdistrict) subdistrict
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.village) village
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.province_name) province_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.city_name) city_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.subdistrict_name) subdistrict_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.village_name) village_name
	  ,null credit_limit
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.npwp_number) npwp_number
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') profession
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') expiry_date
	  ,cor.status_blacklist status_blacklist
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') blacklist_description
	  ,cor.status_suspend status_suspend
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') suspend_description
	  ,null is_underage
	  ,CONVERT(VARCHAR(10), cor.created_on, 112) created_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.created_by) created_by
	  ,CONVERT(VARCHAR(10), cor.modified_on, 112) modified_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.modified_by) modified_by
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') verified_phone_number_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') verified_email_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') ocr_id
	  ,null is_ocr_success
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(cor.no_member_old) no_member_old
      ,'' AS StatusHPC
      ,'' AS StatusHRM
      ,case 
		when cor.status_suspend = 1 then 'Deactive'
		else 'Active'
	   end StatusHCR
      ,case 
		when cor.status_suspend = 1 then 'Deactive'
		else 'Active'
	   end StatusMember
      ,1 As Qty
  FROM [dbo].[MasterMember] m
  INNER JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor
  ON m.NoMember = cor.no_member_old
--  where cor.no_member_corporate in (
--  'HCR-030101-003',
--'HCR-030101-004',
--'HCR-030101-164',
--'HCR-030101-262',
--'HCR-030101-311',
--'HCR-030101-421',
--'HCR-030101-490'
--)


  UNION

  --Payer
  SELECT m.[NoMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaMember]) [NamaMember]
      ,m.[NoKTP]
      ,m.[NoSIM]
      ,m.[NoKartuMember]
      ,CONVERT(VARCHAR(10), m.[TglLahirMember], 112) [TglLahirMember]
      ,CONVERT(VARCHAR(10), m.[TglJadiMember], 112) [TglJadiMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat]) [Alamat]
      ,m.[Kota]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.phone_number) [NoTelp]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoHP]) [NoHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.Email) [Email]
      ,m.[JenisKelamin]
      ,m.[StatusPerkawinan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaIbuKandung]) [NamaIbuKandung]
      ,m.[KreditLimit]
      ,m.[RewardPoint]
      ,m.[KodeStore]
      ,m.[Piutang]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatLama]) [AlamatLama]
      ,m.[TipeMember]
      ,CONVERT(VARCHAR(10), m.[TglBatasKartuMember], 112) [TglBatasKartuMember]
      ,m.[ContactPerson]
      ,m.[PaymentTerms]
      ,m.[JenisMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Fax]) [Fax]
      ,m.[KodePos]
      ,m.[lamaTinggal]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Pekerjaan]) [Pekerjaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Perusahaan]) [Perusahaan]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPHP]) [CPHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CPJabatan]) [CPJabatan]
--      ,m.[UserID]
      ,payer.created_by [UserID]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AlamatTagih]) [AlamatTagih]
      ,m.[BlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[KetBlackList]) [KetBlackList]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Question]) [Question]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Answer]) [Answer]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaBank]) [NamaBank]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoAplikasi]) [NoAplikasi]
      ,m.[NamaPanggilan]
      ,m.[StatusRumah]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TempatLahir]) [TempatLahir]
      ,m.[InfoPromo]
      ,m.[rowguid]
      ,m.[CustID_KUNNR]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccGroup_KTOKD]) [AccGroup_KTOKD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NPWP_STCEG]) [NPWP_STCEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name2_NAME_2]) [Name2_NAME_2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name3_NAME_3]) [Name3_NAME_3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Name4_NAME_4]) [Name4_NAME_4]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat2_STR_SUPPL3]) [Alamat2_STR_SUPPL3]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat3_LOCATION]) [Alamat3_LOCATION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat4_STR_SUPPL1]) [Alamat4_STR_SUPPL1]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat5_STR_SUPPL2]) [Alamat5_STR_SUPPL2]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Country_COUNTRY]) [Country_COUNTRY]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Region_REGION]) [Region_REGION]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Zone_TRANSPZONE]) [Zone_TRANSPZONE]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Langu_LANGU]) [Langu_LANGU]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Company_BUKRS]) [Company_BUKRS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SortKey_ZUAWA]) [SortKey_ZUAWA]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RecAcc_AKONT]) [RecAcc_AKONT]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CashMgn_FDGRV]) [CashMgn_FDGRV]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TOP_ZTERM]) [TOP_ZTERM]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_XZVER]) [Credit_XZVER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[SalesOrg_VKORG]) [SalesOrg_VKORG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DistChannel_VTWEG]) [DistChannel_VTWEG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Division_SPART]) [Division_SPART]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Curr_WAERS]) [Curr_WAERS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustStatGrp_VERSG]) [CustStatGrp_VERSG]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[CustPricProc_KALKS]) [CustPricProc_KALKS]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[RegionPL_PLTYP]) [RegionPL_PLTYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[ShipCond_VSBED]) [ShipCond_VSBED]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelPriority_LPRIO]) [DelPriority_LPRIO]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Credit_KKBER]) [Credit_KKBER]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AccAssgtGroup_KTGRD]) [AccAssgtGroup_KTGRD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[OrderBlock_AUFSD]) [OrderBlock_AUFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DelBlock_LIFSD]) [DelBlock_LIFSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[BillBlock_FAKSD]) [BillBlock_FAKSD]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[DepartureCountry_ALAND]) [DepartureCountry_ALAND]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxCategory_TATYP]) [TaxCategory_TATYP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[TaxClass_TAXKD]) [TaxClass_TAXKD]
      ,CONVERT(VARCHAR(10), m.[LastModified], 112) [LastModified]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[AttachmentKTP]) [AttachmentKTP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Keterangan]) [Keterangan]

	  --MasterMemberPayer
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.no_member_corporate) no_member_corporate
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('Payer') member_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') id_type
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.corporate_name) first_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') last_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') myhartono_id
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.province) province
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.city) city
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.subdistrict) subdistrict
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.village) village
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.province_name) province_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.city_name) city_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.subdistrict_name) subdistrict_name
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.village_name) village_name
	  ,null credit_limit
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.npwp_number) npwp_number
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') profession
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') expiry_date
	  ,null status_blacklist
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') blacklist_description
	  ,null status_suspend
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') suspend_description
	  ,null is_underage
	  ,CONVERT(VARCHAR(10), payer.created_on, 112) created_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.created_by) created_by
	  ,CONVERT(VARCHAR(10), payer.modified_on, 112) modified_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.modified_by) modified_by
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') verified_phone_number_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') verified_email_on
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace('') ocr_id
	  ,null is_ocr_success
	  ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(payer.no_member_old) no_member_old
      ,'' AS StatusHPC
      ,'' AS StatusHRM
      ,'' AS StatusHCR
      , case
	        when payer.status_active=1 then 'Active'
	        when payer.status_active=0 then 'Deactive'
        end as StatusMember
      , 1 AS Qty
  FROM 
    [dbo].[MasterMember] m
    INNER JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON m.NoMember = payer.no_member_old


GO



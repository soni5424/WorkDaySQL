	SELECT top 10 m.[NoMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NamaMember]) [NamaMember]
      ,m.[NoKTP]
      ,m.[NoSIM]
      ,m.[NoKartuMember]
      ,CONVERT(VARCHAR(10), m.[TglLahirMember], 112) [TglLahirMember]
      ,CONVERT(VARCHAR(10), m.[TglJadiMember], 112) [TglJadiMember]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Alamat]) [Alamat]
      ,m.[Kota]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoTelp]) [NoTelp]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[NoHP]) [NoHP]
      ,dbo.ReplaceNonPrintableAsciiCharacterWithSpace(m.[Email]) [Email]
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
  FROM [dbo].[MasterMember] m
  INNER JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc
  ON m.NoMember = hpc.no_member_old
  where hpc.no_member_hpc like 'HPC-1001%'


select top 10 * from MasterMember where 
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc='HPC-100102-439'
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc like 'HPC-100102-%'
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc like 'HPC-160801-22%'
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc like 'HPC-00-000-010114-009'
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc like 'HPC-00-000-010114-008'

'HCR-030101-001'
'HPC-100102-439'
'HPC-160801-229'




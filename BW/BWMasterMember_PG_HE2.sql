USE [Hartono]
GO

/****** Object:  View [dbo].[VBWMasterMember_PG_HE]    Script Date: 19/08/2026 13.25.59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author		: Arnol
-- Create date	: 13/03/2024
-- Description	: Connect TrxFaktur & [10.50.5.59] temp FK table from PostgreSQL
-- =============================================
-- Author		: Arnol
-- Modifiy date	: 19/07/2024
-- Description	: Add column NoSO, AlamatCustomer, Provinsi, Kota, Kecamatan, Kelurahan, NoPOLeasing
-- =============================================
ALTER VIEW [dbo].[VBWMasterMember_PG_HE] --SELECT * FROM VBWMasterMember_PG_HE
AS

	--FAKTUR
	SELECT DISTINCT 
		fk.NoFaktur, 
		pg.NoGroupOrder,
		CASE 
			WHEN pg.NoMember IS NOT NULL THEN
				CASE
					WHEN pg.NoMember = '00-00000001' THEN
						(SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
					ELSE pg.NoMember
				END
			ELSE (SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
		END NoMember, 
		fk.KeteranganSO, 
		fk.NamaPenerima,
		'MERCHANDISE' AS ProductType,
		fk.NoSO,
		UPPER((fk.alamatpenerima + fk.AlamatPenerima2_STR_SUPPL3 + fk.AlamatPenerima3_LOCATION + fk.AlamatPenerima4_STR_SUPPL1 + fk.AlamatPenerima5_STR_SUPPL2)) AS AlamatCustomer,
		ISNULL(UPPER(pg.NamaProvinsi), '') AS Provinsi,
		ISNULL(UPPER(pg.NamaKota), '') AS Kota,
		ISNULL(UPPER(pg.NamaKecamatan), '') AS Kecamatan,
		ISNULL(UPPER(pg.NamaKelurahan), '') AS Kelurahan,
		ISNULL(UPPER(po.NoPOLeasing), '') AS NoPOLeasing

	FROM
	TrxFaktur fk
	INNER JOIN [10.50.5.59].Hartono.dbo.TrxFaktur_MemberPG_HE pg ON fk.NoFaktur = pg.NoFaktur
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fk.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fk.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fk.NoMember
	LEFT JOIN SAP_TrxFKPOLeasing po ON fk.NoFaktur = po.NoFK
	--WHERE fk.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) --H-7
	WHERE fk.Tanggal >= '20260101'


	UNION ALL

	--FAKTUR GE
	SELECT DISTINCT 
		fkGE.NoFaktur, 
		pgGE.NoGroupOrder,
		CASE 
			WHEN pgGE.NoMember IS NOT NULL THEN
				CASE
					WHEN pgGE.NoMember = '00-00000001' THEN
						(SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
					ELSE pgGE.NoMember
				END
			ELSE (SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
		END NoMember, 
		fkGE.KeteranganSO, 
		fkGE.NamaPenerima,
		'GE' AS ProductType,
		'' AS NoSO,
		'' AS AlamatCustomer,
		'' AS Provinsi,
		'' AS Kota,
		'' AS Kecamatan,
		'' AS Kelurahan,
		'' AS NoPOLeasing

	FROM [192.168.9.14\SQLADIRA].Hartono.dbo.TrxFaktur fkGE
	INNER JOIN [10.50.5.59].Hartono.dbo.TrxFakturGE_MemberPG_HE pgGE ON fkGE.NoFaktur = pgGE.NoFaktur
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fkGE.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fkGE.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fkGE.NoMember
	--WHERE fkGE.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) --H-7
	WHERE fkGE.Tanggal >= '20260101'

	UNION ALL

	--RETUR
	SELECT DISTINCT 
		rp.NoReturPenjualan, 
		pg.NoGroupOrder,
		CASE 
			WHEN pg.NoMember IS NOT NULL THEN
				CASE
					WHEN pg.NoMember = '00-00000001' THEN
						(SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
					ELSE pg.NoMember
				END
			ELSE (SELECT no_member_corporate from [10.50.5.59].Hartono.dbo.MasterMemberCorporate WHERE corporate_name = 'ONE TIME CUSTOMER')
		END NoMember, 
		fk.KeteranganSO, 
		fk.NamaPenerima,
		'MERCHANDISE' AS ProductType,
		'' AS NoSO,
		'' AS AlamatCustomer,
		'' AS Provinsi,
		'' AS Kota,
		'' AS Kecamatan,
		'' AS Kelurahan,
		'' AS NoPOLeasing

	FROM TrxReturPenjualan rp
	INNER JOIN TrxFaktur fk ON rp.NoFaktur = fk.NoFaktur
	INNER JOIN [10.50.5.59].Hartono.dbo.TrxFaktur_MemberPG_HE pg ON fk.NoFaktur = pg.NoFaktur
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fk.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fk.NoMember
	LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fk.NoMember
	--WHERE rp.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) --H-7
	WHERE rp.Tanggal >= '20260101'




GO



USE [Hartono]
GO

/****** Object:  View [dbo].[VBWMasterMember_PG_HE]    Script Date: 19/10/2026 13.44.43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		: Arnol
-- Create date	: 13/03/2024
-- Description	: Connect TrxFaktur & [10.50.5.59] temp FK table from PostgreSQL
-- =============================================
-- =============================================
-- Modified By	: Arnol
-- Modified Date: 19/07/2024
-- Description	: Add column NoSO, AlamatCustomer, Provinsi, Kota, Kecamatan, Kelurahan, NoPOLeasing
-- =============================================
-- =============================================
-- Modified By	: Soni Gunawan
-- Modified Date: 19/10/2026
-- Description	: Add Jenis_Pengambilan, TelpPenerima, ApprovalSM
-- =============================================

--select * from VBWMasterMember_PG_HE where len(AlamatCustomer) > 60
--select count(*) from VBWMasterMember_PG_HE2 
--select top 10 * from VBWMasterMember_PG_HE2 
-- select top 10 * from VBWMasterMember_PG_HE2 where isnull(JenisPengambilan,'') <>'' and isnull(namaUserApproval,'') <>''
select top 10 * from VBWMasterMember_PG_HE2 where NoFaktur='FK-06-B71-01740'

--select * from TrxFaktur where nofaktur='FK-06-B71-01740'


alter VIEW [dbo].[VBWMasterMember_PG_HE2] 
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
		fk.TelpPenerima,
		'MERCHANDISE' AS ProductType,
		fk.NoSO,
		UPPER((fk.alamatpenerima + fk.AlamatPenerima2_STR_SUPPL3 + fk.AlamatPenerima3_LOCATION + fk.AlamatPenerima4_STR_SUPPL1 + fk.AlamatPenerima5_STR_SUPPL2)) AS AlamatCustomer,
		ISNULL(UPPER(pg.NamaProvinsi), '') AS Provinsi,
		ISNULL(UPPER(pg.NamaKota), '') AS Kota,
		ISNULL(UPPER(pg.NamaKecamatan), '') AS Kecamatan,
		ISNULL(UPPER(pg.NamaKelurahan), '') AS Kelurahan,
		ISNULL(UPPER(po.NoPOLeasing), '') AS NoPOLeasing,
		case 
			when (pg.DeliveryMethod is null or pg.DeliveryMethod = '') then 'Diambil Sendiri'
			when (pg.DeliveryMethod = '01') then 'Diambil Sendiri'
			when (pg.DeliveryMethod = '02') then 'Diambil Nanti ' +  ISNULL(CONVERT(VARCHAR(10), fk.TglPengiriman, 103), '')
			when (pg.DeliveryMethod = '03' and pg.PickingType = '01') then 'Dikirim HE ' + ISNULL(CONVERT(VARCHAR(10), fk.TglPengiriman, 103), '')
			when (pg.DeliveryMethod = '03' and pg.PickingType = '04') then 'Dikirim Tukang'
			when (pg.DeliveryMethod = '03' and pg.PickingType = '02') then 'Dikirim 3rd Party'
			else ''
		end as JenisPengambilan,
		ISNULL(UPPER(aprv2.UserID), '') AS UserIDApproval,
		ISNULL(UPPER(aprv2.NamaUser), '') AS NamaUserApproval,
		ISNULL(UPPER(aprv2.KodeBarcode), '') AS EmployeeIDApproval
	FROM
		TrxFaktur fk
		INNER JOIN [10.50.5.59].Hartono.dbo.TrxFaktur_MemberPG_HE pg ON fk.NoFaktur = pg.NoFaktur
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fk.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fk.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fk.NoMember
		LEFT JOIN SAP_TrxFKPOLeasing po ON fk.NoFaktur = po.NoFK
		OUTER APPLY (
					SELECT TOP 1 aprv.group_order_id, aprv.order_id, usr.UserID, usr.NamaUser, usr.KodeBarcode
					FROM [10.50.5.59].Hartono.dbo.TrxFaktur_MemberPG_HE_Approval aprv 
					INNER JOIN Masteruser usr ON aprv.approval_employee_id = usr.KodeBarcode
					WHERE pg.NoGroupOrder = aprv.group_order_id AND pg.OrderID = aprv.order_id 							
					ORDER BY aprv.approval_on DESC
				) aprv2
	--WHERE fk.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) -- H-7
	WHERE fk.Tanggal >= '20260101' and fk.tanggal < '20270101'


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
		fkGE.TelpPenerima,
		'GE' AS ProductType,
		'' AS NoSO,
		'' AS AlamatCustomer,
		'' AS Provinsi,
		'' AS Kota,
		'' AS Kecamatan,
		'' AS Kelurahan,
		'' AS NoPOLeasing,
		'' AS JenisPengambilan,
		'' AS UserIDApproval,
		'' AS NamaUserApproval,
		'' AS EmployeeIDApproval
	FROM 
		[192.168.9.14\SQLADIRA].Hartono.dbo.TrxFaktur fkGE
		INNER JOIN [10.50.5.59].Hartono.dbo.TrxFakturGE_MemberPG_HE pgGE ON fkGE.NoFaktur = pgGE.NoFaktur
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fkGE.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fkGE.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fkGE.NoMember
	--WHERE fkGE.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) -- H-7
	WHERE fkGE.Tanggal >= '20260101' and fkGE.tanggal<'20270101'


	UNION ALL

	--RETUR
	SELECT DISTINCT 
		rp.NoReturPenjualan as nofaktur, 
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
		fk.TelpPenerima,
		'MERCHANDISE' AS ProductType,
		'' AS NoSO,
		'' AS AlamatCustomer,
		'' AS Provinsi,
		'' AS Kota,
		'' AS Kecamatan,
		'' AS Kelurahan,
		'' AS NoPOLeasing,
		'' as JenisPengambilan,
		'' AS UserIDApproval,
		'' AS NamaUserApproval,
		'' AS EmployeeIDApproval
	FROM 
		TrxReturPenjualan rp
		INNER JOIN TrxFaktur fk ON rp.NoFaktur = fk.NoFaktur
		LEFT JOIN [10.50.5.59].Hartono.dbo.TrxFaktur_MemberPG_HE pg ON fk.NoFaktur = pg.NoFaktur
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberHPC hpc ON hpc.no_member_old = fk.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberCorporate cor ON cor.no_member_old = fk.NoMember
		LEFT JOIN [10.50.5.59].Hartono.dbo.MasterMemberPayer payer ON payer.no_member_old = fk.NoMember
	--WHERE rp.Tanggal >= CONVERT(VARCHAR(10), DATEADD(DAY, -7, GETDATE()), 120) -- H-7
	WHERE rp.Tanggal >= '20260101' and rp.tanggal<'20270101'

GO

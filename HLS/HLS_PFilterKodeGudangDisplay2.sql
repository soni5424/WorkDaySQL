USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[HLS_PFilterKodeGudangDisplay]    Script Date: 03/30/2021 08:56:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author		: daniel
-- Modif date	: 2.3.2021
-- Description	: Add Filter OR EC Shippoint 

-- daniel 10.03.2021
-- Perbaikan Bapi AND (b.Kodebarang = c.material OR (SUBSTRING(c.material, 1, 3) = '000' AND SUBSTRING(c.material, PATINDEX('%[^0]%', c.material+'.'), LEN(c.material)) = b.Kodebarang))
-- perbaikan kesalahan lama isnull(b.kodegudang, '') IN (SELECT Kodegudang FROM mastergudang WHERE display = '1')

-- Daniel 19/03/2021
-- Penambahan Request p.Yahya untuk tambah dari table trxubahtglpengiriman
-- Req.Yahya Untuk Display Hanya CnC
-- =============================================

CREATE PROCEDURE [dbo].[HLS_PFilterKodeGudangDisplay]	
	@KodeStore		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

declare @ParameterRoute varchar(50) -- 08/03/2019
set @ParameterRoute = (select nilai from masterparameter where nama = 'SetupRouteClick&Collect') -- 08/03/2019 
select noso, itm_number
into #inquiryso
from sap_trxgiinquiryso
where tanggalstatus >= CONVERT(VARCHAR(10),GETDATE(),111)

select *
from
(
SELECT 
	a.statusproses,
	a.noso,
	a.nososap_salesdocument,
	--convert(VARCHAR(10), a.tanggal, 103) AS tanggal,
	(case when a.tglpengiriman is not null then convert(VARCHAR(10), a.tglpengiriman, 103) else convert(VARCHAR(10), a.tanggal, 103) end)AS tanggal, -- Daniel 11/06/2020 Connect SO HLS Inquiry SO SD19-007
	b.kodebarang,
	c.plant,
	c.ship_point,	
	b.jumlah,
	b.qty_confirm,
	case a.Statusinvoiced 
		when '1' then 'Faktur'
		else 'SO'
	 end AS FS,
	 b.kodegudang,
	 convert(VARCHAR(10), a.tanggal, 108) AS waktu,
	 --d.namauser, -- 18/02/2019
	 d.namasales as namauser, -- 18/02/2019
	 e.nofaktur,
	 a.NOSOSAP_salesDocument AS salesDocument,
	 i.keterangan as brand_name,
	 --g.nilai, -- 18/02/2019
	 isnull ((select g.nilai from masterpilihan g where g.nama like '%' + a.kodeworkstation + '%' AND g.grup = 'Lantai_Inquiry_SO_' + convert(VARCHAR, a.kodestore) AND g.nama LIKE '%' + a.kodeworkstation + '%'), '') as nilai, -- 18/02/2019
	 f.namabarang as matl_desc,
	 ISNULL((
			SELECT top 1 NamaCounter -- 28/11/2019 by Rini karena bisa multiple setup u/ click & collect
			FROM CB_SetupCounterBarang
			WHERE IDCounter = a.IDCounter
				--AND KodeWS = a.kodeworkstation --seharusnya di join WS setup vs WS counter barang (bukan WS SO) 09/07/2019 by Rini
			), '') AS CounterBarang,
	isnull((select top 1 convert(VARCHAR(10), TanggalAntri, 103)+' '+convert(VARCHAR(5), TanggalAntri, 114)  from CB_TrxCounterBarang where nososap = a.nososap_salesdocument ),'')as TglAntri		
	,(select top 1 convert(VARCHAR(10), g0.tglpengiriman, 103) from trxubahtglpengiriman g0 where g0.nofaktur = e.nofaktur) as TglUbahPengiriman
	, a.tglpengiriman
	, a.tanggal as TglSO
FROM 
	TrxSO a
	INNER JOIN TrxSODetail b ON a.noso = b.noso
	INNER JOIN SAP_BapiSDItm c ON a.noso = c.NODOCUMENT
		AND (b.Kodebarang = c.material OR (SUBSTRING(c.material, 1, 3) = '000' AND SUBSTRING(c.material, PATINDEX('%[^0]%', c.material+'.'), LEN(c.material)) = b.Kodebarang))
		AND b.itm_number = c.itm_number
	INNER JOIN masterstore z on z.sales_off=c.plant and z.kodestore=@KodeStore
	LEFT JOIN trxfaktur e ON e.noso = a.noso	
	--INNER JOIN SAP_Article f ON f.old_mat_no = b.kodebarang and f.site = (SELECT Sales_Off FROM MasterStore WHERE KodeStore='01')
	INNER JOIN masterbarang f ON f.kodebarang = b.kodebarang 
	LEFT JOIN mastermerk i ON f.merkbarang = i.merk 
	--LEFT JOIN masterpilihan g on g.nama like '%' + a.kodeworkstation + '%'
	--INNER JOIN masteruser d ON a.kodeusersales = d.kodesales -- 18/02/2019
	INNER JOIN mastersales d ON a.kodeusersales = d.kodesales -- 18/02/2019
	--LEFT OUTER JOIN sap_trxgiinquiryso h on h.noso = a.nososap_salesdocument and h.itm_number = b.itm_number and h.itm_number != 0 -- 18/02/2019
	LEFT OUTER JOIN #inquiryso h on h.noso = a.nososap_salesdocument and h.itm_number = b.itm_number and h.itm_number != 0 -- 18/02/2019
WHERE 	
	--((a.tglpengiriman is null and a.tanggal >= CONVERT(VARCHAR(10),GETDATE(),111)) 
	--or
	--(a.tglpengiriman = CONVERT(VARCHAR(10),GETDATE(),111)))	
	--End Daniel 11/06/2020 Connect SO HLS Inquiry SO SD19-007
	
	 a.statusbatal = '0'
	AND b.item_categ != 'Z005'
	AND(
		--(c.ship_point LIKE 'c%'OR c.ship_point LIKE 'ec%')
		--OR 
		--((c.ship_point like 'P%' or c.ship_point like 'EP%')AND 
		c.Route = @ParameterRoute --) -- 08/03/2019		
		)						 
	AND b.Qty_confirm = b.Jumlah
	AND b.reason_rej IS NULL
	AND 	
	(
		(a.idcounter = @ParameterRoute )
		or
		(a.idcounter != @ParameterRoute and isnull(b.kodegudang, '') IN (SELECT Kodegudang FROM mastergudang WHERE display = '1'))
	)
		
	--AND g.grup = 'Lantai_Inquiry_SO_' + convert(VARCHAR, a.kodestore) -- 18/02/2019
	--AND g.nama LIKE '%' + a.kodeworkstation + '%' -- 18/02/2019
	AND h.noso is null
) Z
where
	(
		(Z.TglUbahPengiriman is not null and Z.TglUbahPengiriman = CONVERT(VARCHAR(10),GETDATE(),111))
		or
		(Z.tglpengiriman is null and Z.TglSO >= CONVERT(VARCHAR(10),GETDATE(),111)) 
		or
		(Z.tglpengiriman = CONVERT(VARCHAR(10),GETDATE(),111))
	)	
order by Z.FS	
	
END






GO


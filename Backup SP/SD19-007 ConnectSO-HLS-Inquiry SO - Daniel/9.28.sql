USE [Hartono]
GO
-- =============================================
-- Author		: Soni Gunawan
-- Modif date	: 15.5.17
-- Description	: Add Filter OR EC Shippoint 
-- =============================================
-- Author		: Soni Gunawan
-- Modif date	: 22.6.18
-- Description	: Set minimal 1 Gudang
--				  Coba Optimize
-- =============================================
-- =============================================
-- Modified By		: Rini Handini
-- Modified date	: 18/02/2019
-- Description		: 1. Remark Inner Join Ke Mapping WS di Master Pilihan
--					  2. Ganti MasterUser ke MasterSales
--					  3. sap_trxgiinquiryso ganti ke #inquiryso
--					  4. Ganti Tanggal CONVERT(VARCHAR(10),GETDATE(),111)
-- =============================================
-- =============================================
-- Modified By		: Daniel Satria
-- Modified date	: 08/03/2019
-- Description		: Menambah where Ship Point like P or EP ((ship_point like 'P%' or ship_point like 'EP%')and Route = 'Z99888')
--					  Menambah declare Route untuk cek route kusus untuk ship_Point p or ep					
-- =============================================
-- =============================================
-- Modified By		: Rini Handini
-- Modified date	: 09/07/2019
-- Description		: 1. Remark cek WS setup vs WS SO
-- =============================================
-- =============================================
-- Modified By		: Rini Handini
-- Modified date	: 28/11/2019
-- Description		: 1. add top 1 dari CB_SetupCounterBarang karena bisa multiple setup u/ click & collect
-- =============================================
-- =============================================
-- Modified By		: Daniel
-- Modified date	: 13/03/2020
-- Description		: 1. Add di select untuk mendapatkan Tanggal antri
-- =============================================
-- =============================================
-- Modified By		: Daniel
-- Modified date	: 27/04/2020
-- Description		: 1. mengganti tanggal operator yg tgl 18/02/2019
-- =============================================
-- =============================================
-- Modified By		: Daniel
-- Modified date	: 14/05/2020
-- Description		: menambah jam pada tgl
-- =============================================
-- =============================================
-- Modified By		: Daniel
-- Modified date	: 11/06/2020
-- Description		: select and where tanggal berubah ke tanggal kirim bila mana data ada bl tidak ke tanggal
-- =============================================

ALTER PROCEDURE [dbo].[HLS_PFilterKodeGudang]
	@KodeGudang1	varchar(50),
	@KodeGudang2	varchar(50),
	@KodeGudang3	varchar(50),
	@KodeGudang4	varchar(50),
	@KodeGudang5	varchar(50),
	@KodeStore		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	declare @ParameterRoute varchar(50)
	set @ParameterRoute = (select nilai from masterparameter where nama = 'SetupRouteClick&Collect')
	select noso, itm_number
	into #inquiryso
	from sap_trxgiinquiryso
	where tanggalstatus >= CONVERT(VARCHAR(10),GETDATE(),111)

	SELECT 
		a.statusproses,
		a.noso,
		a.nososap_salesdocument,
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
		 d.namasales as namauser,
		 e.nofaktur,
		 a.NOSOSAP_salesDocument AS salesDocument,
		 i.keterangan as brand_name,
		 isnull ((select g.nilai from masterpilihan g where g.nama like '%' + a.kodeworkstation + '%' AND g.grup = 'Lantai_Inquiry_SO_' + convert(VARCHAR, a.kodestore) AND g.nama LIKE '%' + a.kodeworkstation + '%'), '') as nilai,
		 f.namabarang as matl_desc,
		 ISNULL((
				SELECT top 1 NamaCounter -- 28/11/2019 by Rini karena bisa multiple setup u/ click & collect
				FROM CB_SetupCounterBarang
				WHERE IDCounter = a.IDCounter), '') AS CounterBarang,
		isnull((select top 1 convert(VARCHAR(10), TanggalAntri, 103)+' '+convert(VARCHAR(5), TanggalAntri, 114)  from CB_TrxCounterBarang where nososap = a.nososap_salesdocument ),'')as TglAntri
	FROM 
		TrxSO a
		INNER JOIN TrxSODetail b ON a.noso = b.noso
		INNER JOIN SAP_BapiSDItm c ON a.noso = c.NODOCUMENT
			AND b.Kodebarang = c.material
			AND b.itm_number = c.itm_number
		LEFT JOIN trxfaktur e ON e.noso = a.noso
		INNER JOIN masterbarang f ON f.kodebarang = b.kodebarang 
		LEFT JOIN mastermerk i ON f.merkbarang = i.merk 
		INNER JOIN mastersales d ON a.kodeusersales = d.kodesales -- 18/02/2019
		LEFT OUTER JOIN #inquiryso h on h.noso = a.nososap_salesdocument and h.itm_number = b.itm_number and h.itm_number != 0 -- 18/02/2019
	WHERE 
		(a.tglpengiriman is null and a.tanggal >= CONVERT(VARCHAR(10),GETDATE(),111)) or
		(a.tglpengiriman >= CONVERT(VARCHAR(10),GETDATE(),111))
		And (b.kodegudang = @KodeGudang1
			OR b.kodegudang = @KodeGudang2
			OR b.kodegudang = @KodeGudang3
			OR b.kodegudang = @KodeGudang4
			OR b.kodegudang = @KodeGudang5)
		AND a.statusbatal = '0'
		AND b.item_categ != 'Z005'
		AND((c.ship_point LIKE 'c%'OR c.ship_point LIKE 'ec%') OR 
			((c.ship_point like 'P%' or c.ship_point like 'EP%')AND c.Route = @ParameterRoute))
		AND b.Qty_confirm = b.Jumlah
		AND b.reason_rej IS NULL
		AND isnull(b.kodegudang, '') NOT IN (SELECT display FROM mastergudang WHERE display = '0')
		AND h.noso is null
	ORDER BY FS
END

GO
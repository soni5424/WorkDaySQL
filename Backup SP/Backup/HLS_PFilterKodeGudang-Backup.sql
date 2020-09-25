USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[HLS_PFilterKodeGudang]    Script Date: 27/04/2020 15.27.37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/*
	declare @temp1 varchar(50),
			@temp2 varchar(50),
			@temp3 varchar(50),
			@temp4 varchar(50),
			@temp5 varchar(50)

	if(@KodeGudang1 = '' and @KodeGudang2 = '' and @KodeGudang3 = '' and @KodeGudang4 = '' and @KodeGudang5 = '')
	begin
		set @temp1 = ''
		set @temp2 = ''
		set @temp3 = ''
		set @temp4 = ''
		set @temp5 = ''
	end else begin
		if(@KodeGudang1 != '')
			set @temp1 = @KodeGudang1
		else
			set	@temp1 = ';;..;'

		if(@KodeGudang2 != '')
			set @temp2 = @KodeGudang2
		else
			set	@temp2 = ';;..;'

		if(@KodeGudang3 != '')
			set @temp3 = @KodeGudang3
		else
			set	@temp3 = ';;..;'

		if(@KodeGudang4 != '')
			set @temp4 = @KodeGudang4
		else
			set	@temp4 = ';;..;'

		if(@KodeGudang5 != '')
			set @temp5 = @KodeGudang5
		else
			set	@temp5 = ';;..;'
	end
	

	
	declare 
		@param varchar(5000),
		@temp varchar(5000)

	select x.* from
	(select top 100
		a.statusproses,a.noso,a.nososap_salesdocument,convert(varchar(10),a.tanggal,103)as tanggal,
		b.kodebarang,c.plant,c.ship_point,b.jumlah,b.qty_confirm,(case when a.noso in (select noso from trxfaktur) then 'Faktur' else 'SO' end)as FS,
		b.kodegudang,convert(varchar(10),a.tanggal,108)as waktu,d.namauser,e.nofaktur,a.NOSOSAP_salesDocument as salesDocument,f.brand_name,g.nilai,f.matl_desc, 
		ISNULL((SELECT NamaCounter FROM CB_SetupCounterBarang
			WHERE IDCounter=a.IDCounter 
			and KodeWS = a.kodeworkstation),'') as CounterBarang--Counter Barang - Abednego 15/09/2017
		from trxso a  left join 
		trxsodetail b on a.noso = b.noso left join
		sap_bapisditm c on  a.noso = c.NODOCUMENT and b.Kodebarang = c.material and b.itm_number = c.itm_number
		left join trxfaktur e on e.noso = a.noso
		left join
		sap_article f on f.old_mat_no = b.kodebarang and f.site in (select sales_off from trxsokirim x, masterstore y where x.kodestorestock = y.kodestore and x.noso = a.noso) 
		left join masterpilihan g on g.nama like '%' + a.kodeworkstation + '%'
		left join
		masteruser d on a.kodeusersales = d.kodesales
		where 
		--DATEADD(dd, 0, DATEDIFF(dd, 0,a.tanggal)) <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) --update Peter 14/02/2017
		DATEADD(dd, 0, DATEDIFF(dd, 0,a.tanggal)) = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) --update Peter 14/02/2017		
		and a.tanggal>='20170210'
	and
		(
			b.kodegudang like '%' + @temp1+  '%'  or
			b.kodegudang like '%' + @temp2+  '%'  or
			b.kodegudang like '%'  +@temp3 + '%'  or
			b.kodegudang like '%' + @temp4 + '%'  or
			b.kodegudang like '%' + @temp5 + '%'
		 )
	and
		a.statusbatal = '0'
	and
		convert(varchar,a.nososap_salesdocument)+convert(varchar,b.itm_number) not in 
		(select convert(varchar,noso)+convert(varchar,itm_number) from sap_trxgiinquiryso where DATEADD(dd, 0, DATEDIFF(dd, 0,tanggalstatus)) = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and itm_number!=0) --update Peter 14/02/2017		
		--(select convert(varchar,noso)+convert(varchar,b.itm_number) from sap_trxgiinquiryso where DATEADD(dd, 0, DATEDIFF(dd, 0,tanggalstatus)) <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) --update Peter 14/02/2017
	and
		b.item_categ != 'Z005'
		--and
		--	c.ship_point like 'c%'
		and (c.ship_point like 'c%' or c.ship_point like 'ec%') -- edit by Soni 15/05/2017
		and
			b.Qty_confirm = b.Jumlah
		and
			b.reason_rej is null
		and
			isnull(b.kodegudang,'') not in 
			(select display from mastergudang where display = '0' )
		and
			g.grup = 'Lantai_Inquiry_SO_' + convert(varchar,a.kodestore)
		and 
			g.nama like '%' + a.kodeworkstation+ '%'
		and f.Discntin_idc  = 'False'
order by
	a.tanggal desc
	) as x
	order by x.FS
*/

-- 18/02/2019
declare @ParameterRoute varchar(50) -- 08/03/2019
set @ParameterRoute = (select nilai from masterparameter where nama = 'SetupRouteClick&Collect') -- 08/03/2019
select noso, itm_number
into #inquiryso
from sap_trxgiinquiryso
where tanggalstatus >= CONVERT(VARCHAR(10),GETDATE(),111)

SELECT 
	a.statusproses,
	a.noso,
	a.nososap_salesdocument,
	convert(VARCHAR(10), a.tanggal, 103) AS tanggal,
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
	isnull((select top 1 convert(VARCHAR(10), TanggalAntri, 103)  from CB_TrxCounterBarang where nososap = a.nososap_salesdocument ),'')as TglAntri		
FROM 
	TrxSO a
	INNER JOIN TrxSODetail b ON a.noso = b.noso
	INNER JOIN SAP_BapiSDItm c ON a.noso = c.NODOCUMENT
		AND b.Kodebarang = c.material
		AND b.itm_number = c.itm_number
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
	--a.tanggal >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) -- 18/02/2019
	a.tanggal <= CONVERT(VARCHAR(10),GETDATE(),111) -- 18/02/2019
	AND (b.kodegudang = @KodeGudang1
		OR b.kodegudang = @KodeGudang2
		OR b.kodegudang = @KodeGudang3
		OR b.kodegudang = @KodeGudang4
		OR b.kodegudang = @KodeGudang5)
	AND a.statusbatal = '0'
	AND b.item_categ != 'Z005'
	AND(
		(c.ship_point LIKE 'c%'OR c.ship_point LIKE 'ec%')
		OR 
		((c.ship_point like 'P%' or c.ship_point like 'EP%')AND c.Route = @ParameterRoute) -- 08/03/2019		
		)						 
	AND b.Qty_confirm = b.Jumlah
	AND b.reason_rej IS NULL
	AND isnull(b.kodegudang, '') NOT IN (SELECT display FROM mastergudang WHERE display = '0')
	--AND g.grup = 'Lantai_Inquiry_SO_' + convert(VARCHAR, a.kodestore) -- 18/02/2019
	--AND g.nama LIKE '%' + a.kodeworkstation + '%' -- 18/02/2019
	AND h.noso is null
	
ORDER BY 
	FS 
	
END




GO


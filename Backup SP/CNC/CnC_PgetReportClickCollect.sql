USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[CnC_PGetReportClickCollect]    Script Date: 13/05/2020 08.31.02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Daniel
-- Create date: Click and Collect
-- Description:	Report Click and Collect

-- Modified:	Daniel
-- Modified date: 20/03/2019
-- Description:	menambah Tanggal keluar null dan order by tanggal pengiriman asc

-- Modified:	Daniel
-- Modified date: 25/03/2019
-- Description:	menambah dan mengganti pengecekan kodestore menjadi kodestoredepo dan menambah join TrxSOKirim

-- Modified:	Daniel
-- Modified date: 28/03/2019
-- Description : Mengganti pengambilan nama COunterBarang

-- Modified:	Daniel
-- Modified date: 29/03/2019
-- Description : Mengganti pengambilan nama COunterBarang ditambah Kodestore Komputer

-- Modified by	: Ferry Hartono
-- Modif date	: 07/04/2020
-- Description	: Jika picking == '' maka status barang menjadi Full Picking
-- =============================================
ALTER PROCEDURE [dbo].[CnC_PGetReportClickCollect]
	-- Add the parameters for the stored procedure here
	@tanggalawal varchar(50),
	@tanggalakhir varchar(50),
	@KodeStore Varchar(50),
	@CounterBarang varchar(500),
	@Nofaktur varchar(50),
	@KodeStoreCom Varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @ParameterRoute varchar(50) -- 08/03/2019
	set @ParameterRoute = (select nilai from masterparameter where nama = 'SetupRouteClick&Collect')
	
    select distinct 
		   c.faktur as NoFaktur,
		   c.tglpengiriman as TanggalPengambilan,
		   c.namapenerima as NamaPenerima,
		   c.telppenerima as TelpPenerima,
		   c.tanggalAntri as TanggalMasuk,
		   --(select distinct NamaCounter from CB_SetupCounterBarang where namacounter like '%'+@CounterBarang+'%' and c.kodestore = kodestore and IDCounter in (select IDCounter from trxso where c.noso = noso))as CounterBarang,		   		   		   
		   (select top 1 NamaCounter from CB_SetupCounterBarang where KodeStore = @KodeStoreCom and IDCounter = (select nilai from masterparameter where nama = 'ClickCollectCounterBarang'))as CounterBarang,
		   (CASE WHEN
		   (select picking from cb_trxstatusdo where noso = c.nososap ) is null then 'Belum Picking' when
		   (select picking from cb_trxstatusdo where noso = c.nososap ) = '' AND (SELECT IDCounter FROM TrxSO WHERE NoSO = c.NoSO) = (SELECT Nilai FROM MasterParameter WHERE Nama = 'ClickCollectCounterBarang') then 'Full Picking' when
		   (select picking from cb_trxstatusdo where noso = c.nososap ) = 'A' then 'Belum Picking' when
		   (select picking from cb_trxstatusdo where noso = c.nososap ) = 'B' then 'Parsial Picking' when 
		   (select picking from cb_trxstatusdo where noso = c.nososap ) = 'C' then 'Full Picking' end) as StatusBarang,
		   c.kodestore ---------- Tambahan
	from
	(
		select  b.nofaktur as faktur,
				c.nososap,
				a.itm_number,
				a.route, 
				a.nodocument, 
				b.kodestore,
				b.noso,
				b.namapenerima,
				b.tglpengiriman,
				b.telppenerima,				
				c.tanggalAntri
			
		from 
			SAP_BapiSDItm a 
		inner join 
			trxfaktur b 
			on a.nodocument = b.noso  
		inner join   --------------------- Tambahan
			TrxSOKirim d ----------------- Tambahan
			on 	b.noso = d.noso ---------- Tambahan
		left join 
			cb_trxCounterBarang c 
			on  b.nofaktur = c.nofaktur 
		where  
			c.TanggalKeluar is null and
			a.route=@ParameterRoute and b.tglpengiriman is not null  and
			--b.kodestore = @KodeStore and	---	 Tambahan
			--d.KodeStoreDepo = @KodeStore and ---- Tambahan  tutup
		
			convert(datetime,convert(varchar(10),b.tglpengiriman,103),103) 
		between 
			convert(datetime,convert(varchar(10),@tanggalawal,103),103) 
		and 
			convert(datetime,convert(varchar(10),@tanggalakhir,103),103)
	) c 
	where
	c.faktur like '%'+@Nofaktur+'%'
	order by c.tglpengiriman asc
	
	  	
END




GO


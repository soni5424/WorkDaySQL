USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[EX_PGetReportMonitoringStock]    Script Date: 08/04/2022 07:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Description	: Report Monitoring Stock
-- =============================================

ALTER PROCEDURE [dbo].[EX_PGetReportMonitoringStock]
	@jenis			int,
	@TanggalAwal	datetime='19000101',
	@TanggalAkhir	datetime='19000101',
	@PG				varchar(50)='',
	@SalesOffice	varchar(50)='',
	@BonusBuyNo		varchar(50)='',
	@Article		varchar(50)='',
	@IOBuyerBudget	varchar(10)='',
	@IOBuyerCash	varchar(10)='',
	@IOCash			varchar(10)='',
	@IOBiaya		varchar(10)=''
AS

declare 
	@store				varchar(50),
	@company_id			varchar(3)

if (@jenis = 27) -- monitoring all stock
begin
	select distinct 
		article 
	into 
		#tempsaparticlehistory
	from 
		SAP_ArticleHistory
	where
		TabName	= 'MARA'
		and FieldName = 'MSTAE'
		and NewValue <> ''
		and article = @Article

	select distinct
		a.lifnr as vendor_id,
		isnull((select x.namasupplier from mastersupplier x where x.kodesupplier = a.lifnr), '') as vendor_name,
		case when (a.z_consigment = 'X') then 'CONSIGNMENT' else 'PURCHASED' end as article_status,
		substring(a.matl_group,1,2) as pg,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = substring(a.matl_group,1,2)), '') as pg_description,
		substring(a.matl_group,1,4) as category,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = substring(a.matl_group,1,4)), '') as category_description,
		a.matl_group as mc,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = a.matl_group), '') as mc_description,
		a.brand_name,
		a.material,
		isnull(a.z_consigment, '') as consignment,
		REPLACE(REPLACE(a.longtext, CHAR(13), ''), CHAR(10), '') as longtext,
		a.tax_code,
		a.article_type
	into
		#tempsaparticleall
	from
		sap_article a
	where
		a.discntin_idc = 'False'
		and a.matl_group like @PG + '%'
		and a.material not in (select article from #tempsaparticlehistory)
		and a.material = @Article
	
	select 
		v.article, 
		v.AIN,
		h.AinDesc
	into
		#tempsaparticleain
	from 
		VP_NewArticleDetail v,
		HS_MasterAIN h
	where 
		v.AIN = h.AinInit
		and v.AIN <> ''
		and v.article = @Article


	select
		a.material,
		b.aindesc,
		a.pg_description,
		a.article_type,
		a.category_description,
		a.mc_description,
		a.brand_name,
		a.article_status,
		a.vendor_name,
		a.longtext
	from
		#tempsaparticleall a
		left join #tempsaparticleain b on a.material = b.article
end

else if (@jenis = 28) -- stock analyzer promotion, web regular promo, market survey online, price & stock, monitoring all stock
begin
	declare
		@Tax				varchar(5),
		@DPP				decimal(18,2),
		@NetPOPrice			decimal(18,2),
		@NetPurchasePrice	decimal(18,2),
		@TotalZDA			decimal(18,2),
		@TotalZDB			decimal(18,2),
		@TotalZDC			decimal(18,2),
		@TotalZDA14			decimal(18,2),
		@Pengali			decimal(18,2),
		@PengaliPIR			decimal(18,2),
		@VKP5				decimal(18,2),
		@QtyStockPaid		int,
		@AmountStockPaid	decimal(18,2),
		@QtyPOPending		int,
		@AmountPOPending	decimal(18,2),
		@QtySellOut			int,
		@AmountSellOut		decimal(18,2),
		@QtyStock			int,
		@AmountStock		decimal(18,2),
		@SRP				decimal(18,2),
		@Profit				decimal(18,2),
		@AmountProfit		decimal(18,2),
		@CostPrice			decimal(18,2),
		@Old_Mat_No			varchar(50)
	
	select top 1
		a.lifnr as vendor_id,
		isnull((select x.namasupplier from mastersupplier x where x.kodesupplier = a.lifnr), '') as vendor_name,
		case when (a.z_consigment = 'X') then 'CONSIGNMENT' else 'PURCHASED' end as article_status,
		substring(a.matl_group,1,2) as pg,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = substring(a.matl_group,1,2)), '') as pg_description,
		substring(a.matl_group,1,4) as category,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = substring(a.matl_group,1,4)), '') as category_description,
		a.matl_group as mc,
		isnull((select x.description from sap_configmerchandisecategory x where x.mc = a.matl_group), '') as mc_description,
		a.brand_name,
		a.material,
		isnull(a.z_consigment, '') as consignment,
		REPLACE(REPLACE(a.longtext, CHAR(13), ''), CHAR(10), '') as longtext,
		a.tax_code,
		a.old_mat_no
	into
		#tempsaparticle
	from
		sap_article a
	where
		material = @Article
		and discntin_idc = 'False'

	set @Old_Mat_No = (select isnull((select top 1 old_mat_no from #tempsaparticle), ''))
	
	select *
	into #tempatp
	from fi_zatp
	where Article = @Article
		
	set @Tax = (select isnull((select Tax from FI_SetupPIRDetail where Article = @Article), 'M1'))
	set @DPP = (select isnull((select DPP from FI_SetupPIRDetail where Article = @Article), 0))
	set @TotalZDA = (select isnull((select TotalZDA from FI_SetupZDADetail where Article = @Article), 0))
	set @TotalZDB = (select isnull((select TotalZDB from FI_SetupZDBDetail where Article = @Article), 0))
	set @TotalZDC = (select isnull((select TotalZDC from FI_SetupZDCDetail where Article = @Article), 0))
	set @Pengali = (select isnull((select case when tax_code = 'M0' then 1 else 1.1 end from #tempsaparticle), 1.1))
	set @PengaliPIR = (select isnull((select case when @Tax = 'M0' then 1 else 1.1 end), 1.1))
	set @NetPOPrice = (select CEILING(((@DPP - @TotalZDA - @TotalZDB - @TotalZDC) * @Pengali)))
	set @TotalZDA14 = (select isnull((select ISNULL(TotalZDA1, 0) + ISNULL(TotalZDA2, 0) + ISNULL(TotalZDA3, 0) + ISNULL(TotalZDA4, 0) from FI_SetupZDADetail where Article = @Article), 0))
	set @NetPurchasePrice = (@DPP - @TotalZDA14) * @PengaliPIR
	set @VKP5 = (select isnull((select VKP5 from FI_SetupSellingPriceDetail where Article = @Article), 0))
	set @QtyStockPaid = (select isnull((select sum(Quantity) from FI_STOCK_POSITION where Article = @Article and Status = 'Cleared' and PostingDate >= convert(varchar, getdate()-365, 111)), 0))
	set @AmountStockPaid = (select isnull((select sum(Amount) from FI_STOCK_POSITION where Article = @Article and Status = 'Cleared' and PostingDate >= convert(varchar, getdate()-365, 111)), 0))
	set @QtyStock = (select isnull((select sum(atpnormal) from #tempatp), 0))
	set @AmountStock = @QtyStock * @DPP
	
	select *
	into #temptempsellout
	from tempsellout
	where salesdate >= convert(varchar, getdate()-35, 111)
	and article = @Article
	
	select *
	into #temppopendingdetail
	from FI_POPendingDetail 
	where Article = @Article

	set @QtyPOPending = (select isnull((select sum(Quantity) from #temppopendingdetail), 0))
	set @AmountPOPending = @QtyPOPending * @DPP
	set @QtySellOut = (select isnull((select sum(Qty) from #temptempsellout), 0))
	set @AmountSellOut = @QtySellOut * @DPP
	
	select *
	into #tempsellingprice
	from 
		FI_SetupSellingPriceDetail
	where 
		Article = @Article
		
		
	set @SRP = (select isnull((select SRP from FI_SetupSellingPriceDetail where Article = @Article), 0))
	--set @Profit	= (select isnull((select top 1 Profit from FI_SetupMCProfit s, #tempsaparticle a where s.mc = a.mc), 0))
	--set @AmountProfit = @Profit * @NetPurchasePrice / 100
	set @CostPrice = (select isnull((select SellingCostPriceZDAHit from FI_SetupSellingPriceDetail where Article = @Article), 0))

	if (@jenis = 28) -- monitoring all stock
	begin 
		select distinct
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		into 
			#pr_masterpromo_offline
		from
			pr_masterpromo p,
			pr_masterpromodetailbarangutama u,
			pr_masterpromodetailpotonganharga h,
			ph_masterpromodetailstore s
		where
			p.kodepromo = u.kodepromo
			and p.kodepromo = h.kodepromo
			and p.kodepromo = s.kodepromo
			and p.tanggalawal <= getdate()
			and getdate()-1 < p.tanggalakhir
			and p.status <> '2'
			and s.kodestore in ('01', '04', '06', '08', '12', '13', '17')
			--and s.kodestore not in ('07', '10')
			and u.kodebarang = @Old_Mat_No
			and p.jumlahpromo in (0, 999)
		group by
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		having
			COUNT(s.kodestore) >= 6
			
		select distinct
			j.kodepromo2
		into
			#pr_masterpromoncc_offline 
		from
			#pr_masterpromo_offline p,
			PR_MasterPromoDetailJenisPembayaran j
		where
			p.kodepromo = j.kodepromo2
		
		select distinct
			f.kodepromo
		into
			#pr_masterpromopwp_offline 
		from
			#pr_masterpromo_offline p,
			PR_MasterPromoDetailBarangFree f
		where
			p.kodepromo = f.kodepromo
			and (
			(f.jenisnilai = '%' and f.potonganvpr < 100)
			or 
			(f.jenisnilai = 'IDR')
			)

		select 
			kodepromo,
			tanggalakhir,
			case 
				when jenisnilai = '%' then cast(jumlah/100 * @VKP5 as decimal(18,2)) 
				else jumlah end as jumlah
		into
			#pr_masterpromodetailpotonganharga_offline
		from
			#pr_masterpromo_offline
			
		select top 1 * 
		into #promooffline 
		from #pr_masterpromodetailpotonganharga_offline 
		where
			kodepromo not in (select kodepromo2 from #pr_masterpromoncc_offline)
			and kodepromo not in (select kodepromo from #pr_masterpromopwp_offline)
		order by jumlah desc
		
		select distinct
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		into 
			#pr_masterpromo_online
		from
			pr_masterpromo p,
			pr_masterpromodetailbarangutama u,
			pr_masterpromodetailpotonganharga h,
			ph_masterpromodetailstore s
		where
			p.kodepromo = u.kodepromo
			and p.kodepromo = h.kodepromo
			and p.kodepromo = s.kodepromo
			and p.tanggalawal <= getdate()
			and getdate()-1 < p.tanggalakhir
			and p.status <> '2'
			and s.kodestore in ('07')
			--and s.kodestore not in ('01', '04', '06', '08', '12', '13', '17')
			and u.kodebarang = @Old_Mat_No
			and p.jumlahpromo in (0, 999)
		group by
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		having
			COUNT(s.kodestore) >= 1
		
		select distinct
			j.kodepromo2
		into
			#pr_masterpromoncc_online 
		from
			#pr_masterpromo_online p,
			PR_MasterPromoDetailJenisPembayaran j
		where
			p.kodepromo = j.kodepromo2

		select distinct
			f.kodepromo
		into
			#pr_masterpromopwp_online 
		from
			#pr_masterpromo_online p,
			PR_MasterPromoDetailBarangFree f
		where
			p.kodepromo = f.kodepromo
			and (
			(f.jenisnilai = '%' and f.potonganvpr < 100)
			or 
			(f.jenisnilai = 'IDR')
			)

		select 
			kodepromo,
			tanggalakhir,
			case 
				when jenisnilai = '%' then cast(jumlah/100 * @VKP5 as decimal(18,2)) 
				else jumlah end as jumlah
		into
			#pr_masterpromodetailpotonganharga_online
		from
			#pr_masterpromo_online

		select top 1 * 
		into #promoonline 
		from #pr_masterpromodetailpotonganharga_online 
		where
			-- kodepromo not in (select kodepromo2 from #pr_masterpromoncc_online)
			--and 
			kodepromo not in (select kodepromo from #pr_masterpromopwp_online)
		order by jumlah desc
		
		select distinct
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		into 
			#pr_masterpromo_mp
		from
			pr_masterpromo p,
			pr_masterpromodetailbarangutama u,
			pr_masterpromodetailpotonganharga h,
			ph_masterpromodetailstore s
		where
			p.kodepromo = u.kodepromo
			and p.kodepromo = h.kodepromo
			and p.kodepromo = s.kodepromo
			and p.tanggalawal <= getdate()
			and getdate()-1 < p.tanggalakhir
			and p.status <> '2'
			and s.kodestore in ('10')
			--and s.kodestore not in ('01', '04', '06', '08', '12', '13', '17')
			and u.kodebarang = @Old_Mat_No
			and p.jumlahpromo in (0, 999)
		group by
			h.kodepromo,
			p.tanggalakhir,
			h.jumlah,
			h.jenisnilai
		having
			COUNT(s.kodestore) >= 1

		select distinct
			j.kodepromo2
		into
			#pr_masterpromoncc_mp 
		from
			#pr_masterpromo_mp p,
			PR_MasterPromoDetailJenisPembayaran j
		where
			p.kodepromo = j.kodepromo2

		select distinct
			f.kodepromo
		into
			#pr_masterpromopwp_mp 
		from
			#pr_masterpromo_mp p,
			PR_MasterPromoDetailBarangFree f
		where
			p.kodepromo = f.kodepromo
			and (
			(f.jenisnilai = '%' and f.potonganvpr < 100)
			or 
			(f.jenisnilai = 'IDR')
			)

		select 
			kodepromo,
			tanggalakhir,
			case 
				when jenisnilai = '%' then cast(jumlah/100 * @VKP5 as decimal(18,2)) 
				else jumlah end as jumlah
		into
			#pr_masterpromodetailpotonganharga_mp
		from
			#pr_masterpromo_mp

		select top 1 * 
		into #promomp 
		from #pr_masterpromodetailpotonganharga_mp 
		where
			-- kodepromo not in (select kodepromo2 from #pr_masterpromoncc_mp)
			-- and 
			kodepromo not in (select kodepromo from #pr_masterpromopwp_mp)
		order by jumlah desc

		select
			@VKP5,
			@DPP,
			@NetPOPrice,
			@NetPurchasePrice,
			'', -- garis
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '01'), 0) as salesoffice_BDB,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '12'), 0) as salesoffice_KTI,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '06'), 0) as salesoffice_BGJ,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '13'), 0) as salesoffice_MSQ,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '04'), 0) as salesoffice_MLG,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '08'), 0) as salesoffice_PIN,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '17'), 0) as salesoffice_SDN,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '07'), 0) as salesoffice_MAR,
			0 as salesoffice_DPM,
			ISNULL((select SUM(x.qty) from #temptempsellout x where x.KodeStore = '10'), 0) as salesoffice_EXH,
			0 as salesoffice_BDB10, 
			0 as salesoffice_PIN07,
			@QtySellOut,
			@AmountSellOut,
			'', -- garis
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S001'), 0) as stock_BDB,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S002'), 0) as stock_KTI,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S004'), 0) as stock_BGJ,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S005'), 0) as stock_MSQ,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S006'), 0) as stock_MLG,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S008'), 0) as stock_PIN,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'S009'), 0) as stock_SDN,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'D005'), 0) as stock_DPM,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'D001'), 0) as stock_RKT,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'D002'), 0) as stock_DRY,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'D003'), 0) as stock_DPI,
			0, '', -- Display & Total
			ISNULL((select ATPNormal from #tempatp x where x.site = 'D004'), 0) as stock_DPC,
			0, '', -- Display & Total
			@QtyStock,
			@AmountStock,
			0,'','','', -- Display & Total
			'', -- garis
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S001'), 0) as popending_BDB,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S002'), 0) as popending_KTI,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S004'), 0) as popending_BGJ,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S005'), 0) as popending_MSQ,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S006'), 0) as popending_MLG,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S008'), 0) as popending_PIN,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'S009'), 0) as popending_SDN,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'D001'), 0) as popending_RKT,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'D002'), 0) as popending_DRY,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'D003'), 0) as popending_DPI,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'D004'), 0) as popending_DCK,
			ISNULL((select SUM(x.quantity) from #temppopendingdetail x where x.site = 'D005'), 0) as popending_DPM,
			0 as popending_BDB10,
			0 as popending_PIN07,
			@QtyPOPending,
			@AmountPOPending,
			'', -- garis
			@QtyStockPaid,
			@AmountStockPaid,
			'', -- garis
			'', -- garis
			'', -- garis
			'', -- garis
			'', -- garis
			'', -- garis
			ISNULL((select max(x.jumlah) from #promooffline x), 0) as discoffline,
			'', -- %
			isnull((select convert(varchar, tanggalakhir, 103) from #promooffline), '') as tanggalakhiroffline,
			ISNULL((select max(x.jumlah) from #promoonline x), 0) as disconline,
			'', -- %
			isnull((select convert(varchar, tanggalakhir, 103) from #promoonline), '') as tanggalakhironline,
			ISNULL((select max(x.jumlah) from #promomp x), 0) as discmp,
			'', -- %
			isnull((select convert(varchar, tanggalakhir, 103) from #promomp), '') as tanggalakhirmp
		from
			#tempsaparticle a
	end
end
else if (@jenis = 58) -- report penjualan dengan keterangan (FK 10)
	begin
		set @store = ''
		if (@SalesOffice <> '')
		begin
			set @store = (select isnull((select KodeStore from MasterStore where sales_off = @SalesOffice and KodeStore <> '00'), ''))
		end
	
		select 
			nofaktur,
			tanggal,
			pointrewardto,
			noso,
			keteranganso,
			keterangan,
			kodestore,
			tglpengiriman,
			totalharga
		into
			#trxfaktur_10
		from
			trxfaktur
		where
			convert(varchar, tanggal, 111) >= convert(varchar, @TanggalAwal, 111)
			and convert(varchar, tanggal, 111) < convert(varchar, (dateadd(day, 1, @TanggalAkhir)), 111)
			and kodestore like '%'+@store+'%'
			and pointrewardto like '%'+@BonusBuyNo+'%'
		
		select
			d.nofaktur,
			d.kodebarang,
			d.itm_number,
			d.jumlah,
			d.subtotalharga
		into
			#trxfakturdetail_10
		from
			#trxfaktur_10 f,
			trxfakturdetail d
		where
			f.nofaktur = d.nofaktur
		
		select
			s.*
		into
			#sap_trxsosto_10
		from
			#trxfaktur_10 f,
			sap_trxsosto s
		where
			s.noso = f.noso
		
		select
			s.*
		into
			#trxsokirim_10
		from
			#trxfaktur_10 f,
			trxsokirim s
		where
			s.noso = f.noso
		
		select distinct
			j.kodejalan,
			j.namajalan
		into
			#masterjalan_10
		from
			masterjalan j,
			#trxsokirim_10 s
		where
			j.kodejalan = s.kodejalan
		
		select distinct
			k.kodekota,
			k.namakota
		into
			#masterkota_10
		from
			masterkota k,
			#trxsokirim_10 s
		where
			k.kodekota = s.kodekota

		select distinct
			m.nomember,
			m.namamember
		into
			#mastermember_10
		from
			#trxfaktur_10 f,
			mastermember m
		where	
			f.pointrewardto = m.nomember
		
		select distinct
			a.material,
			a.old_mat_no,
			a.matl_group
		into
			#sap_article_10
		from
			#trxfakturdetail_10 d,
			sap_article a
		where
			d.kodebarang = a.old_mat_no
			and a.discntin_idc = 'False'
			and a.matl_group like @PG+'%'
		
		select
			b.nodocument,
			b.itm_number,
			b.material,
			b.ship_point,
			b.route
		into
			#SAP_BAPISDITM_10
		from
			SAP_BAPISDITM b,
			#trxfaktur_10 f
		where
			b.nodocument = f.noso
		
		select
			f.KeteranganSO,
			f.nofaktur,
			f.tanggal,
			f.pointrewardto,
			m.namamember,
			d.kodebarang,
			CASE
				WHEN d.kodebarang LIKE '%TRANSPORT%' THEN 'Transport'
				ELSE 'Barang Utama'
			END AS jenisbarang,
			isnull(s.siteasal1, isnull(x.kodestorestock, f.kodestore)) as siteasal,
			isnull(s.sitetujuan1, isnull(x.KodeStoreDepo, f.kodestore)) as sitetujuan,
			d.Jumlah,
			d.SubtotalHarga,
			isnull((f.totalharga - (SELECT SUM(JumlahBayar) FROM TrxPelunasanDetail WHERE NoFaktur = f.nofaktur)), 0) as sisabayar,
			f.Keterangan,
			isnull(convert(varchar, f.TglPengiriman, 103), '') as TglPengiriman,
			isnull(b.ship_point, '') as ship_point,
			isnull(k.namakota, '') as namakota,
			isnull(j.namajalan, '') as namajalan,
			isnull(rtr.noreturpenjualan, '') as noretur
		from
			#trxfaktur_10 f
			inner join #trxfakturdetail_10 d on f.nofaktur = d.nofaktur
			inner join #mastermember_10 m on f.pointrewardto = m.nomember
			inner join #sap_article_10 a on d.kodebarang = a.old_mat_no
			left join #SAP_BAPISDITM_10 b on b.nodocument = f.noso and b.itm_number = d.itm_number and b.material = a.material
			left join #sap_trxsosto_10 s on s.noso = f.noso and s.itm_number = d.itm_number and s.kodebarang = d.kodebarang
			left join #trxsokirim_10 x on x.noso = f.noso
			left join #masterkota_10 k on k.kodekota = x.kodekota
			left join #masterjalan_10 j on j.kodejalan = x.kodejalan
			left join TrxReturPenjualan rtr on f.nofaktur = rtr.nofaktur
		order by
			f.tanggal,
			f.nofaktur
	end
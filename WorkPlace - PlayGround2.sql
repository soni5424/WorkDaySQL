--TipeBayar_PGetNotifTipeBayarByKodePromo '100053778-02'

--select * from PR_MasterPromoDetailJenisPembayaran where kodepromo2='100053778-02' order by tanggalAwal desc
--select * from PR_MasterPromoDetailBarangUtama where kodepromo='100053778-02'


--100053778-02


--exec PrTipeBayar_GetKeteranganTipeBayar '100075454-01'

--exec TipeBayar_PGetNotifTipeBayarByKodePromo '100075454-01'


select  SUBSTRING('FK-01-B51-00001', 7, 3)

SUBSTRING(NoSO, 8, 3)

select * from TrxRekasDetailCard


SELECT workstation FROM SAP_User where workstation='K22'

select * FROM SAP_VENDOR
select * from TrxRekasSAP

select * from TrxRekasDetailSetoranTunaiDetail
SELECT distinct workstation INTO #TWS28 FROM [192.168.9.28].hartono.dbo.SAP_User

select * from [192.168.9.14\sqladira].hartono.dbo.PND_TrxPelunasan
where NoPelunasan not in (SELECT NoPelunasan FROM PND_TrxPelunasan)

TrxReturPenjualan


select * from MasterVoucherBuyBack	order by Tanggal desc


select * from CH_SetupJenisPembayaranCard

SELECT distinct workstation FROM [192.168.9.28].hartono.dbo.SAP_User



INSERT INTO [Hartono].[dbo].[TrxSODetail]
           ([NoSO]
           ,[KodeBarang]
           ,[KodeStore]
           ,[KodeGudang]
           ,[HargaBarang]
           ,[Jumlah]
           ,[StatusBarang]
           ,[Discount]
           ,[SubTotalHarga]
           ,[IsPerlengkapan]
           ,[PointSales]
           ,[PointMember]
           ,[StatusBesarKecil]
           ,[StatusBarangGudang]
           ,[Keterangan]
           ,[KodeBarangKit]
           ,[IsItemKit]
           ,[PointRedeem]
           ,[SubTotalPoint]
           ,[rowguid]
           ,[ITM_NUMBER]
           ,[HG_LV_ITEM]
           ,[MATERIAL]
           ,[ITEM_CATEG]
           ,[Reason_REJ]
           ,[DiscountGabungan]
           ,[QTY_CONFIRM]
           ,[UpdateFlag]
           ,[FlagDelete])
     VALUES
           (<NoSO, char(16),>
           ,<KodeBarang, char(20),>
           ,<KodeStore, char(2),>
           ,<KodeGudang, char(6),>
           ,<HargaBarang, decimal(18,2),>
           ,<Jumlah, int,>
           ,<StatusBarang, bit,>
           ,<Discount, decimal(18,2),>
           ,<SubTotalHarga, decimal(18,2),>
           ,<IsPerlengkapan, bit,>
           ,<PointSales, decimal(10,2),>
           ,<PointMember, decimal(10,2),>
           ,<StatusBesarKecil, bit,>
           ,<StatusBarangGudang, char(3),>
           ,<Keterangan, varchar(200),>
           ,<KodeBarangKit, varchar(50),>
           ,<IsItemKit, bit,>
           ,<PointRedeem, decimal(10,2),>
           ,<SubTotalPoint, decimal(10,2),>
           ,<rowguid, uniqueidentifier,>
           ,<ITM_NUMBER, int,>
           ,<HG_LV_ITEM, int,>
           ,<MATERIAL, varchar(50),>
           ,<ITEM_CATEG, varchar(5),>
           ,<Reason_REJ, varchar(2),>
           ,<DiscountGabungan, decimal(18,2),>
           ,<QTY_CONFIRM, int,>
           ,<UpdateFlag, varchar(1),>
           ,<FlagDelete, varchar(1),>)
GO

select top 10 *  from [192.168.9.14\sqladira].hartono.dbo.TrxFaktur
order by tanggal desc
	
select top 10 *  from TrxFaktur
order by tanggal desc

select top 10 * from AD_TrxFakturProsesInsurance
order by TanggalFakturIns desc




INSERT INTO [Hartono].[dbo].[TrxFakturDetail]
           ([NoFaktur]
           ,[KodeBarang]
           ,[KodeGudang]
           ,[HargaCP]
           ,[HargaBarang]
           ,[Jumlah]
           ,[Discount]
           ,[PointSales]
           ,[SubTotalHarga]
           ,[PointMember]
           ,[KodeBarangKit]
           ,[PointRedeem]
           ,[SubTotalPoint]
           ,[IsItemKit]
           ,[rowguid]
           ,[ITM_NUMBER]
           ,[HG_LV_ITEM]
           ,[MATERIAL]
           ,[ITEM_CATEG]
           ,[Reason_REJ]
           ,[DiscountGabungan])
     VALUES
           (<NoFaktur, char(18),>
           ,<KodeBarang, char(20),>
           ,<KodeGudang, char(6),>
           ,<HargaCP, decimal(18,2),>
           ,<HargaBarang, decimal(18,2),>
           ,<Jumlah, int,>
           ,<Discount, decimal(18,2),>
           ,<PointSales, decimal(10,2),>
           ,<SubTotalHarga, decimal(18,2),>
           ,<PointMember, decimal(10,2),>
           ,<KodeBarangKit, varchar(50),>
           ,<PointRedeem, decimal(10,2),>
           ,<SubTotalPoint, decimal(10,2),>
           ,<IsItemKit, bit,>
           ,<rowguid, uniqueidentifier,>
           ,<ITM_NUMBER, int,>
           ,<HG_LV_ITEM, int,>
           ,<MATERIAL, varchar(50),>
           ,<ITEM_CATEG, varchar(5),>
           ,<Reason_REJ, varchar(2),>
           ,<DiscountGabungan, decimal(18,2),>)
GO


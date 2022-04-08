--=== RUN di 9.14\SQLGEHM ===---
--=== JALANKAN TABLE TEMP ini dulu ===---

SELECT distinct workstation INTO #TWS28 FROM [192.168.9.28].hartono.dbo.SAP_User

--drop table #TSO

select * into #TSO from [192.168.9.14\sqladira].hartono.dbo.TrxSO
where Tanggal >= '20220404'
	AND NoSO not in (SELECT NoSO FROM TrxSO)
	AND KodeWorkStation in  (SELECT workstation FROM #TWS28)


   --drop table #TFK
select * INTO #TFK from [192.168.9.14\sqladira].hartono.dbo.TrxFaktur
where Tanggal >= '20220404'
	AND NoFaktur not in (SELECT NoFaktur FROM TrxFaktur)
	AND KodeWorkStation in (SELECT workstation FROM #TWS28)


insert into TrxSO
select * from #TSO
insert into TrxSODetail ([NoSO]
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
select [NoSO]
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
           ,[FlagDelete] from [192.168.9.14\sqladira].hartono.dbo.TrxSODetail
where NoSO IN (SELECT NoSO FROM #TSO)

insert into PR_TrxSODetailWithPromo
select * from [192.168.9.14\sqladira].hartono.dbo.PR_TrxSODetailWithPromo
where NoSO IN (SELECT NoSO FROM #TSO)


insert into TrxFaktur
select * from #TFK
insert into TrxFakturDetail ([NoFaktur]
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
select [NoFaktur]
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
           ,[DiscountGabungan] from [192.168.9.14\sqladira].hartono.dbo.TrxFakturDetail
where NoFaktur in (select NoFaktur from #TFK)


insert into TrxFakturBayar
select * from [192.168.9.14\sqladira].hartono.dbo.TrxFakturBayar
where NoFaktur in (select NoFaktur from #TFK)

insert into TrxFakturBayarVPR
select * from [192.168.9.14\sqladira].hartono.dbo.TrxFakturBayarVPR
where NoFaktur in (select NoFaktur from #TFK)

insert into AD_TrxFakturProsesInsurance
select * from [192.168.9.14\sqladira].hartono.dbo.AD_TrxFakturProsesInsurance
where NoFakturIns IN (select NoFaktur from #TFK)

insert into AD_TrxFakturProsesInsuranceDetail
select * from [192.168.9.14\sqladira].hartono.dbo.AD_TrxFakturProsesInsuranceDetail
where NoFakturIns IN (select NoFaktur from #TFK)

insert into MB_TrxFakturBayarMember
select * from [192.168.9.14\sqladira].hartono.dbo.MB_TrxFakturBayarMember
where NoFaktur IN (select NoFaktur from #TFK)

insert into AD_TrxTambahInsurance
select * from [192.168.9.14\sqladira].hartono.dbo.AD_TrxTambahInsurance
where NoFakturIns not in (SELECT NoFakturIns FROM AD_TrxTambahInsurance)
	AND NoFakturIns IN (select NoFaktur from #TFK)





insert into CS_TrxPengajuanCNAdmin
select * from [192.168.9.14\sqladira].hartono.dbo.CS_TrxPengajuanCNAdmin
where Tanggal >= '20220404'
	AND NoPengajuan in (SELECT NoPengajuan FROM CS_TrxPengajuanCNAdmin)
	AND NoFaktur IN (select NoFaktur from #TFK)



select * INTO #TRP from [192.168.9.14\sqladira].hartono.dbo.TrxReturPenjualan
where Tanggal >= '20220404'
	AND NoReturPenjualan not in (SELECT NoReturPenjualan FROM TrxReturPenjualan)
	AND KodeWorkStation in (SELECT workstation FROM #TWS28)
insert into TrxReturPenjualan
select * from #TRP

insert into TrxReturPenjualanDetail

select * from [192.168.9.14\sqladira].hartono.dbo.TrxReturPenjualanDetail
where NoReturPenjualan in (select NoReturPenjualan from #TRP)

insert into MasterVoucherBuyBack
select * from [192.168.9.14\sqladira].hartono.dbo.MasterVoucherBuyBack
where 
	NoVoucherBuyBack not in (SELECT NoVoucherBuyBack FROM MasterVoucherBuyBack)
	AND KodeWS in (SELECT workstation FROM #TWS28)

insert into CS_TrxApprovalCNAdmin
select * from [192.168.9.14\sqladira].hartono.dbo.CS_TrxApprovalCNAdmin
where TglApproval >= '20220404'
	AND  NoPengajuan NOT in (SELECT NoPengajuan FROM CS_TrxApprovalCNAdmin)

select * INTO #TLPH from [192.168.9.14\sqladira].hartono.dbo.TrxLPH
where NoLPH not in (SELECT NoLPH FROM TrxLPH)
	AND KodeWorkStation IN (SELECT workstation FROM #TWS28)

insert into TrxLPH
select * FROM #TLPH

insert into TrxLPHDetail
select * from [192.168.9.14\sqladira].hartono.dbo.TrxLPHDetail
where NoLPH01 in (select NoLPH FROM #TLPH)

--=== yg di pakai hanya NoLPH01 ===---
	--OR 	NoLPH02 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH03 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH04 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH05 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH06 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH07 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH08 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH09 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH10 in (select NoLPH FROM #TLPH)

insert into MasterUserBackOffice
select * from [192.168.9.14\sqladira].hartono.dbo.MasterUserBackOffice
where UserID not in (SELECT UserID FROM MasterUserBackOffice)

insert into PND_TrxPelunasan
select * from [192.168.9.14\sqladira].hartono.dbo.PND_TrxPelunasan
where NoPelunasan not in (SELECT NoPelunasan FROM PND_TrxPelunasan)

insert into TrxRekasDetailRekonCARD
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasDetailRekonCARD
where NoRekas not in (SELECT NoRekas FROM TrxRekasDetailRekonCARD)

insert into PND_TrxRealisasiPND
select * from [192.168.9.14\sqladira].hartono.dbo.PND_TrxRealisasiPND
where NoPND not in (SELECT NoPND FROM PND_TrxRealisasiPND)
    AND SUBSTRING(NoPND,8,3) in (SELECT workstation FROM #TWS28)

insert into PND_TrxPengajuan
select * from [192.168.9.14\sqladira].hartono.dbo.PND_TrxPengajuan
where NoPND not in (SELECT NoPND FROM PND_TrxPengajuan)
    AND SUBSTRING(NoPND,8,3) in (SELECT workstation FROM #TWS28)

insert into AttachmentRequest
select * from [192.168.9.14\sqladira].hartono.dbo.AttachmentRequest
where NoDocument not in (SELECT NoDocument FROM AttachmentRequest)
    AND SUBSTRING(NoDocument,8,3) in (SELECT workstation FROM #TWS28)









--=== waktu di cek data kosong / tidak ada yg perlu di insert ===---
select * INTO #TRKS from [192.168.9.14\sqladira].hartono.dbo.TrxRekas
where Tanggal <= '20220404'
	AND KodeWS in (SELECT workstation FROM #TWS28)
	AND NoRekas not in (SELECT NoRekas FROM TrxRekas)
insert into TrxRekas
select * from #TRKS

insert into TrxRekasDetailCard
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasDetailCard
where NoRekas in (select NoRekas FROM #TRKS)

insert into TrxRekasDetailCard
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasDetailCard
where NoRekas in (select NoRekas FROM #TRKS)

insert into TrxRekasDetailNonCard
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasDetailNonCard
where NoRekas in (select NoRekas FROM #TRKS)

insert into TrxRekasSAP
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasSAP
where NoRekas in (select NoRekas FROM #TRKS)

insert into TrxRekasDetailSetoranTunaiDetail
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekasDetailSetoranTunaiDetail
where NoRekas in (select NoRekas FROM #TRKS)

insert into CH_SetupJenisPembayaranCard
select * from [192.168.9.14\sqladira].hartono.dbo.CH_SetupJenisPembayaranCard
where BankIDBIN not in (SELECT BankIDBIN FROM CH_SetupJenisPembayaranCard)

insert into CH_SetupBIN
select * from [192.168.9.14\sqladira].hartono.dbo.CH_SetupBIN
where BankID not in (SELECT BankID FROM CH_SetupBIN)

insert into MB_SetupJenisPembayaranMemberBIN
select * from [192.168.9.14\sqladira].hartono.dbo.MB_SetupJenisPembayaranMemberBIN
where KodeJenisPembayaran not in (SELECT KodeJenisPembayaran FROM MB_SetupJenisPembayaranMemberBIN)

insert into SAP_VENDOR
select * from [192.168.9.14\sqladira].hartono.dbo.SAP_VENDOR
where VENDOR_AC_NUMB not in (select VENDOR_AC_NUMB FROM SAP_VENDOR)

insert into MasterPermission
select * from [192.168.9.14\sqladira].hartono.dbo.MasterPermission
where KodePermission not in (SELECT KodePermission FROM MasterPermission)

insert into MB_SetupBenefitBIN
select * from [192.168.9.14\sqladira].hartono.dbo.MB_SetupBenefitBIN
where BIN not in (SELECT BIN FROM MB_SetupBenefitBIN)

insert into MasterMerk
select * from [192.168.9.14\sqladira].hartono.dbo.MasterMerk
where Merk not in (SELECT Merk FROM MasterMerk)

insert into MasterPilihan
select * from [192.168.9.14\sqladira].hartono.dbo.MasterPilihan
where Grup not in (SELECT Grup FROM MasterPilihan)

insert into MasterKota
select * from [192.168.9.14\sqladira].hartono.dbo.MasterKota
where KodeKota not in (SELECT KodeKota FROM MasterKota)

select * from [192.168.9.14\sqladira].hartono.dbo.SAP_MasterSalesLeasing
where IDSalesLeasing not in (SELECT IDSalesLeasing FROM SAP_MasterSalesLeasing)


--=== waktu di cek data kosong / tidak ada yg perlu di insert ===---

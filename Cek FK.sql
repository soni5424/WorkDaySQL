USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[SAP_PGetListFakturCetakByKodeStoreForRetur]    Script Date: 24/07/2023 11.55.14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Created By	: Soni.Gunawan
-- Created Date	: 24.7.23
-- Description	: SP Asal SAP_PGetListFakturCetakByKodeStoreForRetur
-- =============================================

Create PROCEDURE [SAP_PGetListFakturCetakByKodeStoreForRetur2]
	@NoFaktur 	varchar(50),
	@Tanggal	datetime,
	@Retur 		varchar(1)
AS
BEGIN
	if(@Retur = 1)
	Begin
	  IF (dbo.FReturAll(@NoFaktur)!=0) SELECT 'Faktur harus memiliki barang yang di Retur'
	  IF (dbo.getonlydate(@Tanggal) != dbo.getonlydate(getdate())) SELECT 'Faktur bukan hari ini'
	  IF (EXISTS(select * from TrxVoidPenjualan WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah di Void'
	  IF (EXISTS(select * from TrxReturPenjualan WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah di Retur'
	  IF (EXISTS(select * from ES_TrxKlaimApprovalDiscDetail WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah Klaim Approval Disc'
	  IF (EXISTS(select * from MB_TrxFakturHEPC WHERE NoFakturHEPC=@NoFaktur)) SELECT 'Faktur telah Klaim Approval Disc'
	  IF (EXISTS(select * from CL_TrxRegisterKelas WHERE NoFakturPendaftaran = @NoFaktur)) SELECT 'Faktur terdaftar di Register Kelas EZ'
	  IF (EXISTS(select * from TrxBLT WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT2 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur2 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT3 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur3 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT4 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT5 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur5 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT6 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur6 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT7 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT8 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT9 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur9 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT10 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT11 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT12 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTHistory WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFakturHistory WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from WF_TrxPromoWFDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo WF'
	  IF (EXISTS(select * from KHAE_TrxGamesArcadeDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo KHAE'
	  IF (EXISTS(select * from KHAE_TrxPromoDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo KHAE'
	  IF (EXISTS(select * from CC_PromoKuponDiskon WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo Kupon'
	  IF (EXISTS(select * from MasterPromoDiscountDetailPakai A join trxfaktur B on B.NoFaktur=@NoFaktur AND A.NoSO=B.NoSO and A.Status='1') AND @NoFaktur NOT in (select NoFaktur from BLT_TrxOpenLock)) SELECT 'Faktur terdaftar sebagai Promo Terpakai'
	  IF (EXISTS(select * from TrxPengajuanRetur WHERE NoFaktur=@NoFaktur and (@NoFaktur in (select NoFaktur from TrxPengajuanVoidPenjualan)))) SELECT 'Faktur melakukan pengajuan Retur'
	  IF (EXISTS(select * from PR_TrxFormTradeIn where NoFaktur=@NoFaktur and StatusBatal is not null)) SELECT 'Faktur Trade in telah dibatal'
	  IF (EXISTS(select * from TrxFakturDetail where NoFaktur=@NoFaktur and KodeBarang NOT in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%') AND @NoFaktur NOT IN (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar Memiliki Kupon Disc'
	  IF (EXISTS(select * from [192.168.9.27].Hartono.dbo.t_LuckyDrawSamsungDetailPakai WHERE NoFakturUtama=@NoFaktur AND @NoFaktur NOT in (select NoFaktur from OpenFK_TrxOpenLock))) SELECT 'Faktur terdapat promo LuckyDrawSamsung'
	End 
	Else if(@Retur = 0)
	Begin
	  IF (dbo.FReturAll(@NoFaktur)!=0) SELECT 'Faktur harus memiliki barang yang di Retur'
	  IF (dbo.getonlydate(@Tanggal) > dbo.getonlydate(getdate())) SELECT 'Tanggal Faktur melebihi tanggal hari ini'
	  IF (EXISTS(select * from TrxVoidPenjualan WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah di Void'
	  IF (EXISTS(select * from TrxReturPenjualan WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah di Retur'
	  IF (EXISTS(select * from ES_TrxKlaimApprovalDiscDetail WHERE NoFaktur = @NoFaktur)) SELECT 'Faktur telah Klaim Approval Disc'
	  IF (EXISTS(select * from MB_TrxFakturHEPC WHERE NoFakturHEPC=@NoFaktur)) SELECT 'Faktur telah Klaim Approval Disc'
	  IF (EXISTS(select * from CL_TrxRegisterKelas WHERE NoFakturPendaftaran = @NoFaktur)) SELECT 'Faktur terdaftar di Register Kelas EZ'
	  IF (EXISTS(select * from TrxBLT WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT2 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur2 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT3 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur3 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT4 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT5 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur5 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT6 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur6 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT7 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT8 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT9 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFaktur9 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT10 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT11 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLT12 WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTHistory WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from TrxBLTFakturHistory WHERE NoFaktur=@NoFaktur AND @NoFaktur not in (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar sebagai penerima BLT'
	  IF (EXISTS(select * from WF_TrxPromoWFDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo WF'
	  IF (EXISTS(select * from KHAE_TrxGamesArcadeDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo KHAE'
	  IF (EXISTS(select * from KHAE_TrxPromoDetail WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo KHAE'
	  IF (EXISTS(select * from CC_PromoKuponDiskon WHERE NoFaktur=@NoFaktur)) SELECT 'Faktur terdaftar sebagai Promo Kupon'
	  IF (EXISTS(select * from MasterPromoDiscountDetailPakai A join trxfaktur B on B.NoFaktur=@NoFaktur AND A.NoSO=B.NoSO and A.Status='1') AND @NoFaktur NOT in (select NoFaktur from BLT_TrxOpenLock)) SELECT 'Faktur terdaftar sebagai Promo Terpakai'
	  IF (EXISTS(select * from TrxPengajuanRetur WHERE NoFaktur=@NoFaktur and (@NoFaktur in (select NoFaktur from TrxPengajuanVoidPenjualan)))) SELECT 'Faktur melakukan pengajuan Retur'
	  IF (EXISTS(select * from PR_TrxFormTradeIn where NoFaktur=@NoFaktur and StatusBatal is not null)) SELECT 'Faktur Trade in telah dibatal'
	  IF (EXISTS(select * from TrxFakturDetail where NoFaktur=@NoFaktur and KodeBarang NOT in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%') AND @NoFaktur NOT IN (select NoFaktur from BLT_TrxOpenLock))) SELECT 'Faktur terdaftar Memiliki Kupon Disc'
	  IF (EXISTS(select * from [192.168.9.27].Hartono.dbo.t_LuckyDrawSamsungDetailPakai WHERE NoFakturUtama=@NoFaktur AND @NoFaktur NOT in (select NoFaktur from OpenFK_TrxOpenLock))) SELECT 'Faktur terdapat promo LuckyDrawSamsung'
	End
END
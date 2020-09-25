USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SAP_PGetListFakturCetakByKodeStoreForRetur]    Script Date: 21/07/2020 03.14.09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Modified By		: Rini Handini
-- Modified date	: 10/10/2018
-- Description		: Add include FK in BLT_TrxOpenLock


-------------------- PENTING UNTUK SERVER ADIRA !!! --------------------
-- Modified By		: Rini Handini
-- Modified date	: 08/01/2019
-- Description		: Tambah dengan versi 15/01/2018 - Cek FK Utama GE Harus Retur
-------------------- PENTING UNTUK SERVER ADIRA !!! --------------------


-- Modified By		: Peter
-- Modified date	: 19/03/2019
-- Description		: Add exclude FK dengan KodeBarang in MasterPilihan.Grup like 'KuponDiskon%'

-- Modified By		: Rini Handini
-- Modified date	: 01/04/2019
-- Description		: Add exclude FK dengan KodeBarang in MasterPilihan.Grup like 'KuponDiskon%' or In BLT_TrxOpenLock

-- Modified By		: Rini Handini
-- Modified date	: 14/08/2019
-- Description		: Add exclude FK in CC_PromoKuponDiskon

-- Modified By		: Rini Handini
-- Modified date	: 07/11/2019
-- Description		: Add exclude FK in TrxBLTFaktur9
-- =============================================

ALTER PROCEDURE [dbo].[SAP_PGetListFakturCetakByKodeStoreForRetur]
	@KodeStore char(2),
	@NoFaktur varchar(50),
	@TglPilih datetime,
	@Retur char(1)
AS

if(@Retur = 1)
Begin


IF @TglPilih is null 
begin

  SELECT * FROM TrxFaktur
  WHERE 
  (
  JumlahPrint >0 and dbo.FReturAll(NoFaktur)=0) and NoFaktur like coalesce(@NoFaktur,'%%') 
  and dbo.getonlydate(Tanggal) = dbo.getonlydate(getdate())
  and @NoFaktur not in (select NoFaktur from TrxVoidPenjualan)
  and @NoFaktur not in (select NoFaktur from TrxReturPenjualan)
  and @NoFaktur not in (select NoFaktur from ES_TrxKlaimApprovalDiscDetail) -- add by Yongky 22 Maret 2013
  and @NoFaktur not in (select NoFakturHEPC from MB_TrxFakturHEPC) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFakturPendaftaran from CL_TrxRegisterKelas) -- add by Yongky 22 Agustus 2013
  and ((@NoFaktur not in (select NoFaktur from TrxBLT) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT2) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur2) -- add by Rini 01 April 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT3) -- add by Rini 17 September 2016
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur3) -- add by Rini 29 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT4) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT5) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur5) -- add by Rini 19 Mei 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT6) -- add by Yongky 30 Juli 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur6) -- add by Rini 26 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT7) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT8) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT9) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur9) -- add by Rini 07 November 2019
  and @NoFaktur not in (select NoFaktur from TrxBLT10) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT11) -- add by Rini 03 Oktober 2018
  and @NoFaktur not in (select NoFaktur from TrxBLT12) -- add by Rini 17 Juni 2017
  and @NoFaktur not in (select NoFaktur from TrxBLTHistory) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFakturHistory) -- add by Rini 19 Mei 2014
  ) or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)) -- add by Rini 10 Oktober 2018
  and @NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail) -- add by Rini 21 Februari 2014
  and @NoFaktur not in (select NoFaktur from KHAE_TrxGamesArcadeDetail) -- add by Rini 26 Juni 2015
  and @NoFaktur not in (select NoFaktur from KHAE_TrxPromoDetail) -- add by Rini 21 Mei 2018
  and @NoFaktur not in (select NoFaktur from CC_PromoKuponDiskon) -- add by Rini 14 Agustus 2019
--  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur where statusproses <> 0)
  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur)
  and ((@NoFaktur not in (select NoFaktur from TrxPengajuanVoidPenjualan))
		or 
		(@NoFaktur in (select NoFaktur from TrxBatalPengajuanVoid))
		)
  and @NoFaktur not in (select NoFaktur from PR_TrxFormTradeIn where StatusBatal is null) -- add by Abednego 11 Sept 2017
  and (@NoFaktur not in (
		select distinct NoFaktur from TrxFakturDetail 
		where KodeBarang in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%')
		and NoFaktur=@NoFaktur
		) -- add Peter 19/03/2019
	or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)
	) -- add Rini 01/04/2019
	
  -------------------- PENTING UNTUK SERVER ADIRA !!! --------------------	
  --and (case when NoFaktur not in (select nofakturins from ad_trxfakturprosesinsurance) then 1 -- add Rini 08/01/2019
		--else (select isnull((select count(NoFakturIns) 
		--	from ad_trxfakturprosesinsurance a
		--	where a.NoFaktur in (select NoFaktur from [192.168.9.28].hartono.dbo.trxreturpenjualan 
		--						UNION 
		--						select NoFaktur from [192.168.9.27].hartono.dbo.trxreturpenjualan where Tanggal > '20180102'
		--						)
		--	and a.NoFakturIns = TrxFaktur.NoFaktur
		--	), 0))
		--end
		--) >= 1
  order by tanggal desc
end else
begin
  SELECT * FROM TrxFaktur
  WHERE 
  (
  JumlahPrint >0 and dbo.FReturAll(NoFaktur)=0) and NoFaktur like coalesce(@NoFaktur,'%%') 
  and dbo.getonlydate(Tanggal) = @TglPilih
--  and Tanggal < dbo.getonlydate(getdate())
  and @NoFaktur not in (select NoFaktur from TrxVoidPenjualan)
  and @NoFaktur not in (select NoFaktur from TrxReturPenjualan)
  and @NoFaktur not in (select NoFaktur from ES_TrxKlaimApprovalDiscDetail) -- add by Yongky 22 Maret 2013
--  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur where statusproses <> 0)
  and @NoFaktur not in (select NoFakturHEPC from MB_TrxFakturHEPC) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFakturPendaftaran from CL_TrxRegisterKelas) -- add by Yongky 22 Agustus 2013
  and ((@NoFaktur not in (select NoFaktur from TrxBLT) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT2) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur2) -- add by Rini 01 April 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT3) -- add by Rini 17 September 2016
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur3) -- add by Rini 29 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT4) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT5) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur5) -- add by Rini 19 Mei 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT6) -- add by Yongky 30 Juli 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur6) -- add by Rini 26 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT7) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT8) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT9) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur9) -- add by Rini 07 November 2019
  and @NoFaktur not in (select NoFaktur from TrxBLT10) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT11) -- add by Rini 03 Oktober 2018
  and @NoFaktur not in (select NoFaktur from TrxBLT12) -- add by Rini 17 Juni 2017
  and @NoFaktur not in (select NoFaktur from TrxBLTHistory) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFakturHistory) -- add by Rini 19 Mei 2014
  ) or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)) -- add by Rini 10 Oktober 2018
  and @NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail) -- add by Rini 21 Februari 2014
  and @NoFaktur not in (select NoFaktur from KHAE_TrxGamesArcadeDetail) -- add by Rini 26 Juni 2015
  and @NoFaktur not in (select NoFaktur from KHAE_TrxPromoDetail) -- add by Rini 21 Mei 2018
  and @NoFaktur not in (select NoFaktur from CC_PromoKuponDiskon) -- add by Rini 14 Agustus 2019
  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur)
  and ((@NoFaktur not in (select NoFaktur from TrxPengajuanVoidPenjualan))
		or 
		(@NoFaktur in (select NoFaktur from TrxBatalPengajuanVoid))
		)
  and @NoFaktur not in (select NoFaktur from PR_TrxFormTradeIn where StatusBatal is null) -- add by Abednego 11 Sept 2017
  and (@NoFaktur not in (
		select distinct NoFaktur from TrxFakturDetail 
		where KodeBarang in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%')
		and NoFaktur=@NoFaktur
		) -- add Peter 19/03/2019
	or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)
	) -- add Rini 01/04/2019
	
  -------------------- PENTING UNTUK SERVER ADIRA !!! --------------------	
  --and (case when NoFaktur not in (select nofakturins from ad_trxfakturprosesinsurance) then 1 -- add Rini 08/01/2019
		--else (select isnull((select count(NoFakturIns) 
		--	from ad_trxfakturprosesinsurance a
		--	where a.NoFaktur in (select NoFaktur from [192.168.9.28].hartono.dbo.trxreturpenjualan 
		--						UNION 
		--						select NoFaktur from [192.168.9.27].hartono.dbo.trxreturpenjualan where Tanggal > '20180102'
		--						)
		--	and a.NoFakturIns = TrxFaktur.NoFaktur
		--	), 0))
		--end
		--) >= 1
  order by tanggal desc
end

End Else

if(@Retur = 0)
Begin


IF @TglPilih is null 
begin

  SELECT * FROM TrxFaktur
  WHERE 
  (
  JumlahPrint >0 and dbo.FReturAll(NoFaktur)=0) and NoFaktur like coalesce(@NoFaktur,'%%') 
  and dbo.getonlydate(Tanggal) < dbo.getonlydate(getdate())
  and @NoFaktur not in (select NoFaktur from TrxVoidPenjualan)
  and @NoFaktur not in (select NoFaktur from TrxReturPenjualan)
  and @NoFaktur not in (select NoFaktur from ES_TrxKlaimApprovalDiscDetail) -- add by Yongky 22 Maret 2013
  and @NoFaktur not in (select NoFakturHEPC from MB_TrxFakturHEPC) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFakturPendaftaran from CL_TrxRegisterKelas) -- add by Yongky 22 Agustus 2013
  and ((@NoFaktur not in (select NoFaktur from TrxBLT) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT2) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur2) -- add by Rini 01 April 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT3) -- add by Rini 17 September 2016
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur3) -- add by Rini 29 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT4) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT5) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur5) -- add by Rini 19 Mei 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT6) -- add by Yongky 30 Juli 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur6) -- add by Rini 26 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT7) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT8) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT9) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur9) -- add by Rini 07 November 2019
  and @NoFaktur not in (select NoFaktur from TrxBLT10) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT11) -- add by Rini 03 Oktober 2018
  and @NoFaktur not in (select NoFaktur from TrxBLT12) -- add by Rini 17 Juni 2017
  and @NoFaktur not in (select NoFaktur from TrxBLTHistory) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFakturHistory) -- add by Rini 19 Mei 2014
  ) or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)) -- add by Rini 10 Oktober 2018
  and @NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail) -- add by Rini 21 Februari 2014
  and @NoFaktur not in (select NoFaktur from KHAE_TrxGamesArcadeDetail) -- add by Rini 26 Juni 2015
  and @NoFaktur not in (select NoFaktur from KHAE_TrxPromoDetail) -- add by Rini 21 Mei 2018
  and @NoFaktur not in (select NoFaktur from CC_PromoKuponDiskon) -- add by Rini 14 Agustus 2019
--  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur where statusproses <> 0)
  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur)
  and ((@NoFaktur not in (select NoFaktur from TrxPengajuanVoidPenjualan))
		or 
		(@NoFaktur in (select NoFaktur from TrxBatalPengajuanVoid))
		)
  and @NoFaktur not in (select NoFaktur from PR_TrxFormTradeIn where StatusBatal is null) -- add by Abednego 11 Sept 2017
  and (@NoFaktur not in (
		select distinct NoFaktur from TrxFakturDetail 
		where KodeBarang in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%')
		and NoFaktur=@NoFaktur
		) -- add Peter 19/03/2019  
	or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)
	) -- add Rini 01/04/2019

  -------------------- PENTING UNTUK SERVER ADIRA !!! --------------------	
  --and (case when NoFaktur not in (select nofakturins from ad_trxfakturprosesinsurance) then 1 -- add Rini 08/01/2019
		--else (select isnull((select count(NoFakturIns) 
		--	from ad_trxfakturprosesinsurance a
		--	where a.NoFaktur in (select NoFaktur from [192.168.9.28].hartono.dbo.trxreturpenjualan 
		--						UNION 
		--						select NoFaktur from [192.168.9.27].hartono.dbo.trxreturpenjualan where Tanggal > '20180102'
		--						)
		--	and a.NoFakturIns = TrxFaktur.NoFaktur
		--	), 0))
		--end
		--) >= 1
  order by tanggal desc
end else
begin
  SELECT * FROM TrxFaktur
  WHERE 
  (
  JumlahPrint >0 and dbo.FReturAll(NoFaktur)=0) and NoFaktur like coalesce(@NoFaktur,'%%') 
  and dbo.getonlydate(Tanggal) < @TglPilih
 
  and @NoFaktur not in (select NoFaktur from TrxVoidPenjualan)
  and @NoFaktur not in (select NoFaktur from TrxReturPenjualan)
  and @NoFaktur not in (select NoFaktur from ES_TrxKlaimApprovalDiscDetail) -- add by Yongky 22 Maret 2013
--  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur where statusproses <> 0)
  and @NoFaktur not in (select NoFakturHEPC from MB_TrxFakturHEPC) -- add by Yongky 22 Agustus 2013
  and @NoFaktur not in (select NoFakturPendaftaran from CL_TrxRegisterKelas) -- add by Yongky 22 Agustus 2013
  and ((@NoFaktur not in (select NoFaktur from TrxBLT) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT2) -- add by Rini 22 November 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur2) -- add by Rini 01 April 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT3) -- add by Rini 17 September 2016
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur3) -- add by Rini 29 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT4) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT5) -- add by Rini 18 Oktober 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur5) -- add by Rini 19 Mei 2014
  and @NoFaktur not in (select NoFaktur from TrxBLT6) -- add by Yongky 30 Juli 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur6) -- add by Rini 26 Mei 2017
  and @NoFaktur not in (select NoFaktur from TrxBLT7) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT8) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLT9) -- add by Yongky 26 September 2013
  and @NoFaktur not in (select NoFaktur from TrxBLTFaktur9) -- add by Rini 07 November 2019
  and @NoFaktur not in (select NoFaktur from TrxBLT10) -- add by Rini 1 Juli 2015
  and @NoFaktur not in (select NoFaktur from TrxBLT11) -- add by Rini 03 Oktober 2018
  and @NoFaktur not in (select NoFaktur from TrxBLT12) -- add by Rini 17 Juni 2017
  and @NoFaktur not in (select NoFaktur from TrxBLTHistory) -- add by Yongky 22 Agustus 2013
  ) or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)) -- add by Rini 10 Oktober 2018
  and @NoFaktur not in (select NoFaktur from TrxBLTFakturHistory) -- add by Rini 19 Mei 2014
  and @NoFaktur not in (select NoFaktur from WF_TrxPromoWFDetail) -- add by Rini 21 Februari 2014
  and @NoFaktur not in (select NoFaktur from KHAE_TrxGamesArcadeDetail) -- add by Rini 26 Juni 2015
  and @NoFaktur not in (select NoFaktur from KHAE_TrxPromoDetail) -- add by Rini 21 Mei 2018
  and @NoFaktur not in (select NoFaktur from CC_PromoKuponDiskon) -- add by Rini 14 Agustus 2019
  and @NoFaktur not in (select NoFaktur from TrxPengajuanRetur)
  and ((@NoFaktur not in (select NoFaktur from TrxPengajuanVoidPenjualan))
		or 
		(@NoFaktur in (select NoFaktur from TrxBatalPengajuanVoid))
		)
  and @NoFaktur not in (select NoFaktur from PR_TrxFormTradeIn where StatusBatal is null) -- add by Abednego 11 Sept 2017
  and (@NoFaktur not in (
		select distinct NoFaktur from TrxFakturDetail 
		where KodeBarang in (Select Nilai from MasterPilihan where Grup like 'KuponDiskon%')
		and NoFaktur=@NoFaktur
		) -- add Peter 19/03/2019  
	or @NoFaktur in (select NoFaktur from BLT_TrxOpenLock)
	) -- add Rini 01/04/2019

  -------------------- PENTING UNTUK SERVER ADIRA !!! --------------------	
  --and (case when NoFaktur not in (select nofakturins from ad_trxfakturprosesinsurance) then 1 -- add Rini 08/01/2019
		--else (select isnull((select count(NoFakturIns) 
		--	from ad_trxfakturprosesinsurance a
		--	where a.NoFaktur in (select NoFaktur from [192.168.9.28].hartono.dbo.trxreturpenjualan 
		--						UNION 
		--						select NoFaktur from [192.168.9.27].hartono.dbo.trxreturpenjualan where Tanggal > '20180102'
		--						)
		--	and a.NoFakturIns = TrxFaktur.NoFaktur
		--	), 0))
		--end
		--) >= 1
  order by tanggal desc
end

End












GO


select *
from CS_TrxPengajuanCNAdmin a ,CS_TrxApprovalCNAdmin b
where nofaktur='FK-06-K58-12452' and a.NoPengajuan=b.NoPengajuan

select top 10 * from CS_TrxPengajuanCNAdmin where nofaktur ='FK-06-K58-12452'
select top 10 * from CS_TrxApprovalCNAdmin 

select noso, * from TrxFaktur where nofaktur='FK-06-K58-12452'

declare 
	@KodeStore char(2),
	@NoFaktur varchar(50),
	@TglPilih datetime,
	@Retur char(1)

set @KodeStore='01'
set @NoFaktur='FK-06-K58-12452'
set @TglPilih=NULL
set @Retur='1'

  SELECT * FROM TrxFaktur
  WHERE 
  (
  JumlahPrint >0 and dbo.FReturAll(NoFaktur)=0) and NoFaktur like coalesce(@NoFaktur,'%%') 
  --and dbo.getonlydate(Tanggal) = dbo.getonlydate(getdate())
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
  order by tanggal desc

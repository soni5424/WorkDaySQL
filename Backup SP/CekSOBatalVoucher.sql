select a.statusbatal, B.NoVoucher, B.NoSO, B.Tanggal, B.Status, C.StatusTerpakai	
from TrxSO A	
	INNER JOIN [192.168.9.27].Hartono.dbo.MasterPromoDiscountDetailPakai B ON a.noso=b.noso and b.Status=1
	INNER JOIN [192.168.9.27].Hartono.dbo.MasterPromoDiscountDetailVoucher C ON B.NoVoucher=C.NoVoucher
where a.statusbatal=1 and a.tanggal > '20201105'	
	and A.NoSO not in (select distinct NoSO from TrxFaktur)
order by B.Tanggal desc	

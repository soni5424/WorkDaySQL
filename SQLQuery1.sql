select A.KeteranganSO, C.NoFaktur, * from 
	TrxSO A,
	PR_TrxSODetailWithPromo B,
	TrxFaktur C
where kodepromo='100088428-08'
	and a.NoSO=b.noso
	and a.NoSO=c.noso
	
	
select * from PR_MasterPromo where KodePromo='100088428-08'


sap_PGetMasterPromoByKodeBarangKodeStore
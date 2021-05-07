select B.PointRedeem, B1.KodeBarang, C.NoFaktur, C.NoFakturIns, D.KodeBarang, D.PointRedeem, D.Insurance, E.KodeBarang
from 
	TrxFaktur A
	INNER JOIN TrxFakturDetail B ON A.NoFaktur=B.NoFaktur
	INNER JOIN MasterBarangInsurance B1 ON B.PointRedeem=B1.TipeInsurance
	INNER JOIN [192.168.9.14\SQLAdira].Hartono.dbo.AD_TrxFakturProsesInsurance C ON C.NoFaktur=A.NoFaktur
	INNER JOIN [192.168.9.14\SQLAdira].Hartono.dbo.AD_TrxFakturProsesInsuranceDetail D ON C.NoFakturIns=D.NoFakturIns
	INNER JOIN [192.168.9.14\SQLAdira].Hartono.dbo.TrxFakturDetail E ON E.NoFaktur=C.NoFakturIns
where 
	A.Tanggal > '20201102'
	--AND B1.KodeBarang <> D.Insurance




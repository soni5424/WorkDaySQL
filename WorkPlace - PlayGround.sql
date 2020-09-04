
select count(*) from WHS_MasterDOSN
select count(*) from WHS_MasterSN

EXEC DT_PGetBarangByNoFK 
SELECT DISTINCT RTRIM(KodeBarang) AS KodeBarang 
	FROM TrxFakturDetail
    WHERE NoFaktur=''
		AND KodeBarang NOT LIKE '%Transport%'

	SELECT DISTINCT RTRIM(A.KodeBarang) AS KodeBarang, C.KodeStoreDepo AS SiteDelivery, B.NoSO
	FROM TrxFakturDetail A
		INNER JOIN TrxFaktur B ON A.NoFaktur=B.NoFaktur
		INNER JOIN TrxSOKirim C ON B.NoSO=C.NoSO
    WHERE A.NoFaktur='FK-01-K52-00062'
		AND A.KodeBarang NOT LIKE '%Transport%'

select * from TrxSoKirim where NoSO='02A-01-S54-00008'

delete WHS_MasterDOSN
delete WHS_MasterSN

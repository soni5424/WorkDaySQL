-- ANEH bisa klaim 3X, FK toko cuman 1X
--select TotalHarga, * from TrxFaktur where NoFaktur in ('FK-25-B33-00006')
select TotalHarga, KeteranganSO, NoSOSAP_SALESDOCUMENT, * from TrxFaktur where NamaPembeli = 'ANDRY GUNAWAN'
and NoFaktur not in (select NoFaktur from TrxReturPenjualan) order by Tanggal desc  

-- ANEH bisa klaim 2X, FK toko cuman 1X
--select TotalHarga, * from TrxFaktur where NoFaktur in ('FK-25-B29-00006')
select TotalHarga, KeteranganSO, NoSOSAP_SALESDOCUMENT, * from TrxFaktur where NamaPembeli = 'DRA. NOVINI LINDAKIRANA' 
and NoFaktur not in (select NoFaktur from TrxReturPenjualan) order by Tanggal desc  


-- ANEH bisa klaim 2X, FK toko cuman 1X
--select TotalHarga, * from TrxFaktur where NoFaktur in ('FK-25-B90-00013')
select TotalHarga, KeteranganSO, NoSOSAP_SALESDOCUMENT, * from TrxFaktur where NamaPembeli = 'THAN THAN ANGELINE' 
and NoFaktur not in (select NoFaktur from TrxReturPenjualan) order by Tanggal desc  

-- ANEH bisa klaim 2X, FK toko cuman 1X
--select TotalHarga, * from TrxFaktur where NoFaktur in ('FK-25-B67-00008')
select TotalHarga, KeteranganSO, NoSOSAP_SALESDOCUMENT, * from TrxFaktur where NamaPembeli = 'ROHMANI' 
and NoFaktur not in (select NoFaktur from TrxReturPenjualan) order by Tanggal desc  

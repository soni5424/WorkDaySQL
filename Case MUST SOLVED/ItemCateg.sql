select  distinct a.noso,a.tanggal--,a.nososap_salesdocument,b.item_categ, b.ITM_NUMBER, b.KodeBarang--, c.SiteAsal1, c.SiteTujuan1
from trxso a,trxsodetail b--, SAP_TrxSOSTO c
where b.noso=a.noso and a.tanggal>'20200729' and item_Categ like '%17'
	and a.noso in (select a.noso from trxso a,trxsokirim b
					where b.noso=a.noso and b.kodestoredepo=b.kodestorestock and a.tanggal>'20200729')
	--and c.SiteAsal1=c.SiteTujuan1
	--and a.noso=c.NoSO
order by tanggal asc


declare @NoSO	varchar(50)
set @NoSO = '02B-07-A33-00036'

select * from TrxSO where NoSO=@NoSO
select ITM_NUMBER, ITEM_CATEG, * from TrxSODetail where NoSO=@NoSO order by ITM_NUMBER
select * from SAP_TrxSOSTO where NoSO=@NoSO order by Itm_Number
select * from TrxSOKirim where NoSO=@NoSO

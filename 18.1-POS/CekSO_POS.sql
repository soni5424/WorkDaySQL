


select top 50 noso from TrxSO 
where kodeworkstation like 'A%' 
order by tanggal desc

select ITM_NUMBER, * from TrxSODetail 
where noso in (
	select top 50 noso from TrxSO 
	where kodeworkstation like 'A%' 
	order by tanggal desc)
	and kodebarang in ()
order by noso, ITM_NUMBER

select * from SAP_ARTICLE where 
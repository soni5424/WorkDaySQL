select top 10 * from TrxSO 
where KodeWorkStation like '%A%'
	and TotalHarga = 12436000
	--and dbo.getonlydate(Tanggal) = dbo.getonlydate(getdate())
order by Tanggal desc

select itm_number, ITEM_CATEG, * from TrxSODetail where NoSO ='02A-07-A67-00121' order by ITM_NUMBER asc
select itm_number, ITEM_CATEG, * from TrxSODetail where NoSO ='02A-07-A91-00111' order by ITM_NUMBER asc

select  * from SAP_TrxSOSTO where NoSO ='02A-07-A67-00121'
select  * from SAP_TrxSOSTO where NoSO ='02A-07-A91-00111'



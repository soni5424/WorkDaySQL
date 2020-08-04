declare @NoSO varchar(20)
--set @NoSO = '02B-08-N14-00421'
set @NoSO = '02A-08-X26-00003'
--set @NoSO = '02A-08-X26-00011'

select * from  TrxSO where nososap_salesdocument=@NoSO or NoSO=@NoSO
select ITEM_CATEG,* from  TrxSODetail where NoSO=@NoSO or NoSO=@NoSO
select * from SAP_TrxSOSTO where noso=@NoSO
--select * from SA_LogSaveSO where response like '%'+@NoSO+'%' or request like '%'+@NoSO+'%'


--select top 10 * from SA_LogSaveSO where Tanggal > '20200714 '
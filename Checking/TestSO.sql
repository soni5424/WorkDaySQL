use Hartono
declare @NoSO varchar(50)
set @NoSO='02A-07-A46-00138'

select nososap_salesdocument, * from TrxSO where noso=@NoSO
select nososap_salesdocument, * from TrxFaktur where noso=@NoSO
select * from TrxSODetail where noso=@NoSO
select * from PR_TrxSODetailWithPromo where noso=@NoSO
select * from SAP_TrxSOSTO where noso=@NoSO
-- ===================LOG========================== --
select * from SAP_LogSOSTO where noso=@NoSO
select * from SAP_LogReservationCreate where noso=@NoSO order by tanggal desc
select top 10 * from SAP_LogDelReservation where noso=@NoSO order by tanggal desc 
select * from LOG_RETURN_SAP where NoDocument=@NoSO order by tanggal desc

--select top 100 * from [dbo].[Log_TableLock] order by tanggal desc --where dbo.getonlydate(Tanggal)='20191219'
-- ===================LOG========================== --
exec HpsIns_PGetSOTrxInOutByNoSOIns @NoSO
exec SD_PGetPrintOutSO @NoSO
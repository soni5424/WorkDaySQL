select distinct TableName, Client_Net_Address, WaitTime, Tanggal as Tanggal from Log_TableLock 
where waittime > 5000 -- 5 detik
	and dbo.getonlydate(tanggal) > dbo.getonlydate(getdate()-1)
order by tanggal desc

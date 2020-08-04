select * from Log_TableLock 
where waittime > 5000 -- 5 detik
	and tanggal > '20200720'	
order by tanggal desc
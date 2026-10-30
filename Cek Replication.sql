-- Cek undistcom banyak/ribuan

-- Use DB Distribution 9.27
use distribution
PCekPendingReplicationdetail


-- Use DB Hartono 9.27
use Hartono
exec [192.168.14.18\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.11.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.13.2\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.16.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.17.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.18.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.20.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.21.100\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.15.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.22.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [10.50.140.10\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 
exec [192.168.12.1\SQLPOS].distribution.dbo.PCekPendingReplicationdetail
exec [10.50.5.70\SQLPOS].distribution.dbo.PCekPendingReplicationdetail 

select * from hartono.dbo.trxfakturpointmember
where dbo.getonlydate(tanggal) = '20261029'

declare @tglAwal datetime = '20261029',
		@tglAkhir datetime = '20261030'
IF OBJECT_ID('tempdb..#a') IS NOT NULL DROP TABLE #a;
IF OBJECT_ID('tempdb..#b') IS NOT NULL DROP TABLE #b;

--Faktur
select dbo.getonlydate(tanggal) as Tanggal, sum(totalharga) as TotalFaktur
into #a
from trxfaktur
where tanggal >= @tglAwal
and tanggal < @tglAkhir
group by dbo.getonlydate(tanggal)
order by dbo.getonlydate(tanggal)

--Retur
select dbo.getonlydate(tanggal) as Tanggal, sum(totalharga) as TotalRetur
into #b
from trxreturpenjualan
where tanggal >= @tglAwal
and tanggal < @tglAkhir
group by dbo.getonlydate(tanggal)
order by dbo.getonlydate(tanggal)

--Faktur-Retur
select a.Tanggal, a.TotalFaktur- coalesce(b.TotalRetur,0), a.TotalFaktur, coalesce(b.TotalRetur,0)
from #a a left join #b b on a.tanggal = b.tanggal

--select * from TrxReturPenjualan where NoReturPenjualan='RP-17-R02-01471'

--select * from #a  
--select * from #b

---------------------


select tanggal, nofaktur, totalharga
from trxfaktur
where tanggal >= '20261027'
and tanggal < '20261028'
order by nofaktur, tanggal

select A.SubTotalHarga, A.ITM_NUMBER,  * from TrxFakturDetail A where NoFaktur='FK-08-C03-10911' order by A.ITM_NUMBER


select tanggal, NoReturPenjualan, cast(totalharga*-1 as int)
from trxreturpenjualan
where tanggal >= '20260916'
and tanggal < '20260917'
order by noreturpenjualan, tanggal


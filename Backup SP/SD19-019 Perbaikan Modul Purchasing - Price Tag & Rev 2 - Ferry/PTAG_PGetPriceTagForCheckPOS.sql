USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PTAG_PGetPriceTagForCheckPOS]    Script Date: 15/06/2020 21:38:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Modified By		: yongky 
-- Modified Date	: 12/10/2017
-- Description		: Improve performance + OPTION ( RECOMPILE )
-- =============================================


ALTER PROCEDURE [dbo].[PTAG_PGetPriceTagForCheckPOS]
(
  @TanggalPList datetime,
  @TanggalUpload datetime,
  @KodeBarang varchar(20),
  @NamaBarang varchar(20),
  @MerkBarang varchar(50),
  @KodeSubJenis varchar(50),
  @StatusCheck varchar(1),
  @KodeStore varchar(2)

)
AS
declare @site varchar(4)
select @site=sales_off  from masterstore where kodestore=@KodeStore

--select * into #kategoribarang from sap_configmerchandisecategory a 
--left join sap_article b on a.mc=b.matl_group and site=@site

--print '1'
--select distinct matnr,kbert,priceid into #vkp0 from sap_retail_price_vkp0
--where matnr+priceid in (select matnr+max(priceid) as priceid from sap_retail_price_vkp0
----where vfrom <= dbo.getonlydate(getdate())
----and dbo.getonlydate(getdate()) <= vto
--where vfrom <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
--and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= vto
--group by matnr)

--print '2'
--select distinct material,old_mat_no into #article from sap_article
--where DISCNTIN_IDC=0
--and matl_desc like '%' + @NamaBarang + '%'
--and old_mat_no like '%' + @KodeBarang + '%'
--and brand_name like '%' + @MerkBarang + '%'

--print '3'
--select * into #xxx from #vkp0 x, #article y  where x.matnr = y.material

select distinct matnr,kbert,priceid, old_mat_no
into #xxx
from sap_retail_price_vkp0 x
inner join sap_article y on x.matnr = y.material
where y.DISCNTIN_IDC=0
and y.old_mat_no like '%' + @KodeBarang + '%'
and y.matl_desc like '%' + @NamaBarang + '%'
and y.brand_name like '%' + @MerkBarang + '%'
and x.matnr+x.priceid in (select matnr+max(priceid) as priceid from sap_retail_price_vkp0 x1
inner join sap_article y1 on x1.matnr = y1.material
where y1.DISCNTIN_IDC=0
and y1.old_mat_no like '%' + @KodeBarang + '%'
and y1.matl_desc like '%' + @NamaBarang + '%'
and y1.brand_name like '%' + @MerkBarang + '%'
--where vfrom <= dbo.getonlydate(getdate())
--and dbo.getonlydate(getdate()) <= vto
and vfrom <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= vto
group by matnr)

--print '4'
select max(jumlah) as jumlah,jumlahbrgutama,jenisnilai,status,keterangancheck
,kodebarang,kodestore  into #xxx2 from
(select distinct sum(isnull(bb.jumlah,0)) as jumlah,aa.jumlah as jumlahbrgutama,jenisnilai,status,keterangancheck
,aa.kodebarang,cc.kodestore 
from pr_masterpromo xx left join pr_masterpromodetailbarangutama  aa 
on aa.kodepromo=xx.kodepromo left join 
pr_masterpromodetailpotonganharga bb on xx.kodepromo=bb.kodepromo left join
PH_masterpromodetailstore cc on cc.kodepromo=xx.kodepromo
--where xx.tanggalawal <= dbo.getonlydate(getdate())
--and dbo.getonlydate(getdate()) <= xx.tanggalakhir
where xx.tanggalawal <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= xx.tanggalakhir
and statusberhenti=0
and keterangancheck='CIP'
and xx.jumlahpromo=0
and xx.status=''
and cc.kodestore=@KodeStore

and jenisnilai is not null
group by aa.kodepromo,aa.jumlah ,jenisnilai,status,keterangancheck,aa.kodebarang,cc.kodestore
)a

group by jumlahbrgutama,jenisnilai,status,keterangancheck
,kodebarang,kodestore

----select distinct sum(isnull(bb.jumlah,0)) as jumlah,aa.jumlah as jumlahbrgutama,jenisnilai,status,keterangancheck
----,aa.kodebarang,cc.kodestore into #xxx2
----from pr_masterpromo xx left join pr_masterpromodetailbarangutama  aa 
----on aa.kodepromo=xx.kodepromo left join 
----pr_masterpromodetailpotonganharga bb on xx.kodepromo=bb.kodepromo left join
----PH_masterpromodetailstore cc on cc.kodepromo=xx.kodepromo
----where xx.tanggalawal <= dbo.getonlydate(getdate())
----and dbo.getonlydate(getdate()) <= xx.tanggalakhir
----and statusberhenti=0
----and keterangancheck='CIP'
----and xx.jumlahpromo=0
----and xx.status=''
----and cc.kodestore=@KodeStore 
--and aa.kodebarang+CAST(isnull(bb.jumlah,0) AS varchar(20)) in 
--(select xxx.kodebarang+cast(max(cast(isnull(xxxx.jumlah,0) as decimal(18,2))) as varchar(20)) as jumlah 
--from pr_masterpromo xxp left join pr_masterpromodetailbarangutama  xxx 
--on xxx.kodepromo=xxp.kodepromo left join 
--pr_masterpromodetailpotonganharga xxxx on xxp.kodepromo=xxxx.kodepromo 
--left join PH_masterpromodetailstore ccx on ccx.kodepromo=xxp.kodepromo
--where xxp.tanggalawal <= dbo.getonlydate(getdate())
--and dbo.getonlydate(getdate()) <= xxp.tanggalakhir
--and xxp.jumlahpromo=0
--and xxp.status=''
--and ccx.kodestore=@KodeStore
--group by xxx.kodebarang)
--group by aa.jumlah ,jenisnilai,status,keterangancheck,aa.kodebarang,cc.kodestore

--print '5'
select distinct kodebarang into #cicilPL from mkt_masterbarangcicilanreguler 
--where tanggalawal <= dbo.getonlydate(getdate())
--and dbo.getonlydate(getdate()) <= tanggalakhir
where tanggalawal <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= tanggalakhir

--print '6'
select  xb.kodebarang, xc.kodestore, xa.KodePromo 
into #promo
from PR_MasterPromo xa
inner join PR_MasterPromoDetailBarangUtama xb on xa.KodePromo = xb.KodePromo
inner join PH_MasterPromoDetailStore xc on xa.KodePromo = xc.KodePromo
--where xa.TanggalAwal <= dbo.getonlydate(getdate())
--and xa.TanggalAkhir >= dbo.getonlydate(getdate())
where xa.TanggalAwal <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
and xa.TanggalAkhir >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
and xb.KeteranganCheck = 'CIP'
and xb.StatusBerhenti = 0
and xb.KodeBarang like '%' + @KodeBarang + '%'
and xc.KodeStore = @KodeStore
and statusberhenti=0
and xa.jumlahpromo=0
and xa.status=''

SELECT 
  0 as 'Check',
  coalesce(c.StatusCheck,0) as StatusCheck,
  a.TanggalPList,
  a.TanggalUpload,
  a.KodeBarang,
  b.NamaBarang,
  f.keterangan as MerkBarang,
  b.KodeBarangPengganti as KodeSubJenis,
  kbert as HargaDisplay,
  a.BestPrice,
  a.CicilanMember,
  --0 as StatusPromo,
  CASE
  when exists 
	( 
	--select xa.KodePromo 
	--from PR_MasterPromo xa
	--inner join PR_MasterPromoDetailBarangUtama xb on xa.KodePromo = xb.KodePromo
	--inner join PH_MasterPromoDetailStore xc on xa.KodePromo = xc.KodePromo
	----where xa.TanggalAwal <= dbo.getonlydate(getdate())
	----and xa.TanggalAkhir >= dbo.getonlydate(getdate())
	--where xa.TanggalAwal <= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
	--and xa.TanggalAkhir >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
	--and xb.KeteranganCheck = 'CIP'
	--and xb.StatusBerhenti = 0
	--and xb.KodeBarang = a.KodeBarang
	--and xc.KodeStore = a.KodeStore
	--and statusberhenti=0
	--and xa.jumlahpromo=0
	--and xa.status=''

	select KodePromo 
	from #Promo 
	where kodebarang = a.kodebarang
	and kodestore = a.kodestore
	) THEN 1
  else 0
  END StatusPromo,
  a.KodeStore,
CASE 
      WHEN xx2.jenisnilai='IDR' and xx2.jumlahbrgutama=1 THEN kbert - isnull(xx2.jumlah,0)
	  WHEN xx2.jenisnilai='%' and xx2.jumlahbrgutama=1 THEN kbert - (kbert*(isnull(xx2.jumlah,0)/100)	)
      else kbert - 0
   END HargaCoret,
	CASE 
      WHEN ccpl.kodebarang is not null THEN 1
      else  0
   END CicilanPL
into #tempmasterpricetag
FROM MasterPriceTag a
inner join MasterBarang b on a.KodeBarang = b.KodeBarang
inner join MasterPriceTagCheck c on c.KodeBarang = a.KodeBarang and c.KodeStore = a.KodeStore 
inner join MasterMerk f on f.Merk = b.MerkBarang
--left join #kategoribarang g on b.material=g.material
left join #xxx xx on xx.old_mat_no =a.kodebarang
left join #xxx2 xx2 on xx2.kodebarang=a.kodebarang
left join #cicilPL ccpl on ccpl.kodebarang=a.KodeBarang
Where 
     a.TanggalPList = coalesce(@TanggalPList, a.TanggalPList)
and b.KodeBarang like '%' + @KodeBarang + '%'
and b.NamaBarang like '%' + @NamaBarang + '%'
and f.keterangan like '%' + @MerkBarang + '%'
--and   dbo.getonlydate(a.TanggalUpload) = coalesce(@TanggalUpload, dbo.getonlydate(a.TanggalUpload))
and   DATEADD(dd, 0, DATEDIFF(dd, 0, a.TanggalUpload)) = coalesce(@TanggalUpload, DATEADD(dd, 0, DATEDIFF(dd, 0, a.TanggalUpload)))
and   a.KodeStore = @KodeStore

OPTION ( RECOMPILE )

Declare @str varchar(2000)
set @str = ' select  * '
set @str = @str +  ' from #tempmasterpricetag'
set @str = @str +  ' where 1 = 1 '
if (@StatusCheck = '0')
	set @str = @str + ' and StatusCheck = 0 '
if (@StatusCheck = '1')
	set @str = @str + ' and StatusCheck = 1 '
if (@KodeBarang <> '')
	set @str = @str + ' and KodeBarang = ' + '''' + @KodeBarang + ''''
if (@MerkBarang <> '')
	set @str = @str + ' and MerkBarang  = ' + '''' + @MerkBarang+ ''''
if (@KodeSubJenis <> '')
	set @str = @str + ' and KodeSubJenis = ' + '''' + @KodeSubJenis+ ''''


--print (@str)
exec (@str)

DROP TABLE #tempmasterpricetag








GO


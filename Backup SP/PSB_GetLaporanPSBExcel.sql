USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PSB_GetLaporanPSBExcel]    Script Date: 16/11/2020 11.00.03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PSB_GetLaporanPSBExcel]
@NamaStore varchar(50),
@KodeSetup varchar(50),
@NamaArea varchar(50),
@Date1 varchar(10),
@Date2 varchar(10)
as


select txd.PSBNo,CONVERT(varchar, date, 103)+' '+CONVERT(varchar, date, 108) date,NamaStore,tx.KodeSetup,NamaArea,Area,Target,
(count(*) - (
select count(*) from PSB_TrxPSBDetail txdd where txdd.PSBNo = txd.PSBNo
and txdd.Target=txd.Target and txdd.UserIDStatus IS NOT NULL
and txdd.VoidRequest=1
and txdd.Status = 'VOID'
and m.NamaStore Like '%'+@NamaStore+'%'
and tx.KodeSetup like '%'+@KodeSetup+'%'
and a.NamaArea like '%'+@NamaArea+'%'
and convert(datetime,(convert(varchar(10),Date,103)),103)
between convert(datetime,(convert(varchar(10),@Date1,103)),103) and convert(datetime,(convert(varchar(10),@Date2,103)),103)

)) TotalTemuan,
(count(*) - 
 (
select count(*) from PSB_TrxPSBDetail txdd where txdd.PSBNo = txd.PSBNo
and txdd.Target=txd.Target and txdd.UserIDStatus IS NOT NULL
and txdd.VoidRequest=1
and txdd.Status = 'VOID'
and m.NamaStore Like '%'+@NamaStore+'%'
and tx.KodeSetup like '%'+@KodeSetup+'%'
and a.NamaArea like '%'+@NamaArea+'%'
and convert(datetime,(convert(varchar(10),Date,103)),103)
between convert(datetime,(convert(varchar(10),@Date1,103)),103) and convert(datetime,(convert(varchar(10),@Date2,103)),103)

)
-(
select count(*) from PSB_TrxPSBDetail txdd where txdd.PSBNo = txd.PSBNo
and txdd.Target=txd.Target and txdd.UserIDStatus IS NOT NULL
and txdd.Status = 'FAIL'
and m.NamaStore Like '%'+@NamaStore+'%'
and tx.KodeSetup like '%'+@KodeSetup+'%'
and a.NamaArea like '%'+@NamaArea+'%'
and convert(datetime,(convert(varchar(10),Date,103)),103)
between convert(datetime,(convert(varchar(10),@Date1,103)),103) and convert(datetime,(convert(varchar(10),@Date2,103)),103)

)) TotalPerbaikan,
(select count(*) from psb_trxpsbdetail txdd join psb_setup s on s.Target=txdd.Target and s.[Checkpoint]=txdd.[CheckPoint] and s.Activity=txdd.Activity
where txdd.PSBNo = txd.PSBNo and txd.Target=txdd.Target and txdd.UserIDStatus is not null and 
txdd.VoidRequest =0 and
(
txdd.Status='PASS' or txdd.status='FAIL') and s.corrective='0'
) TidakBisaDiperbaiki
 from PSB_TrxPSB tx join PSB_TrxPSBDetail txd on txd.PSBNo=tx.PSBNo
join PSB_MasterStore m on m.KodeStore=tx.Site
join PSB_MasterArea a on a.KodeArea=tx.Area
where txd.Target is not null
and txd.UserIDStatus is not null
and m.NamaStore Like '%'+@NamaStore+'%'
and tx.KodeSetup like '%'+@KodeSetup+'%'
and a.NamaArea like '%'+@NamaArea+'%'
and convert(datetime,(convert(varchar(10),Date,103)),103)
between convert(datetime,(convert(varchar(10),@Date1,103)),103) and convert(datetime,(convert(varchar(10),@Date2,103)),103)
group by Target,txd.PSBNo,Date,NamaStore,tx.Site,tx.KodeSetup,NamaArea,tx.Area,tx.PSBNo
order by tx.Site ASC, tx.KodeSetup ASC, tx.Area ASC, tx.PSBNo ASC
GO


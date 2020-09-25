USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PGetOpnameGudangLain]    Script Date: 07/08/2020 14.02.26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author			: Soni Gunawan
-- Modified date	: 1.12.15
-- Description		: 
-- =============================================

ALTER PROCEDURE [dbo].[PGetOpnameGudangLain]
    @PID varchar(50)
as
BEGIN
	SELECT * INTO #ListPID FROM (
		SELECT @PID As PID, 1 AS Parent
		UNION
		SELECT PID2 As PID, 0 As Parent FROM PIDJoin WHERE PID1=@PID
	) ABC

	SELECT * INTO #PIDStock FROM PidStock WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDStock SET PID=@PID 
	SELECT * INTO #PIDGoodMovement FROM PIDGoodMovement WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDGoodMovement SET PID=@PID
		


	select * into #Temp from 
	(
	--kuning
	select yy.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 

	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(
	--	SELECT a.PID,a.SN,a.batch,cumqty as qty
	--	  FROM PIDStock a 
	--	where a.pid=@PID
	--	and a.PID+a.SN+a.batch not in (
	--	select b.PID+b.SN+b.batch from PIDGoodMovement b
	--	where DC='H' and b.pid=@PID
	--	)
	--	union
	--	select b.PID,b.SN,b.batch,1 as qty from PIDGoodMovement b
	--	where DC='S' and b.pid=@PID

			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			  FROM #PIDStock a 
			left join 
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,EAN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,EAN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS QTY ,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			  FROM #PIDStock a 
			left join 
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,SN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,SN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z001' or sernp='Z002'  or sernp='ZVHE'
	) xx left join 
	(select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE') and hh.pid=hy.pid and hy.pid=@PID
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid=@PID
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE XX.SERNP IS NOT NULL
	--kuning
	union 

	--BIRU
	select yy.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 

	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(


			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			  FROM #PIDStock a 
			left join 
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,EAN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,EAN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS QTY,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			  FROM #PIDStock a 
			left join 
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,SN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,SN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE'
	) xx right join 
	(
	select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE') and hh.pid=hy.pid and hy.pid=@PID
	union all
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid=@PID
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE xx.sernp IS NOT NULL
	--BIRU
	UNION ALL


	--MERAH
	select yy.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 

	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(


			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			  FROM #PIDStock a 
			left join 
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,EAN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,EAN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS QTY,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			  FROM #PIDStock a 
			left join 
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,SN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,SN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE'
	) xx right join 
	(
	select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE') and hh.pid=hy.pid and hy.pid=@PID
	union all
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid=@PID
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE xx.sernp IS NULL
	--MERAH
	UNION ALL

	--HIJAU
	select yy.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 

	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(
	--	SELECT a.PID,a.SN,a.batch,cumqty as qty
	--	  FROM PIDStock a 
	--	where a.pid=@PID
	--	and a.PID+a.SN+a.batch not in (
	--	select b.PID+b.SN+b.batch from PIDGoodMovement b
	--	where DC='H' and b.pid=@PID
	--	)
	--	union
	--	select b.PID,b.SN,b.batch,1 as qty from PIDGoodMovement b
	--	where DC='S' and b.pid=@PID

			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			  FROM #PIDStock a 
			left join 
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,EAN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,EAN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS QTY ,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			  FROM #PIDStock a 
			left join 
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid=@PID group by PID,SN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid=@PID group by PID,SN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid=@PID
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid=@PID
		where sernp='Z001' or sernp='Z002'  or sernp='ZVHE'
	) xx left join 
	(select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE') and hh.pid=hy.pid and hy.pid=@PID
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid=@PID
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE XX.SERNP IS  NULL
	--HIJAU
	) xxxxxx



	select distinct jklm.SN,jklm.article,jklm.batch,sloc from 
	(select j.* from (select a.*,b.sloc from #temp a left join (select distinct sloc,pid FROM #PIDStock where pid='100000094') b on b.pid=a.pid )
	 i left join  PIDSNEsto j on i.snfisik=j.sn and j.pid=i.pid
	where i.sloc<>j.sloc and j.pid=@PID )
	 jklm left join 
	#Temp xxxx on jklm.sn=xxxx.sn left join 
	(
	select xxx.StockType,xxx.article,xxx.batch,sum(qty) as Unrestricted from
	#Temp xxx where xxx.StockType='01'
	group by xxx.StockType,xxx.article,xxx.batch
	) yyyy on xxxx.article=yyyy.article and xxxx.batch=yyyy.batch
	left join 
	(
	select xxx.StockType,xxx.article,xxx.batch,sum(qty) as Blocked from
	#Temp xxx where StockType='07'
	group by xxx.StockType,xxx.article,xxx.batch
	) zzzz on xxxx.article=zzzz.article and xxxx.batch=zzzz.batch

	drop table #Temp
END
GO


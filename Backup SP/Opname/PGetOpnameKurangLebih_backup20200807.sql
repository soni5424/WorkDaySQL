USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PGetOpnameKurangLebih]    Script Date: 07/08/2020 14.01.33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: |Soni Gunawan|
-- Create date: |3.7.17|
-- Description: |+ Z005, Z006, Z007|
-- Project: |MM16-001|
-- =============================================

ALTER PROCEDURE [dbo].[PGetOpnameKurangLebih]
    @PID varchar(50)
as
BEGIN
	declare	@SN		varchar(50),
			@Qty	int

	SELECT * INTO #ListPID FROM (
		SELECT @PID As PID, 1 AS Parent
		UNION
		SELECT PID2 As PID, 0 As Parent FROM PIDJoin WHERE PID1=@PID
	) ABC

	SELECT * INTO #PIDStock FROM PidStock WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDStock SET PID=@PID 
	SELECT * INTO #PIDGoodMovement FROM PIDGoodMovement WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDGoodMovement SET PID=@PID
	SELECT DISTINCT PID, SN, 0 AS Qty INTO #Temp1 FROM 
	(
		SELECT PID, SN FROM PIDScan WHERE PID=@PID
		UNION
		SELECT PID, SN FROM #PIDGoodMovement WHERE DC='D' AND PID=@PID
		UNION 
		SELECT PID, SN FROM #PIDGoodMovement WHERE DC='C' AND PID=@PID
	) X

	SELECT 
		A.PID, 
		A.SN, 
		A.Qty+COALESCE(B.Qty,0)+COALESCE(C.Qty,0)-COALESCE(D.Qty,0) AS Temp2Qty
	INTO 
		#Temp2
	FROM
		#Temp1 A
		LEFT JOIN (	SELECT  PID, SN, COUNT(SN) AS Qty FROM PIDScan m
					WHERE PID=@PID
					GROUP BY PID, SN) AS B ON	B.PID=A.PID AND B.SN=A.SN
		LEFT JOIN (	SELECT PID, EAN AS SN, SUM(COALESCE(Qty,0)) AS Qty FROM #PIDGoodMovement
					WHERE PID=@PID AND DC='D' AND SN=''
					GROUP BY PID, EAN
					UNION
					--SELECT PID, SN, SUM(COALESCE(Qty,0)) AS Qty FROM #PIDGoodMovement --27/05/2019
					SELECT PID, SN, 1 AS Qty FROM #PIDGoodMovement --27/05/2019
					WHERE PID=@PID AND DC='D' AND SN NOT LIKE ''
					GROUP BY PID, SN )AS C ON C.PID=A.PID AND C.SN=A.SN -- END LEFT JOIN
		LEFT JOIN ( SELECT PID, EAN AS SN, SUM(COALESCE(Qty,0)) As Qty FROM #PIDGoodMovement
					WHERE PID=@PID AND DC='C' AND SN=''
					GROUP BY PID, EAN
					UNION
					--SELECT PID, SN, SUM(COALESCE(Qty,0)) As Qty FROM #PIDGoodMovement --27/05/2019
					SELECT PID, SN, 1 As Qty FROM #PIDGoodMovement --27/05/2019
					WHERE PID=@PID AND DC='C'  AND SN NOT LIKE ''
					GROUP BY PID, SN) AS D ON D.PID=A.PID AND D.SN=A.SN -- END LEFT JOIN

	CREATE TABLE #PIDScan(PID Varchar(50) COLLATE DATABASE_DEFAULT NULL, SN varchar(50) COLLATE DATABASE_DEFAULT NULL)
		
	declare	@cnt	int

	DECLARE PID_cursor CURSOR FOR
	SELECT PID, SN, Temp2Qty FROM #Temp2

	OPEN PID_cursor
	FETCH NEXT FROM PID_cursor into @PID, @SN, @Qty

	WHILE @@FETCH_STATUS = 0
	   BEGIN
		  IF (ABS(@Qty) > 0) -- 06/09/2017 A=0,B=0,C=0,D=3
		  BEGIN
			SET @cnt = 0

			WHILE @cnt < ABS(@Qty) -- 06/09/2017 A=0,B=0,C=0,D=3
			BEGIN
				INSERT INTO #PIDScan values (@PID, @SN)
				SET @cnt = @cnt + 1
			END		
		  END 
		  FETCH NEXT FROM PID_cursor into @PID, @SN, @Qty
	      
	   END;
	CLOSE PID_cursor
	DEALLOCATE PID_cursor

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

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty --yahya
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
		where sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx left join 
	(select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid=@PID
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
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

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty --yahya
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
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx right join 
	(
	select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid=@PID
	union all
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
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

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
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
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx right join 
	(
	select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid=@PID
	union all
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
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

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
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
		where sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx left join 
	(select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid=@PID
	group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid=@PID
	union
	select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid=@PID
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE XX.SERNP IS  NULL
	--HIJAU
	) xxxxxx



	
	select distinct aa.SN,COALESCE(bb.article,'') as article,Unrestricted,qtyfisik,'' as keterangan from 
	(
	select COALESCE(SNfisik,'') as SN, COALESCE(article,'') as article, COALESCE(batch,'') as batch ,
	COALESCE(sum(qty),0) as Unrestricted, sum(qtyfisik) as qtyfisik ,'' as keterangan from  #temp
	where sernp is null and (snfisik is null
	or sn is null
	or sn =''
	or snfisik ='')
	group by article,batch,SNfisik
	union all
	select * from
	(
	select COALESCE(SN,'') as SN, COALESCE(article,'') as article, COALESCE(batch,'') as batch ,
	COALESCE(sum(qty),0) as Unrestricted, sum(qtyfisik) as qtyfisik ,'' as keterangan from  #temp
	where sernp is not null and (snfisik is null
	or sn is null
	or sn =''
	or snfisik ='')
	group by article,batch,SN
	) fg
	union
	select COALESCE(hh.SN,'') as SN, '' as article, '' as batch ,
	0 as Unrestricted, 1 as qtyfisik ,'' as keterangan from #PIDScan hh 
	left join PIDSNEsto hy on hh.sn=hy.sn
	and hh.pid = hy.pid -- 01.09.2016 request by Yahya
	where hh.pid=@PID and hy.sn is null
	) aa left join (select * from PIDSNEsto where pid=@PID) bb on aa.SN=bb.SN
	where Unrestricted>0 or qtyfisik>0 and aa.SN is not null and aa.SN != '' -- MM15.005.6.B 

	drop table #temp
	drop table #temp1
	drop table #temp2
	drop table #listpid
	drop table #pidscan
	drop table #pidstock
	drop table #pidgoodmovement
END



GO


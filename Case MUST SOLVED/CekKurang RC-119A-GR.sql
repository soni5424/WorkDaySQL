	drop table #temp
	drop table #temp1
	drop table #temp2
	drop table #listpid
	drop table #pidscan
	drop table #pidstock
	drop table #pidgoodmovement


declare @PID varchar(50)
set @PID = '100001226'

	declare	@SN		varchar(50),
			@Qty	int


	SELECT * INTO #ListPID FROM (
		SELECT @PID As PID, 1 AS Parent
		UNION
		SELECT PID2 As PID, 0 As Parent FROM PIDJoin WHERE PID1=@PID
	) ABC

	SELECT * INTO #PIDStock FROM PidStock WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDStock SET PID=@PID 
	SELECT * from #PIDStock where article='RC-119A-GR'
	SELECT * INTO #PIDGoodMovement FROM PIDGoodMovement WHERE PID IN (SELECT PID FROM #ListPID)
	UPDATE #PIDGoodMovement SET PID=@PID
	SELECT * from #PIDGoodMovement where article = 'RC-119A-GR'


	SELECT DISTINCT PID, SN, 0 AS Qty INTO #Temp1 FROM 
	(
		SELECT PID, SN FROM PIDScan WHERE PID='100001226'
		UNION 
		SELECT PID, SN FROM #PIDGoodMovement WHERE DC='C' AND PID='100001226'
	) X

	SELECT 
		A.PID, 
		A.SN, 
		A.Qty AS A,
		B.Qty AS QtyScan,
		C.Qty AS QtyStatusDebit,
		D.Qty AS QtyStatusCredit,
		A.Qty+COALESCE(B.Qty,0)+COALESCE(C.Qty,0)-COALESCE(D.Qty,0) AS Temp2Qty
	--INTO #Temp2
	FROM
		#Temp1 A
		LEFT JOIN (	SELECT  PID, SN, COUNT(SN) AS Qty FROM PIDScan m
					WHERE PID='100001226'
					GROUP BY PID, SN) AS B ON	B.PID=A.PID AND B.SN=A.SN
		LEFT JOIN (	SELECT PID, EAN AS SN, SUM(COALESCE(Qty,0)) AS Qty FROM #PIDGoodMovement
					WHERE PID='100001226' AND DC='D' AND SN=''
					GROUP BY PID, EAN
					UNION
					--SELECT PID, SN, SUM(COALESCE(Qty,0)) AS Qty FROM #PIDGoodMovement --27/05/2019
					SELECT PID, SN, 1 AS Qty FROM #PIDGoodMovement --27/05/2019
					WHERE PID='100001226' AND DC='D' AND SN NOT LIKE ''
					GROUP BY PID, SN )AS C ON C.PID=A.PID AND C.SN=A.SN -- END LEFT JOIN
		LEFT JOIN ( SELECT PID, EAN AS SN, SUM(COALESCE(Qty,0)) As Qty FROM #PIDGoodMovement
					WHERE PID='100001226' AND DC='C' AND SN=''
					GROUP BY PID, EAN
					UNION
					--SELECT PID, SN, SUM(COALESCE(Qty,0)) As Qty FROM #PIDGoodMovement --27/05/2019
					SELECT PID, SN, 1 As Qty FROM #PIDGoodMovement --27/05/2019
					WHERE PID='100001226' AND DC='C'  AND SN NOT LIKE ''
					GROUP BY PID, SN) AS D ON D.PID=A.PID AND D.SN=A.SN -- END LEFT JOIN
		WHERE
			A.SN in ('200730S001000084',
							'200730S001000085',
							'200730S001000086',
							'200730S001000087')

		select * from #Temp1 where SN in ('200730S001000084',
							'200730S001000085',
							'200730S001000086',
							'200730S001000087')
		select * from PIDScan where SN in ('200730S001000084',
							'200730S001000085',
							'200730S001000086',
							'200730S001000087')


	CREATE TABLE #PIDScan(PID Varchar(50) COLLATE DATABASE_DEFAULT NULL, SN varchar(50) COLLATE DATABASE_DEFAULT NULL)

	declare @PID varchar(50)
	declare	@SN		varchar(50),
			@Qty	int
		
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


	select * from #PIDScan

	select * into #Temp from 
	(
	--kuning
	select xx.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 
	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			FROM #PIDStock a 
			left join (select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,EAN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,EAN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226'
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS QTY,sernp,y.article from -- stock
		(
			--select * from #PIDGoodMovement where pid='100001226' and SN in ('200730S001000084',
			--							'200730S001000085',
			--							'200730S001000086',
			--							'200730S001000087')
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			FROM #PIDStock a 
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
						where DC='C' and pid='100001226' 
								and SN in ('200730S001000084',
										'200730S001000085',
										'200730S001000086',
										'200730S001000087')
						group by PID,SN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement 
						where DC='D' and pid='100001226' 
								and SN in ('200730S001000084',
										'200730S001000085',
										'200730S001000086',
										'200730S001000087')
						group by PID,SN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
				and a.SN in ('200730S001000084',
							'200730S001000085',
							'200730S001000086',
							'200730S001000087')
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226'
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007')
		and y.article = 'RC-119A-GR'
	) xx left join 
	(
		select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp 
		from #PIDScan hh 
		left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid='100001226'
		group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp

		union

		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp 
		from #PIDScan hh 
		left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid='100001226'
			and hh.SN in ('200730S001000084',
					'200730S001000085',
					'200730S001000086',
					'200730S001000087')

		select * from #PIDScan where SN in ('200730S001000084',
					'200730S001000085',
					'200730S001000086',
					'200730S001000087')

		union

		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp 
		from #PIDScan hh 
		left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid='100001226'
			and hh.SN in ('200730S001000084',
					'200730S001000085',
					'200730S001000086',
					'200730S001000087')

	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE XX.SERNP IS NOT NULL
	--kuning
	union 

	--BIRU
	select yy.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  
	from 
	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			FROM #PIDStock a 
			left join 
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='C' and pid='100001226' group by PID,EAN,batch) b on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join
			(select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement 
			where DC='D' and pid='100001226' group by PID,EAN,batch) c on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226'
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 AS qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			FROM #PIDStock a 
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,SN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,SN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226' and y.article = 'RC-119A-GR'
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx 
	right join 	(
		select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid='100001226'
		group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
		union
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid='100001226'
		union all
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where sernp is null and hh.pid=hy.pid and hy.pid='100001226'
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
			left join (select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,EAN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join (select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,EAN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226' and y.Article='RC-119A-GR'
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			FROM #PIDStock a 
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,SN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,SN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226' and y.Article='RC-119A-GR'
		where sernp='Z001' or sernp='Z002' or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx 
	right join 	(
		select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid='100001226'
		group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
		union
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid='100001226'
		union all
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
			where sernp is null and hh.pid=hy.pid and hy.pid='100001226'
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE xx.sernp IS NULL
	--MERAH
	UNION ALL

	--HIJAU
	select xx.pid,xx.SN,xx.article,xx.qty,xx.batch,xx.sernp,xx.StockType,coalesce(yy.sn,'') as SNFisik,coalesce(yy.qty,'') as QtyFisik  from 
	(
		select y.PID,y.SN,y.Batch,y.StockType,sum(qty) as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,cumqty-coalesce(b.qty,0)+coalesce(c.qty,0) as qty
			  FROM #PIDStock a 
			left join (select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,EAN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join (select PID,EAN AS SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,EAN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226' and y.Article='RC-119A-GR'
		where sernp='Z003' or sernp='Z004'
		group by y.SN,y.PID,y.Batch,y.StockType,sernp,article

		union

		select y.PID,y.SN,y.Batch,y.StockType, 1 as qty,sernp,article from
		(
			SELECT a.PID,a.SN,a.batch,1-coalesce(b.qty,0)+coalesce(c.qty,0) as qty--yahya
			FROM #PIDStock a 
			left join (select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='C' and pid='100001226' group by PID,SN,batch) b 
							on a.PID+a.SN+a.batch=b.PID+b.SN+b.batch
			left join(select PID,SN,batch,sum(qty) as qty from #PIDGoodMovement where DC='D' and pid='100001226' group by PID,SN,batch) c 
							on a.PID+a.SN+a.batch=c.PID+c.SN+c.batch
			where a.pid='100001226'
		) x
		inner join PIDSNEsto y on x.sn=y.sn and y.pid='100001226' and y.Article='RC-119A-GR'
		where sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007'
	) xx 
	left join 
	(
		select hh.PID,hh.SN,hy.Batch,hy.StockType,count(hh.SN) as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z003' or sernp='Z004') and hh.pid=hy.pid and hy.pid='100001226'
		group by hh.SN,hh.PID,hy.Batch,hy.StockType,sernp
		union
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where (sernp='Z001' or sernp='Z002'  or sernp='ZVHE' or sernp='Z005' or sernp='Z006' or sernp='Z007') and hh.pid=hy.pid and hy.pid='100001226'
		union
		select hh.PID,hh.SN,hy.Batch,hy.StockType,1 as qty,sernp from #PIDScan hh left join PIDSNEsto hy on hh.sn=hy.sn
		where sernp is null and hh.pid=hy.pid and hy.pid='100001226'
	) yy on xx.pid=yy.pid and xx.sn=yy.sn
	WHERE XX.SERNP IS  NULL
	--HIJAU
	) xxxxxx

	select distinct 
		coalesce(xxxx.article,'') as article,
		coalesce(xxxx.batch,'') as batch,
		coalesce(Unrestricted,0) as Unrestricted,
		qtyfisik,'' as keterangan 
	from (select article,batch,sum(qtyfisik) as qtyfisik from #Temp where pid='100001226' group by article,batch) xxxx 
	left join 	(
		select 
			xxx.article,
			xxx.batch,
			sum(qty) as Unrestricted 
		from #Temp xxx 
		where (xxx.StockType='01' or xxx.stocktype='06')
			and xxx.Article = 'RC-119A-GR'
		group by xxx.article,xxx.batch
	) yyyy on xxxx.article=yyyy.article and xxxx.batch=yyyy.batch
	where xxxx.article = 'RC-119A-GR'



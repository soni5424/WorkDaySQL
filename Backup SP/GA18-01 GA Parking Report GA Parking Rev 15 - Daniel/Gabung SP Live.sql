USE [Hartono]
GO

-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 4.10.19
-- Decription		: untuk menampilkan NoPolisi kendaraan terdaftar yang belum keluar

-- Modified By		: Daniel
-- Modified Date	: 06.05.20
-- Decription		: Nambah Member
-- ========================================
ALTER PROCEDURE  [dbo].[GA_PGetRptParkingExport]
	@NoTrx varchar(50) = '',
	@TglMasuk varchar(50) = '',
	@TglKeluar varchar(50) = '',
	@NoPolisi varchar(50) = '', 
	@EmployeeID varchar(50) = '',
	@BelumKeluar varchar(5) = '',
	@Terdaftar varchar(5) = ''
AS
BEGIN
	DECLARE @EmployeeIDTemp VARCHAR(50)
	DECLARE @TDaftar bit
	IF(@NoPolisi='')
		SET @NoPolisi='%%'		
	SET @BelumKeluar = CASE @BelumKeluar
		WHEN 'ALL' THEN '%%'
		WHEN '' THEN '%%'
		when 'YES' THEN @BelumKeluar		
	END	
	IF (@NoTrx='')
		SET @NoTrx='%%'					
	IF(@EmployeeID = '')
		SET @EmployeeIDTemp = '%%'	
	IF(@EmployeeID != '')
		SET @EmployeeIDTemp = (SELECT UserID FROM MasterUser WHERE KodeBarcode = @EmployeeID)	
		
	SELECT 
		[NoUrut]
		,[NoTrx] AS NoTransaksi
		,(SELECT TOP 1 NamaLokasi FROM MasterStore B WHERE B.KodeStore=A.KodeStore) AS NamaStore,
		CASE 
			WHEN NoPolisi IS NULL THEN (SELECT TOP 1 NoPolisi FROM GA_MasterKendaraanTerdaftar X WHERE X.NoKartu=A.NoKartu)
			ELSE NoPolisi
	    END AS NoPolisi
	    ,(case when NoKartu is null then 'No' when NoKartu = '' then 'No' else 'Yes' end)as Member
		,[Tarif]
		,[DateTimeIn] AS TanggalJamMasuk
		,[DateTimeOut] AS TanggalJamKeluar
		,(CONVERT(VARCHAR,DATEDIFF(MINUTE, [DateTimeIn], [DateTimeOut])/60%24)+':'+ CONVERT(VARCHAR,DATEDIFF(SECOND, [DateTimeIn], [DateTimeOut])/60%60)+':'+ CONVERT(VARCHAR,DATEDIFF(SECOND, [DateTimeIn], [DateTimeOut])%60)) AS Selisih
		,(SELECT NamaUser FROM MasterUser WHERE UserID=UserIDOut) AS NamaPetugasKeluar
		,KodeWS
		,NoKartu
		
	INTO #TPark
	FROM [Hartono].[dbo].[GA_Parking] A
	WHERE NoTrx LIKE '%'+@NoTrx+'%'
		AND CASE WHEN NoPolisi IS NULL THEN '' ELSE NoPolisi end LIKE @NoPolisi
		AND CASE WHEN [UserIDOut] IS NULL THEN '' ELSE [UserIDOut] END LIKE RTRIM(@EmployeeIDTemp)
		AND CASE WHEN [DateTimeOut] IS NULL THEN 'YES' ELSE 'NO' END LIKE @BelumKeluar			
	ORDER BY kodeStore, DateTimeIn, NoUrut, NoTrx		

	CREATE TABLE #tempGA1(NoUrut varchar(500),
						  NoTransaksi varchar(500),
						  NamaStore varchar(500),
						  NoPolisi varchar(500),
						  Member varchar(50),
						  Tarif varchar(500),
						  TanggalJamMasuk datetime,
						  TanggalJamKeluar datetime,
						  Selisih varchar(500),
						  NamaPetugasKeluar varchar(500),						 
						  KodeWS varchar(500),
						  NoKartu varchar(500)
						 )
						  
	IF (@TglMasuk = '' OR @TglKeluar = '')
		INSERT INTO #tempGA1
		SELECT * FROM #TPark
	ELSE
		INSERT INTO #tempGA1
		SELECT * FROM #TPark
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR,TanggalJamMasuk,103),103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,@TglMasuk,103),103) AND CONVERT(DATETIME,CONVERT(VARCHAR,@TglKeluar,103),103)
		
	IF (@Terdaftar = 'YES')
		SELECT * FROM #tempGA1 
		WHERE NoKartu in (SELECT b.NoKartu FROM GA_MasterKendaraanTerdaftar b WHERE b.NoKartu = NoKartu)
	ELSE
		SELECT * FROM #tempGA1
END
GO

-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 4.10.19
-- Decription		: untuk menampilkan NoPolisi kendaraan terdaftar yang belum keluar

-- Modified By		: Daniel
-- Modified Date	: 06.05.20
-- Decription		: Nambah Member
-- =============================================
ALTER PROCEDURE  [dbo].[GA_PGetRptParking]
	@NoTrx varchar(50) = '',
	@TglMasuk varchar(50) = '',
	@TglKeluar varchar(50) = '',
	@NoPolisi varchar(50) = '', 
	@EmployeeID varchar(50) = '',
	@BelumKeluar varchar(5) = '',
	@Terdaftar varchar(5) = ''
AS
BEGIN
	DECLARE @EmployeeIDTemp varchar(50),@TotalTarif int
	DECLARE @TDaftar bit
	
	IF(@NoPolisi='')
		SET @NoPolisi='%%'
	SET @BelumKeluar = CASE @BelumKeluar
		WHEN 'ALL' THEN '%%'
		WHEN '' THEN '%%'
		when 'YES' THEN @BelumKeluar
	END	
	IF (@NoTrx='')
		SET @NoTrx='%%'
	IF(@EmployeeID = '')
		SET @EmployeeIDTemp = '%%'
	IF(@EmployeeID != '')
		SET @EmployeeIDTemp = (SELECT UserID FROM MasterUser WHERE KodeBarcode = @EmployeeID)

	SELECT 
		[NoUrut]
		,[NoTrx] AS NoTransaksi
		,(SELECT TOP 1 NamaLokasi FROM MasterStore B WHERE B.KodeStore=A.KodeStore) AS NamaStore,
		CASE 
			WHEN NoPolisi IS NULL THEN (SELECT TOP 1 NoPolisi FROM GA_MasterKendaraanTerdaftar X WHERE X.NoKartu=A.NoKartu)
			ELSE NoPolisi
	    END AS NoPolisi
	    ,(case when NoKartu is null then 'No' when NoKartu = '' then 'No' else 'Yes' end)as Member
		,CONVERT(VARCHAR,CONVERT(INT,[Tarif])) AS Tarif
		,[DateTimeIn] AS TanggalJamMasuk
		,[DateTimeOut] AS TanggalJamKeluar
		,KodeWS
		,(SELECT NamaUser FROM MasterUser WHERE UserID=UserIDOut) AS NamaPetugasKeluar
		,[PhotoIN]
		,[PhotoOut]
		,NULL AS 'In'
		,NULL AS 'Out'
		,(CONVERT(VARCHAR,DATEDIFF(MINUTE, [DateTimeIn], [DateTimeOut])/60%24)+':'+ CONVERT(VARCHAR,DATEDIFF(SECOND, [DateTimeIn], [DateTimeOut])/60%60)+':'+ convert(varchar,datediff(second, [DateTimeIn], [DateTimeOut])%60)) AS Selisih
		,NoKartu
		,DateTimeIn
		
	INTO #TPark
	FROM GA_Parking A
	WHERE NoTrx LIKE '%'+@NoTrx+'%'
		AND CASE when NoPolisi IS NULL THEN '' ELSE NoPolisi end LIKE @NoPolisi
		AND CASE when [UserIDOut] IS NULL THEN '' ELSE [UserIDOut] END LIKE rtrim(@EmployeeIDTemp)
		AND CASE when [DateTimeOut] IS NULL THEN 'YES' ELSE 'NO' END LIKE @BelumKeluar
	ORDER BY kodeStore, DateTimeIn, NoUrut, NoTrx

	CREATE TABLE #tempGA1 (
		NoUrut varchar(500),
		NoTransaksi varchar(500),
		NamaStore varchar(500),
		NoPolisi varchar(500),
		Member varchar(50),
		Tarif varchar(500),
		TanggalJamMasuk datetime,
		TanggalJamKeluar datetime,
		KodeWS varchar(500),
		NamaPetugasKeluar varchar(500),
		PhotoIN varchar(500),
		PhotoOut varchar(500),
		Inn varchar(500),
		Outt varchar(500),
		Selisih varchar(500),
		NoKartu varchar(500),
		DateTimeIn datetime		
	)
	
	IF(@TglMasuk = '' or @TglKeluar = '')
	BEGIN
		INSERT INTO #tempGA1
		SELECT * FROM #TPark
	END
	ELSE
	BEGIN
		INSERT INTO #tempGA1
		SELECT * FROM #TPark
		WHERE CONVERT(DATETIME,CONVERT(VARCHAR,DateTimeIn,103),103) BETWEEN CONVERT(DATETIME,CONVERT(VARCHAR,@TglMasuk,103),103) and CONVERT(DATETIME,CONVERT(VARCHAR,@TglKeluar,103),103)
	END

	IF(@Terdaftar = 'YES')
		SELECT * FROM #tempGA1 
		WHERE NoKartu IN (SELECT b.NoKartu FROM GA_MasterKendaraanTerdaftar b WHERE b.NoKartu=NoKartu) 
	ELSE
		SELECT * from #tempGA1
END


GO

USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PGetRptParking]    Script Date: 08/05/2020 15.49.29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 4.10.19
-- Decription		: untuk menampilkan NoPolisi kendaraan terdaftar yang belum keluar
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
	FROM [Hartono].[dbo].[GA_Parking] A
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


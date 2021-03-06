USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PGetRptParkingExport]    Script Date: 08/05/2020 15.49.15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 4.10.19
-- Decription		: untuk menampilkan NoPolisi kendaraan terdaftar yang belum keluar
-- =============================================
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
						  Tarif varchar(500),
						  TanggalJamMasuk datetime,
						  TanggalJamKeluar datetime,
						  Selisih varchar(500),
						  NamaPetugasKeluar varchar(500),						 
						  KodeWS varchar(500),
						  NoKartu varchar(500))
						  
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


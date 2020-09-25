USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[sd_PGetSOCounterBarang]    Script Date: 11/06/2020 21.58.56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		: Rini Handini
-- Create date	: 16 Oktober 2017
-- Description	: Counter Barang
-- =============================================
-- =============================================
-- Modified By	: Soni Gunawan
-- Modif Date	: 20 Mei 2020
-- Description	: +ClickCollect
-- =============================================

ALTER PROCEDURE [dbo].[sd_PGetSOCounterBarang]
AS
BEGIN
	SELECT DISTINCT NoSOSAP FROM (
		SELECT NoSOSAP
		FROM CB_TrxCounterBarang
		WHERE
			CAST(CONVERT(VARCHAR, TanggalAntri, 111) AS DATETIME) = CAST(CONVERT(VARCHAR, GETDATE(), 111) AS DATETIME)
		UNION
		SELECT A.NoSOSAP_SALESDOCUMENT AS NoSOSAP
		FROM TrxFaktur A
			INNER JOIN TrxSO B ON A.NoSO=B.NoSO 
					AND B.IDCounter = (SELECT Nilai FROM MasterParameter WHERE Nama = 'ClickCollectCounterBarang')
			INNER JOIN SAP_BAPISDITM C ON A.NoSO=C.NODOCUMENT 
					AND C.ROUTE = (SELECT Nilai FROM MasterParameter WHERE Nama = 'SetupRouteClick&Collect')
		WHERE 
			dbo.getonlydate(GETDATE()) >= dbo.getonlydate(A.TglPengiriman)-3
			AND dbo.getonlydate(GETDATE()) <= dbo.getonlydate(A.TglPengiriman)
	) X
END

GO


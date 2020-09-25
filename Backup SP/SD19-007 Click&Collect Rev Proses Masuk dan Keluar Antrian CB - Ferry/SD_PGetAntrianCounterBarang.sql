USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SD_PGetAntrianCounterBarang]    Script Date: 11/06/2020 21.58.31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Abednego
-- Create date	: 19/09/2017
-- Description	: get list antrian counter barang
-- =============================================
-- =============================================
-- Modif By		: Soni Gunawan
-- Modif Date	: 20.9.19
-- Description	: Show FK07
-- =============================================
-- =============================================
-- Modif By		: Soni Gunawan
-- Modif Date	: 20.5.20
-- Description	: -Status FullPicking
-- =============================================
ALTER PROCEDURE [dbo].[SD_PGetAntrianCounterBarang]
	@KodeStore	varchar(2),
	@KodeWS		varchar(3)
AS
BEGIN
	--SELECT A.NoFaktur, F.NamaUser, B.NoSO, B.NoSOSAP_SALESDOCUMENT as NoSOSAP, E.KodeStore,
	--ISNULL((CASE
	--	--WHEN C.Picking = '' AND A.NoFaktur LIKE 'FK-07%' THEN 'Full Picking'
	--	WHEN C.Picking = 'A' then 'Belum Picking'
	--	WHEN C.Picking = 'B' then 'Parsial Picking'
	--	WHEN C.Picking = 'C' then 'Full Picking'
	--END), '') AS StatusBarang,
	--(CAST((DATEDIFF(s, A.TanggalAntri, getdate())/60) as varchar)+':'+CAST((DATEDIFF(s, A.TanggalAntri, getdate())%60) as varchar)) as LamaAntri
	--FROM CB_TrxCounterBarang A
	--	LEFT JOIN TrxFaktur B ON A.NoFaktur = B.NoFaktur
	--	LEFT JOIN CB_TrxStatusDO C ON B.NoSOSAP_SALESDOCUMENT = C.NoSO
	--	LEFT JOIN TrxSO D ON B.NoSO = D.NoSO
	--	LEFT JOIN CB_SetupCounterBarang E ON D.IDcounter = E.IDcounter
	--	LEFT JOIN MasterUser F ON B.KodeSales = F.KodeSales
	--WHERE (A.TanggalKeluar IS NULL AND A.UserScanKeluar IS NULL)
	--	AND (E.KodeStore=@KodeStore OR E.KodeStore IS NULL)
	--	AND (E.KodeWS=@KodeWS OR E.KodeWS IS NULL)
	--	AND A.TanggalAntri > GETDATE() - 1
	--ORDER BY A.TanggalAntri ASC

	IF (@KodeWS in (SELECT KodeWS FROM CB_SETUPCOUNTERBARANG WHERE KodeStore = @KodeStore AND IDCounter = (SELECT Nilai FROM MasterParameter WHERE Nama = 'ClickCollectCounterBarang')))
	BEGIN
		  SELECT A.NoFaktur, F.NamaUser, B.NoSO, B.NoSOSAP_SALESDOCUMENT as NoSOSAP, E.KodeStore,
		  ISNULL((CASE
				--WHEN C.Picking = '' AND A.NoFaktur LIKE 'FK-07%' THEN 'Full Picking'
				WHEN C.Picking = 'A' then 'Belum Picking'
				WHEN C.Picking = 'B' then 'Parsial Picking'
				WHEN C.Picking = 'C' then 'Full Picking'
		  END), '') AS StatusBarang,
		  (CAST((DATEDIFF(s, A.TanggalAntri, getdate())/60) as varchar)+':'+CAST((DATEDIFF(s, A.TanggalAntri, getdate())%60) as varchar)) as LamaAntri
		  FROM CB_TrxCounterBarang A
				LEFT JOIN TrxFaktur B ON A.NoFaktur = B.NoFaktur
				LEFT JOIN CB_TrxStatusDO C ON B.NoSOSAP_SALESDOCUMENT = C.NoSO
				LEFT JOIN TrxSO D ON B.NoSO = D.NoSO
				LEFT JOIN CB_SetupCounterBarang E ON D.IDcounter = E.IDcounter
				LEFT JOIN MasterUser F ON B.KodeSales = F.KodeSales
		  WHERE (A.TanggalKeluar IS NULL AND A.UserScanKeluar IS NULL)
				AND (E.KodeStore = @KodeStore OR E.KodeStore IS NULL)
				AND (E.KodeWS IS NULL)
				AND A.TanggalAntri > GETDATE() - 1
		  ORDER BY A.TanggalAntri ASC
	END
	ELSE
	BEGIN
		  SELECT A.NoFaktur, F.NamaUser, B.NoSO, B.NoSOSAP_SALESDOCUMENT as NoSOSAP, E.KodeStore,
		  ISNULL((CASE
				--WHEN C.Picking = '' AND A.NoFaktur LIKE 'FK-07%' THEN 'Full Picking'
				WHEN C.Picking = 'A' then 'Belum Picking'
				WHEN C.Picking = 'B' then 'Parsial Picking'
				WHEN C.Picking = 'C' then 'Full Picking'
		  END), '') AS StatusBarang,
		  (CAST((DATEDIFF(s, A.TanggalAntri, getdate())/60) as varchar)+':'+CAST((DATEDIFF(s, A.TanggalAntri, getdate())%60) as varchar)) as LamaAntri
		  FROM CB_TrxCounterBarang A
				LEFT JOIN TrxFaktur B ON A.NoFaktur = B.NoFaktur
				LEFT JOIN CB_TrxStatusDO C ON B.NoSOSAP_SALESDOCUMENT = C.NoSO
				LEFT JOIN TrxSO D ON B.NoSO = D.NoSO
				LEFT JOIN CB_SetupCounterBarang E ON D.IDcounter = E.IDcounter
				LEFT JOIN MasterUser F ON B.KodeSales = F.KodeSales
		  WHERE (A.TanggalKeluar IS NULL AND A.UserScanKeluar IS NULL)
				AND (E.KodeStore=@KodeStore)
				AND (E.KodeWS=@KodeWS)
				AND A.TanggalAntri > GETDATE() - 1
		  ORDER BY A.TanggalAntri ASC
	END
END
GO


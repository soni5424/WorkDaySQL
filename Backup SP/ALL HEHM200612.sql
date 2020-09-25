USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SD_PGetAntrianCounterBarang]    Script Date: 11/06/2020 21.52.01 ******/
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
-- Modif By		: Ferry Hartono
-- Modif Date	: 10 Juni 2020
-- Description	: FK CnC tidak langsung hilang jika tanggal hari sudah lebih dari tanggal antri +1
-- =============================================

ALTER PROCEDURE [dbo].[SD_PGetAntrianCounterBarang]
	@KodeStore	varchar(2),
	@KodeWS		varchar(3)
AS
BEGIN
	IF (@KodeWS in (SELECT KodeWS FROM CB_SETUPCOUNTERBARANG WHERE KodeStore = @KodeStore AND IDCounter = (SELECT Nilai FROM MasterParameter WHERE Nama = 'ClickCollectCounterBarang')))
	BEGIN
		  SELECT A.NoFaktur, F.NamaUser, B.NoSO, B.NoSOSAP_SALESDOCUMENT as NoSOSAP, E.KodeStore, E.KodeWS,
		  ISNULL((CASE
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
				AND (E.KodeWS = @KodeWS OR E.KodeWS IS NULL)
				AND A.TanggalAntri > '20200610' -- Cut 0ff Data
		  ORDER BY A.TanggalAntri ASC
	END
	ELSE
	BEGIN
		  SELECT A.NoFaktur, F.NamaUser, B.NoSO, B.NoSOSAP_SALESDOCUMENT as NoSOSAP, E.KodeStore,
		  ISNULL((CASE
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
				AND A.TanggalAntri > '20200610' -- Cut 0ff Data
				AND D.JenisSO LIKE '01%'
				AND ISNULL(D.IDCounter, '') <> ''
		  ORDER BY A.TanggalAntri ASC
	END
END
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[sd_PGetSOCounterBarang]    Script Date: 11/06/2020 21.54.08 ******/
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
-- Modified By	: Ferry Hartono
-- Modif Date	: 10 Juni 2020
-- Description	: Left join CB_TrxCounterBarang | TanggalKeluar is null | TglPengiriman > '20200501'
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
			LEFT JOIN CB_TrxCounterBarang D ON A.NoFaktur = D.NoFaktur
		WHERE 
			dbo.getonlydate(GETDATE()) >= dbo.getonlydate(A.TglPengiriman)-3
			AND D.TanggalKeluar IS NULL
			AND A.TglPengiriman > '20200501' -- Cut Off Data
	) X
END
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SL_PCheckExistFaktur]    Script Date: 11/06/2020 22.14.13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|David C.H|
-- Create date: |10/06/2020|
-- Description:	|Cek Faktur valid, retur or not|
-- =============================================
CREATE PROCEDURE [dbo].[SL_PCheckExistFaktur]
	@NoFaktur	varchar(18)
AS
BEGIN
	IF EXISTS(SELECT * FROM TrxFaktur WHERE NoFaktur = @NoFaktur)
	BEGIN
		IF EXISTS(SELECT * FROM TrxReturPenjualan WHERE NoFaktur = @NoFaktur)
			SELECT 'No Faktur Sudah Diretur'
		ELSE
			BEGIN
				IF NOT EXISTS(select KodeBarang from trxfakturdetail where kodebarang ='TIKETMASUK_DEPO' and NoFaktur=@NoFaktur)
					SELECT 'No Faktur yang diinputkan bukan Faktur Depo'
				ELSE
					IF EXISTS(SELECT Keterangan FROM msdata.dbo.KPST_LAIN where SubString(Keterangan,0,16) like @NoFaktur+'%')
						SELECT 'No Faktur Sudah Pernah Digunakan'
					ELSE
						SELECT ''
			END
	END
	ELSE
		SELECT 'No Faktur tidak ditemukan'
END
GO

USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SL_PCheckExistPND]    Script Date: 11/06/2020 22.15.15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|David C.H|
-- Create date: |10/06/2020|
-- Description:	|Cek Faktur valid, retur or not|
-- =============================================
CREATE PROCEDURE [dbo].[SL_PCheckExistPND]
	-- Add the parameters for the stored procedure here
	@NoPND	varchar(18)
AS
BEGIN
	IF EXISTS(SELECT NOPND FROM PND_TrxPengajuan WHERE NoPND = @NoPND)
	BEGIN
		IF NOT EXISTS(SELECT NOPND FROM PND_TrxPengajuan WHERE NoPND = @NoPND and [Status]='1')
			SELECT 'No PND Belum Diapprove'
		ELSE
			BEGIN
				IF EXISTS(SELECT Keterangan FROM msdata.dbo.KPST_LAIN where SubString(Keterangan,0,17) like @NoPND+'%')
					SELECT 'No PND Sudah Pernah Digunakan'
				ELSE
					SELECT ''
			END
	END
	ELSE
		SELECT 'No PND Tidak Ditemukan'
END
GO


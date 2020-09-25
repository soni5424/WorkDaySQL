USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[HLS_GetReportFKKirimHERegulerData]    Script Date: 24/08/2020 08.48.36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |08/03/2019|
-- Description:	|get required data to create report FK Kirim HE Reguler|

-- Modified:		|Daniel|
-- Modified date: |12/03/2019|
-- Description:	|descriptionFK|
-- =============================================
ALTER PROCEDURE [dbo].[HLS_GetReportFKKirimHERegulerData]
	@startDate	varchar(10),
	@endDate	varchar(10),
	@depo		varchar(50)
AS
BEGIN
	set dateformat dmy
	
	SELECT f.NoFaktur, CONVERT(varchar(10), f.Tanggal, 103) as 'Tanggal', CONVERT(varchar(10), f.TglPengiriman, 103) as 'TglPengiriman', sok.KodeStoreDepo, sok.KodeStoreStock, STUFF(sok.KubikasiBarang, LEN(RTRIM(sok.KubikasiBarang)) - 2, 1, ',') as 'KubikasiBarang',
			ISNULL((CASE 
				WHEN CONVERT(varchar(10), DATEADD(dd, 1, f.Tanggal), 103) = CONVERT(varchar(10), f.TglPengiriman, 103) THEN 1
				WHEN CONVERT(varchar(10), DATEADD(dd, 1, f.Tanggal), 103) != CONVERT(varchar(10), f.TglPengiriman, 103) THEN 0
			 END), 0) as 'Cek',
			 (select Description from sap_configdeliverypriority where DeliveryPriority = f.GroupPengiriman  )as descriptionFK			 
	FROM TrxFaktur f
	INNER JOIN TrxSOKirim sok ON sok.NoSO = f.NoSO
	INNER JOIN MasterStore ms ON ms.KodeStore = sok.KodeStoreDepo
	WHERE f.StatusPenyerahan = '01' AND -- f.GroupPengiriman = '01' AND 
		  (@startDate = '' OR f.Tanggal >= @startDate) AND
		  (@endDate = '' OR f.tanggal <= @endDate) AND
		  (@depo = '' OR ms.KodeStoreGP = @depo)
	ORDER BY f.Tanggal ASC
END


GO


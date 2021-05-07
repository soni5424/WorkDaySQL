USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[BMS_PGetArticleDataImageToBeRegisteredTemp]    Script Date: 04/05/2021 09:37:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Ricky|
-- Create date: |30/03/2021|
-- Description: |Get Article Data Image To Be Registered For Temp|
-- Project:		|BMS 2021|
-- =============================================
CREATE PROCEDURE [dbo].[BMS_PGetArticleDataImageToBeRegisteredTemp]
AS
BEGIN
SET DATEFORMAT dmy
	SELECT DISTINCT
	det.TrxID, det.Article, ISNULL(det.ArticleDesc, '-') ArticleDesc, fil.FilePath FilePath,
	CONVERT(VARCHAR,appr.ApprovalDate,103) SubmitDate,
	ISNULL(mm.Merk, '-') BrandID, ISNULL(mm.Keterangan, '-') BrandDesc,
	cmc.PurchGroup PGCode, cmc.Description PGDesc, cmc.MC MC
	FROM VP_NewArticleDetail det
	LEFT JOIN VP_NewArticleDetailFile fil ON det.TrxID = fil.TrxID AND det.Article = fil.Article AND (fil.Type = 'PICREF' OR fil.Type = 'PATHPIC')
	INNER JOIN SAP_ConfigMerchandiseCategory cmc ON det.MC = cmc.MC
	LEFT JOIN MasterMerk mm on det.Brand = mm.Merk AND mm.Status = 1
	INNER JOIN FI_SetupUserPG up on cmc.PurchGroup = up.PurchasingGroup and up.Status=1
	INNER JOIN VP_NewArticleDetailApproval appr ON det.TrxID = appr.TrxID AND det.Article = appr.Article AND appr.StatusApproval = 1
	LEFT JOIN BMS_RegisterArticleImage rai ON det.TrxID = rai.TrxID AND det.Article = rai.Article
	WHERE (det.PicByHE IS NULL OR det.PicByHE = 1)
	AND (fil.Type = 'PICREF' OR fil.Type IS NULL)
	--AND (det.Status = 1 OR det.Status NOT IN(2,5))
	--AND (det.Article IN (SELECT MATERIAL FROM SAP_Article))
	AND (det.AIN IN ('N', 'DEM', 'DUM', 'GIFT', 'GIM'))
	AND (rai.Status IS NULL)
END


GO


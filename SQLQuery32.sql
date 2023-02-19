USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[BMS22_PGetBrowseArticleForSetupBudgetMDRClaimTo]    Script Date: 6/20/2022 10:11:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Ricky|
-- Create date: |15/Juni/2022|
-- Description: |Get Browse Article Data For Setup Budget MDR Claim To|
-- Project:		|BMS 2022|
-- =============================================
CREATE PROCEDURE [dbo].[BMS22_PGetBrowseArticleForSetupBudgetMDRClaimTo]
	@pg				varchar(3),
	@vendorID		varchar(50),
	@brandID		varchar(18),
	@article		varchar(18),
	@articleDesc	varchar(40)
AS
BEGIN	
	SELECT DISTINCT a.MATERIAL as 'Article', a.MATL_DESC as 'Description'
	FROM SAP_ARTICLE a
	INNER JOIN SAP_ConfigMerchandiseCategory cmc ON LEFT(cmc.MC, 2) = LEFT(MATL_GROUP, 2) AND cmc.PurchGroup = @pg
	WHERE Site = 'S001'
			AND a.LIFNR = @vendorID
			AND a.BRAND_ID = @brandID
			AND  (@article IS NULL OR MATERIAL LIKE '%'+ @article +'%') 
			AND (@articleDesc IS NULL OR MATL_DESC LIKE '%'+ @articleDesc +'%')
	ORDER BY MATERIAL ASC
END
GO


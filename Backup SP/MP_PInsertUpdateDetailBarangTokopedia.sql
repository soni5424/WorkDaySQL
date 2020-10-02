USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[MP_PInsertUpdateDetailBarangTokopedia]    Script Date: 25/09/2020 16.00.37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Ferry Hartono
-- Create date: 01/07/2020
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MP_PInsertUpdateDetailBarangTokopedia]
	-- Add the parameters for the stored procedure here
	@SKU			VARCHAR(20),
	@KodeMP			VARCHAR(18),
	@ProductID		VARCHAR(15),
	@Name			VARCHAR(20),
	@URL			VARCHAR(20),
	@Variant		VARCHAR(100),
	@CategoryID		VARCHAR(100),
	@Category		VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT * FROM MP_DetailBarangTokopedia WHERE SKU = @SKU AND Kode_MP = @KodeMP) BEGIN
		UPDATE MP_DetailBarangTokopedia
		SET product_id = @ProductID,
			name = @Name,
			url = @URL,
			variant = @Variant,
			category_id = @CategoryID,
			category = @Category
		WHERE SKU = @SKU AND Kode_MP = @KodeMP
	END ELSE BEGIN
		INSERT INTO MP_DetailBarangTokopedia
		VALUES (@SKU, @KodeMP, @ProductID, @Name, @URL, @Variant, @CategoryID, @Category)
	END
END
GO


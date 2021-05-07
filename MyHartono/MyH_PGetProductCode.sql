USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 23.2.21
-- Description	: Get Product Code
-- =============================================
CREATE PROCEDURE MyH_PGetProductCode
	@Product_Code	varchar(100)
AS
BEGIN
	
	SELECT [Product_Code]
		,[Option_ID]
		,[Variant_ID]
		,[Created]
		,[Modified]
	FROM [dbo].[MyHartono_Products]
	WHERE Product_Code=@Product_Code

END
GO
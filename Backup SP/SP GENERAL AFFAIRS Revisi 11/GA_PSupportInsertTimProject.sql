USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportInsertTimProject]    Script Date: 15/06/2020 8:30:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry Hartono
-- Create date: 12/15/2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GA_PSupportInsertTimProject]
	-- Add the parameters for the stored procedure here
	@EmployeeID	VARCHAR(20),
	@Nama		VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		INSERT INTO GA_Support_SetupTimProject VALUES(@EmployeeID, @Nama)
	END TRY
	BEGIN CATCH
		SELECT 'Data sudah ada' AS ErrorMessage;
	END CATCH
END
GO


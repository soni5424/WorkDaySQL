USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportDeleteTimProject]    Script Date: 15/06/2020 8:31:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry Hartono
-- Create date: 13/05/2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GA_PSupportDeleteTimProject]
	-- Add the parameters for the stored procedure here
	@EmployeeID	VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		DELETE FROM GA_Support_SetupTimProject WHERE EmployeeID = @EmployeeID
	END TRY
	BEGIN CATCH
		SELECT 'Data tidak ditemukan' AS ErrorMessage;
	END CATCH
END
GO


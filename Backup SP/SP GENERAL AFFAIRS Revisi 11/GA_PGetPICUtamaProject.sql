USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PGetPICUtamaProject]    Script Date: 15/06/2020 8:33:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ferry
-- Create date: 08/06/2020
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GA_PGetPICUtamaProject]
	-- Add the parameters for the stored procedure here
	@KodeStore	VARCHAR(2) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *, '' AS WorkLocation
	FROM GA_Support_SetupTimProject
END
GO


Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		Daniel
-- Create date: 25/06/2020
-- Description:	Get User Slock
-- =============================================
CREATE PROCEDURE [dbo].[HLS_PGetCekUserSetupSlocCreateDO]
	-- Add the parameters for the stored procedure here
	@userid varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT sloc from HLS_setupusersloc where userid  = @userid
END


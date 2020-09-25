USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 23.9.20
-- Description	: SiteAutoComplete
-- =============================================
ALTER PROCEDURE HWS_PGetSloc
	@Sloc		varchar(4)
AS
BEGIN
	SELECT DISTINCT KodeGudang AS Sloc
	FROM MasterGudang
	WHERE KodeGudang LIKE @Sloc+'%'
END
GO
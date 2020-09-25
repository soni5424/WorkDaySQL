USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 24.9.20
-- Description	: SlocClearPickAutoComplete
-- =============================================
Create PROCEDURE HWS_PGetSlocClearPick
	@Sloc		varchar(4)
AS
BEGIN
	SELECT DISTINCT Sloc
	FROM HWS_PilihZPICK 
	WHERE Sloc LIKE @Sloc+'%'
END
GO
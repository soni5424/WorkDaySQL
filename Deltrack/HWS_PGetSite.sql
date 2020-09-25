USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 23.9.20
-- Description	: SiteAutoComplete
-- =============================================
Alter PROCEDURE HWS_PGetSite
	@Site		varchar(4)
AS
BEGIN
	SELECT DISTINCT SALES_OFF AS Site 
	FROM MasterStore 
	WHERE 
		Status=0 
		AND KodeStore<>'00' AND SALES_OFF!=''
		AND SALES_OFF LIKE @Site+'%'

END
GO
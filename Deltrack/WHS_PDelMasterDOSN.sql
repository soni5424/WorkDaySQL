USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 28.8.20
-- =============================================
Create PROCEDURE WHS_PDelMasterDOSN
    @NoDO           varchar(50)
AS
BEGIN
    DELETE WHS_MasterDOSN 
    WHERE NoDO = @NoDO OR (dbo.getonlydate(TglUpdate)+7 < dbo.getonlydate(getdate()))
END
GO
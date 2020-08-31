USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 28.8.20
-- =============================================
ALTER PROCEDURE WHS_PDelMasterSN
    @KodeBarang     varchar(18),
    @SITE           varchar(4)
AS
BEGIN
    DELETE WHS_MasterSN 
    WHERE (KodeBarang=@KodeBarang AND SITE=@SITE) OR (dbo.getonlydate(TglUpdate)+7 < dbo.getonlydate(getdate()))
END
GO
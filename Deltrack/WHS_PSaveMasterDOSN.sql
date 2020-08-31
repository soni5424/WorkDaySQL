USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 28.8.20
-- Description	: Insert SN dari SAP
-- =============================================
ALTER PROCEDURE WHS_PSaveMasterDOSN
    @NoDO           varchar(50),
    @KodeBarang     varchar(18),
    @SITE           varchar(4),
    @SLOC           varchar(4),
    @SN             varchar(50),
    @EAN            varchar(50),
    @TglDO          DateTime
AS
BEGIN
    DECLARE @SNProfile      varchar(50)
    SELECT @SNProfile = SERIAL_NUM FROM SAP_ARTICLE WHERE OLD_MAT_NO=@KodeBarang AND SITE = 'S001'

    INSERT INTO [dbo].[WHS_MasterDOSN] (
        [NoDO]
        ,[KodeBarang]
        ,[SITE]
        ,[SLOC]
        ,[SN]
        ,[EAN]
        ,[SNProfile]
        ,[TglUpdate]
        ,[TglDO]
    ) VALUES (
        @NoDO,
        @KodeBarang,
        @SITE,
        @SLOC,
        @SN,
        @EAN,
        @SNProfile,
        getdate(),
        @TglDO
    )
END
GO
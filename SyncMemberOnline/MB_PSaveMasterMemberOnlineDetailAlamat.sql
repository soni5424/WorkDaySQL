USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 2.10.20
-- Description	: Save MasterMemberOnlineDetailAlamat
-- =============================================

ALTER PROCEDURE MB_PSaveMasterMemberOnlineDetailAlamat
    @NoIDOnline     varchar(50),
    @IDAlamat       int,
    @Alamat         varchar(50)
AS
BEGIN

    IF (NOT EXISTS (SELECT * FROM MasterMemberOnlineDetailAlamat WHERE NoIDOnline=@NoIDOnline))
    BEGIN
        INSERT INTO [dbo].[MasterMemberOnlineDetailAlamat] (
            [NoIDOnline]
            ,[IDAlamat]
            ,[Alamat]
        ) VALUES (
            @NoIDOnline,
            @IDAlamat,
            @Alamat
        )
    END
    ELSE
    BEGIN
        UPDATE [dbo].[MasterMemberOnlineDetailAlamat]
        SET [Alamat] = @Alamat
        WHERE [NoIDOnline] = @NoIDOnline
            AND [IDAlamat] = @IDAlamat
    END
END
GO
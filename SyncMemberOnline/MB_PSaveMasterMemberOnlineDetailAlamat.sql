USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 2.10.20
-- Description	: Save MasterMemberOnlineDetailAlamat
-- =============================================

CREATE PROCEDURE MB_PSaveMasterMemberOnlineDetailAlamat
    @NoIDOnline     varchar(50),
    @IDAlamat       int,
    @Alamat         varchar(50)
AS
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
GO
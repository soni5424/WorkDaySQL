USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 2.10.20
-- Description	: Save MasterMemberOnline
-- =============================================

ALTER PROCEDURE MB_PSaveMasterMemberOnline
    @NoIDOnline     varchar(50),
    @Email          varchar(50),
    @NamaDepan      varchar(50),
    @NamaBelakang   varchar(50),
    @TanggalLahir   datetime,
    @NoHP           varchar(50)
AS
BEGIN
    IF (NOT EXISTS(SELECT * FROM MasterMemberOnline))
    BEGIN
        INSERT INTO [dbo].[MasterMemberOnline] (
            [NoIDOnline]
            ,[Email]
            ,[NamaDepan]
            ,[NamaBelakang]
            ,[TanggalLahir]
            ,[NoHP]
        ) VALUES (
            @NoIDOnline,
            @Email,
            @NamaDepan,
            @NamaBelakang,
            @TanggalLahir,
            @NoHP
        )
    END
    ELSE
    BEGIN 
        UPDATE [dbo].[MasterMemberOnline]
        SET [Email] = @Email,
            [NamaDepan] = @NamaDepan,
            [NamaBelakang] = @NamaBelakang,
            [TanggalLahir] = @TanggalLahir,
            [NoHP] = @NoHP
        WHERE NoIDOnline = @NoIDOnline
    END
END
GO
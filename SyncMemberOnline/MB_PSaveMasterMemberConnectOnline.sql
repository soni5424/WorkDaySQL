USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 2.10.20
-- Description	: Save MasterMemberConnectOnline
-- =============================================

ALTER PROCEDURE MB_PSaveMasterMemberConnectOnline
    @NoMember   varchar(50),
    @NoIDOnline varchar(50)
AS
BEGIN
    IF (NOT EXISTS(SELECT * FROM MasterMemberConnectOnline WHERE NoIDOnline=@NoIDOnline))
    BEGIN
        INSERT INTO [dbo].[MasterMemberConnectOnline] (
            [NoMember]
            ,[NoIDOnline]
        ) VALUES (
            @NoMember,
            @NoIDOnline
        )
    END
    ELSE
    BEGIN
        UPDATE [dbo].[MasterMemberConnectOnline]
        SET [NoMember] = @NoMember
        WHERE NoIDOnline = @NoIDOnline
    END
END
GO
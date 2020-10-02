USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 2.10.20
-- Description	: Save MasterMemberConnectOnline
-- =============================================

CREATE PROCEDURE MB_PSaveMasterMemberConnectOnline
    @NoMember   varchar(50),
    @NoIDOnline varchar(50)
AS
BEGIN
    INSERT INTO [dbo].[MasterMemberConnectOnline] (
        [NoMember]
        ,[NoIDOnline]
    ) VALUES (
        @NoMember,
        @NoIDOnline
    )
END
GO
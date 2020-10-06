USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 6.10.20
-- Description	: GetMasterMemberConnect
-- =============================================
ALTER PROCEDURE MB_PGetMasterMemberConnectOnline
	@NoIDOnline		varchar(50),
	@NoMember		varchar(50)=NULL
AS
BEGIN	
	SELECT * FROM MasterMemberConnectOnline 
	WHERE NoIDOnline=@NoIDOnline OR NoMember=ISNULL(@NoMember, '')
END
GO
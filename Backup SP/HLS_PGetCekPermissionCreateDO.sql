Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		Daniel
-- Create date: 25/06/2020
-- Description:	Get otorisasi grup
-- =============================================
CREATE PROCEDURE [dbo].[HLS_PGetCekPermissionCreateDO]
	-- Add the parameters for the stored procedure here
	@userid varchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

  if(exists(
			select b.KodePermission  from usertogruppermission a,
			GrupToPermission b
			where
			a.Kodegruppermission = b.Kodegruppermission
			and
			a.userid = @userid
			and
			(a.Kodegruppermission = 'DELPLAN' or a.Kodegruppermission = 'WHMANAGER')
			and 
			b.KodePermission = 'hlsdotombol'
			))
  begin
	select 'Ada'	  
  end
  else
  begin
	select 'Kosong'
  end
END






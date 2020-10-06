USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PSB_PGetCorrectiveAction]    Script Date: 06/10/2020 12.51.39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 03/12/2019
-- Description:	PSB_PGetCorrectiveAction

-- Modified:		Daniel
-- Create date: 07/02/2020
-- Description:	where userid ke table c

-- Modified:		Daniel
-- Create date: 09/03/2020
-- Description:	menutup Corrective userid
-- =============================================
ALTER PROCEDURE [dbo].[PSB_PGetCorrectiveAction]
	-- Add the parameters for the stored procedure here
	@UserID varchar(50),
	@Tanda varchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

    declare @User varchar(50)
    set @User = (select isnull((select KodeStore from  usertogruppermission where KodeGrupPermission = 'PSBSM' and  userid = @UserID),'NO'))
    
	/*if(@User = 'NO') 
	begin
		select distinct a.PSBNo,(convert(varchar(10),b.Date,103)+' '+convert(varchar(5),b.Date,114))as Date from psb_trxPSB b left join psb_trxPSBDetail a on a.PSBNo = b.PSBNo where a.checkdate is not null and a.CorrectiveDate is null
	end
	else
	begin
		select distinct a.PSBNo,(convert(varchar(10),b.Date,103)+' '+convert(varchar(5),b.Date,114))as Date from psb_trxPSB b left join psb_trxPSBDetail a on a.PSBNo = b.PSBNo where a.checkdate is not null and a.CorrectiveDate is null and b.Site = @User
	end */
	if(@Tanda = 'Corrective')
	begin
		select distinct a.PSBNo,(convert(varchar(10),b.Date,103)+' '+convert(varchar(5),b.Date,114))as Date 
		from psb_trxPSB b left join psb_trxPSBDetail a on a.PSBNo = b.PSBNo left join PSB_SetupAksesStoreArea c
		on b.Userid = c.UserID and c.KodeStore = b.Site and c.KodeArea = b.Area
		where a.checkdate is not null and a.CorrectiveDate is null /*and c.Userid = @UserID*/
	end
	if(@Tanda = 'CorrectiveStatus')	
	begin
		select distinct a.PSBNo,(convert(varchar(10),b.Date,103)+' '+convert(varchar(5),b.Date,114))as Date 
		from psb_trxPSB b left join psb_trxPSBDetail a on a.PSBNo = b.PSBNo left join PSB_SetupAksesStoreArea c
		on b.Userid = c.UserID and c.KodeStore = b.Site and c.KodeArea = b.Area
		where a.statusdate is null and a.CorrectiveDate is not null /*and c.Userid = @UserID*/
	end	
	
END





GO


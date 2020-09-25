USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PSB_PCekVersionAPK]    Script Date: 03/07/2020 13.54.25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 05/03/2020
-- Description:	Cek version APK
-- =============================================
ALTER PROCEDURE [dbo].[PSB_PCekVersionAPK]
	@Version varchar(50),
	@App varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @CVer varchar(50)
	set @CVer = (select VersiAPK from SA_SetupParameter where modul = @App)
	if(@Version != @CVer)
	begin
		select pathapk from SA_SetupParameter where modul = @App
	end
	else
	begin
		select 'Terupdate' as pathapk
	end
END



GO


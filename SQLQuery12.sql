USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MyH_PSavePromoPOSMsg]    Script Date: 08/28/2022 07:29:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created By		: Soni Gunawan
-- Create Date		: 26.4.22
-- Description		: Save dan clear table h_SAP_PromoPOStoMyHartono
-- =============================================
-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 27.5.22
-- Description		: Exclude Save Site/Store yang tidak perlu dikirim ke MyHartono
-- =============================================
ALTER PROCEDURE [dbo].[MyH_PSavePromoPOSMsg]
	@KodePromo		varchar(50),
	@Site			varchar(5),
	@Req			varchar(max),
	@Resp			varchar(max),
	@Msg			varchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@SITE!='S003' AND @SITE!= 'S005' AND @SITE!= 'S007')
	BEGIN
		INSERT INTO [Hartono].[dbo].[h_SAP_PromoPOStoMyHartono_history] (
			[KodePromo1]
			,[Site]
			,[Created]
			,[Status]
			,[Req]
			,[Resp]
			,[Message]
		) VALUES (
			@KodePromo,
			@Site,
			getdate(),
			0,
			@Req,
			@Resp,
			@Msg
		)
	END

	-- Hapus Promo Anak yang memang tidak akan terkirim ke MyHartono, 
	-- SP yg memfilter Promo untuk dikirim ke MyHartono adalah MyH_PGetPromoFreeToMyHartono	dan MyH_PGetPromoPotHargaToMyHartono
	--DELETE h_SAP_PromoPOStoMyHartono 
	--WHERE 
	--	dbo.getonlydate(created) < dbo.getonlydate(getdate()-3)
	--	AND Status <= 0 
END




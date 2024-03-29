USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MyH_PSavePromoPOS]    Script Date: 04/26/2022 17:35:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 26.4.22
-- Description	: Save dan clear table h_SAP_PromoPOStoMyHartono
-- =============================================
Create PROCEDURE [dbo].[MyH_PSavePromoPOSMsg]
	@KodePromo		varchar(50),
	@Site			varchar(5),
	@TglKirimPromo	datetime,
	@Req			varchar(max),
	@Resp			varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [Hartono].[dbo].[h_SAP_PromoPOStoMyHartono] (
		[KodePromo1]
		,[Site]
		,[Created]
		,[Status]
		,[Req]
		,[Resp]
	) VALUES (
		@KodePromo,
		@Site,
		@TglKirimPromo,
		0,
		@Req,
		@Resp
	)

	-- Hapus Promo Anak yang memang tidak akan terkirim ke MyHartono, 
	-- SP yg memfilter Promo untuk dikirim ke MyHartono adalah MyH_PGetPromoFreeToMyHartono	dan MyH_PGetPromoPotHargaToMyHartono
	--DELETE h_SAP_PromoPOStoMyHartono 
	--WHERE 
	--	dbo.getonlydate(created) < dbo.getonlydate(getdate()-1)
	--	AND Status <= 0 
END

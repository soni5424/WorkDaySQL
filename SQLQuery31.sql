USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[Jubelio_PSaveJubelio]    Script Date: 01/17/2022 15:17:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Soni Gunawan
-- Create date	: 11.1.22
-- Description	: SaveJubelioFaktur
-- =============================================
ALTER PROCEDURE [dbo].[Jubelio_PSaveJubelio]
	@NoFaktur			varchar(50),
	@NoSO				varchar(50),
	@NoOrderJubelio		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Hartono].[dbo].[t_Jubelio_StatusOrder] (
		[NoFaktur]
	   ,[NoSO]
	   ,[NoOrderJubelio]
	   ,[Tanggal]
	   ,[Status]
	   ,[Resi]
	   ,[UrlAWB]
	) VALUES (
		@NoFaktur,
		@NoSO,
		@NoOrderJubelio,
		getdate(),
		'Faktur',
		'',
		''
	)
	
	INSERT INTO [Hartono].[dbo].[l_Jubelio_StatusOrder] (
		[NoOrderJubelio]
       ,[Status]
       ,[TanggalStatus]
    ) VALUES (
		@NoOrderJubelio,
		'Faktur',
		getdate()
    )

	

END

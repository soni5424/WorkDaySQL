USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[SAP_PGetAllGudangTitip]    Script Date: 07/18/2022 14:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		: Soni Gunawan
-- Create date	: 29.9.14
-- Description	: 
-- =============================================

ALTER PROCEDURE [dbo].[SAP_PGetAllGudangTitip]
	@Site			varchar(10)
AS
BEGIN
	SELECT A.*, B.Display
	FROM 
		MASTERGUDANGTITIP A,
		MASTERGUDANG B
	WHERE 
		A.KODESTORE = 'S001'
		AND A.KODEGUDANG=B.KODEGUDANG
		AND A.KODESTORE=B.SITE
END


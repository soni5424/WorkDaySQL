USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[MM_PIsSOSTODropshipAdmin]    Script Date: 16/03/2021 13.43.33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		: Soni Gunawan
-- Create date	: 4.6.15
-- Description	:	
--
-- Modif By		: Soni Gunawan
-- Modif date	: 14.12.17
-- Description	: Ganti dengan StatusSTO
--
-- =============================================

CREATE PROCEDURE [dbo].[MM_PIsSOSTODropshipAdmin]
	@KodeStoreSO		varchar(5),
	@KodeStoreStock		varchar(5),
	@KodeStoreKirim		varchar(5)
AS
BEGIN
	IF EXISTS(SELECT * FROM SAP_SetupStoreSOSTO 
					WHERE KodeStoreSO=@KodeStoreSO 
					AND KodeStoreStock=@KodeStoreStock
					AND KodeStoreKirim=@KodeStoreKirim
					AND Status=1 
					and DropshipAdmin='1'
					)
		SELECT 1
	ELSE
		SELECT 0	
END
GO


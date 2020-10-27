USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PBLTCekStoreBLT5]    Script Date: 27/10/2020 08.54.36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Rini Handini
-- Create date	: 12 Agustus 2017
-- Description	: Cek Store Berlaku BLT
-- =============================================

ALTER PROCEDURE [dbo].[PBLTCekStoreBLT5]
	@KodeStore	varchar(2)
as

if (@KodeStore in ('01', '03', '04', '06', '09', '12', '13', '17'))
	select 1
else
	select 0







GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PGetDataFakturForAdd]    Script Date: 01/07/2020 13.25.51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Get Detail Faktur Untuk Tambah
-- =============================================
ALTER PROCEDURE [dbo].[CekTrf_PGetDataFakturForAdd]
	@NoFaktur	varchar(18)
AS
BEGIN
	set dateformat dmy;
	
	select f.NoFaktur, f.NamaPenerima, isnull(NilaiPembayaran,0) NilaiBayarTrf
	from TrxFaktur f left join TrxFakturBayar fb on f.NoFaktur=fb.NoFaktur and fb.KodeJenisPembayaran='TRF'
	where f.NoFaktur=@NoFaktur
	
END


GO


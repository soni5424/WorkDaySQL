USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PCheckValidTambahFaktur]    Script Date: 01/07/2020 13.26.29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Check Valid Tambah Faktur Transfer

-- Modified		: Peter
-- Modified date	: 12/06/2020
-- Description	: Ganti pengecekan 

-- Modified		: Daniel
-- Modified date	: 16/06/2020
-- Description	: Ganti pengecekan 
-- =============================================
ALTER PROCEDURE [dbo].[CekTrf_PCheckValidTambahFaktur]
	@NoFaktur	varchar(18),
	@Status		varchar(50),
	@NoFakturGE	varchar(18)
AS
BEGIN
	set dateformat dmy;
	if not exists (select 1 from TrxFaktur where NoFaktur=@NoFaktur)
		select 'No Faktur Tidak Ditemukan'
	else if exists (select 1 from CH_TrxCekTransferDetail where NoFaktur=@NoFaktur and NoPengajuan not in (Select NoPengajuan from CH_TrxRejectTransfer))
		select 'No Faktur Sudah Pernah Diajukan'
	else if (@Status='FK')
	Begin
		if(exists(select 0 from TrxFakturBayar where NoFaktur = @NoFaktur and KodeJenisPembayaran  not in(select nilai from masterpilihan where grup = 'KodejenisPembayaranCekTransfer' )))	
			select 'No Faktur Tidak Mengandung Tipe Bayar Cek Transfer'
		else if(@NoFakturGE != '' and exists(select 1 from CH_TrxCekTransferDetail where NoFakturGE=@NoFakturGE and NoPengajuan not in (Select NoPengajuan from CH_TrxRejectTransfer)))
			select 'No Faktur GE Sudah Pernah Diajukan'

		else
			select ''
	End
	else if (@Status='TP')
	Begin
		if not exists (select 1 from TrxFaktur where NoFaktur=@NoFaktur and Upper(StatusPembayaran) in ('KREDIT','COD'))
			select 'No Faktur Tidak Bisa Diinput Pelunasan'
		else
			select ''		
	End
	else
		select ''	
	
END

GO


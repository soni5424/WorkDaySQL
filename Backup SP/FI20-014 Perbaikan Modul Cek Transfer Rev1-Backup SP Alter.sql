USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PCheckValidFileAttach]    Script Date: 27/07/2020 15.03.33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Daniel
-- Create date	: 16/06/2020
-- Description	: Cek Load Gambar
-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PCheckValidFileAttach]
	@NoPengajuan	varchar(18)	
AS
BEGIN

if(not exists(select nopengajuan from CH_TRXHoldTransfer where NoPengajuan = @NoPengajuan))
begin
	--	select 'tidak ada di hold'
	if(exists(select nopengajuan from CH_TRXKonfirmTransfer where NoPengajuan = @NoPengajuan) or exists(select nopengajuan from CH_TRXRejectTransfer where NoPengajuan = @NoPengajuan))
	begin
		select 'File Ada'
	end
	else
	begin
		select 'File Bukti Transfer Tidak Ditemukan'
	end
end
else
begin
--	select 'ada dihold'	
	if(not exists(select nopengajuan from CH_TRXKonfirmTransfer where NoPengajuan = @NoPengajuan) or not exists(select nopengajuan from CH_TRXRejectTransfer where NoPengajuan = @NoPengajuan))
	begin
		select 'File Hold'
	end
	else
	begin
		select 'File Bukti Transfer Tidak Ditemukan'
	end
end	
END

GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PGetDataFakturForAdd]    Script Date: 27/07/2020 15.03.33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Get Detail Faktur Untuk Tambah

-- Modified		: Daniel
-- Modified date	: 01/07/2020
-- Description	: Ganti pengecekan Agar data yang ada dimasterpilihan dapat keluar
-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PGetDataFakturForAdd]
	@NoFaktur	varchar(18)
AS
BEGIN
	set dateformat dmy;
	
	select f.NoFaktur, f.NamaPenerima, isnull(NilaiPembayaran,0) NilaiBayarTrf
	from TrxFaktur f left join TrxFakturBayar fb on f.NoFaktur=fb.NoFaktur --and fb.KodeJenisPembayaran='TRF' --01/07/2020
	where f.NoFaktur=@NoFaktur
	and  --01/07/2020
		fb.KodeJenisPembayaran in (select nilai from masterpilihan where grup = 'KodejenisPembayaranCekTransfer' ) --01/07/2020
	
END



GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PGetListEmailTo]    Script Date: 27/07/2020 15.03.34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Get List Email To By KodeApproval & Store
-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PGetListEmailTo]
	@KodeApproval	varchar(21),
	@KodeStore		varchar(2)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL(STUFF((SELECT ',' + Email
				  FROM   CS_SetupEmail e
				  WHERE  e.KodeApproval=@KodeApproval and KodeStore=@KodeStore
				  ORDER BY email
				  FOR XML PATH('')), 1, 1, ''),'')
END


GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PGetListPengajuanByFilter]    Script Date: 27/07/2020 15.03.34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Get List Browse Pengajuan
-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PGetListPengajuanByFilter]
	@NoPengajuan	varchar(15),
	@TanggalTrf		varchar(10),
	@AtasNama		varchar(50),
	@Mode			varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	set dateformat dmy;
	
	declare @TglTrf datetime
	if(@TanggalTrf!='')	
		set @TglTrf=convert(varchar(8),cast(@TanggalTrf as Datetime),112)
	else
		set @TglTrf=NULL
	
	if(@Mode='NEW')
	Begin
		Select Top 50 NoPengajuan, CONVERT(varchar(10), TanggalTransfer, 103) TanggalTransfer, AtasNama
		from CH_TrxCekTransfer
		order by TanggalPengajuan desc
	End
	Else
	Begin
		Select NoPengajuan, CONVERT(varchar(10), TanggalTransfer, 103) TanggalTransfer, AtasNama
		from CH_TrxCekTransfer
		where NoPengajuan like '%'+@NoPengajuan+'%'
		and TanggalTransfer=ISNULL(@TglTrf,TanggalTransfer)
		and AtasNama like '%'+@AtasNama+'%'
		order by TanggalPengajuan desc	
	End
END


GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PGetListPengajuanCekTrfByFilter]    Script Date: 27/07/2020 15.03.34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author		: Peter
-- Create date	: 04/10/2018
-- Description	: Get List Pengajuan Cek Transfer
-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PGetListPengajuanCekTrfByFilter]
	@Status			varchar(50),
	@NoFaktur		varchar(50),
	@AtasNama		varchar(50)
AS
BEGIN
	set NoCount On;
	set dateformat dmy;
	
	declare @TNoFaktur varchar(50)
	if(@Nofaktur!='')
		set @TNoFaktur = @NoFaktur
	else
		set @TNoFaktur = NULL
		
	if(@Status='KONFIRM')
	Begin
		Select Distinct
			t.NoPengajuan, 
			CONVERT(varchar(10), t.TanggalPengajuan, 103) TanggalPengajuan, 
			CONVERT(varchar(10), t.TanggalTransfer, 103) TanggalTransfer, 
			t.AtasNama,
			t.NominalTransfer,
			t.UserID UserIDPengajuan,
			tu.NamaUser UserPengajuan,			
			CONVERT(varchar(10), TanggalKonfirm, 103) TanggalKonfirm, 
			tk.UserKonfirm UserIDKonfirm,
			tku.NamaUser UserKonfirm						
		from CH_TrxCekTransfer t, CH_TrxCekTransferDetail td, MasterUser tu, CH_TrxKonfirmTransfer tk, MasterUser tku
		where t.NoPengajuan=td.NoPengajuan
		and t.NoPengajuan=tk.NoPengajuan 
		and t.UserID=tu.UserID
		and tk.UserKonfirm=tku.UserID
		and td.NoFaktur=isnull(@TNoFaktur,td.NoFaktur)
		and t.AtasNama like '%'+@AtasNama+'%'
		order by TanggalPengajuan asc
	End
	Else if(@Status='CEKTRF')
	Begin 
		Select Distinct
			t.NoPengajuan, 
			CONVERT(varchar(10), t.TanggalPengajuan, 103) TanggalPengajuan, 
			CONVERT(varchar(10), t.TanggalTransfer, 103) TanggalTransfer, 
			t.AtasNama,
			t.NominalTransfer,
			t.UserID UserIDPengajuan,
			tu.NamaUser UserPengajuan,			
			'-' TanggalKonfirm, 
			'-' UserIDKonfirm,
			'-' UserKonfirm					
		from CH_TrxCekTransfer t, CH_TrxCekTransferDetail td, MasterUser tu
		where t.NoPengajuan=td.NoPengajuan
		and t.UserID=tu.UserID
		and t.NoPengajuan not in (select NoPengajuan from CH_TrxKonfirmTransfer)
		and t.NoPengajuan not in (select NoPengajuan from CH_TrxRejectTransfer)
		and td.NoFaktur=isnull(@TNoFaktur,td.NoFaktur)
		and t.AtasNama like '%'+@AtasNama+'%'
		order by TanggalPengajuan asc
	End
	Else 
	Begin 
		Select Distinct
			t.NoPengajuan, 
			CONVERT(varchar(10), t.TanggalPengajuan, 103) TanggalPengajuan, 
			CONVERT(varchar(10), t.TanggalTransfer, 103) TanggalTransfer, 
			t.AtasNama,
			t.NominalTransfer,
			t.UserID UserIDPengajuan,
			tu.NamaUser UserPengajuan,			
			'-' TanggalKonfirm, 
			'-' UserIDKonfirm,
			'-' UserKonfirm				
		from CH_TrxCekTransfer t, CH_TrxCekTransferDetail td, MasterUser tu
		where t.NoPengajuan=td.NoPengajuan
		and t.UserID=tu.UserID
		and t.NoPengajuan not in (select NoPengajuan from CH_TrxKonfirmTransfer)
		and t.NoPengajuan not in (select NoPengajuan from CH_TrxRejectTransfer)
		and td.NoFaktur=isnull(@TNoFaktur,td.NoFaktur)
		and t.AtasNama like '%'+@AtasNama+'%'
		order by TanggalPengajuan asc
	End	
END


GO

/****** Object:  StoredProcedure [dbo].[CekTrf_PRptKonfirmasiTrf]    Script Date: 27/07/2020 15.03.34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		: Peter
-- Create date	: 22/10/2018
-- Description	: Get Detail Report Konfirmasi Transfer


-- Edit			: David C.H
-- Create date	: 07/11/2018
-- Description	: Tambah Alasan Konfirm

-- =============================================
CREATE PROCEDURE [dbo].[CekTrf_PRptKonfirmasiTrf]
	@TglAwal	datetime,
	@TglAkhir	datetime
AS
BEGIN
	set dateformat dmy;
	
	DECLARE @TFrom		datetime,
			@TTo		datetime

	IF (@TglAwal IS NOT NULL)
		SET @TFrom=DATEADD(dd, 0, DATEDIFF(dd, 0, @TglAwal))
	ELSE
		SET @TFrom=NULL

	IF (@TglAkhir IS NOT NULL)
		SET @TTo=DATEADD(dd, 0, DATEDIFF(dd, 0, @TglAkhir))
	ELSE
		SET @TTo=NULL


	Select Distinct
		t.NoPengajuan, 
		CONVERT(varchar(10), t.TanggalPengajuan, 103) TanggalPengajuan, 
		t.UserID UserIDPengajuan,
		tu.NamaUser UserPengajuan,			
		CONVERT(varchar(10), t.TanggalTransfer, 103) TanggalTransfer, 
		t.AtasNama,
		t.Status,
		t.NominalTransfer,
		t.TransferKeBank,
		isnull(t.TotalTRF,0) TotalTRF,
		isnull(t.TotalTRFGE,0) TotalTRFGE,
		(t.NominalTransfer-isnull(TotalTRF,0)-isnull(TotalTRFGE,0)) SisaTransferan,
		td.NoFaktur,
		isnull(td.TRF,0) TRF,
		isnull(td.NoFakturGE,'') NoFakturGE,
		isnull(td.TRFGE,0) TRFGE,
		CONVERT(varchar(10), tk.TanggalKonfirm, 103) TanggalKonfirm, 
		tk.UserKonfirm UserIDKonfirm,
		tku.NamaUser UserKonfirm,
		isnull(tk.AlasanKonfirm,'')	AlasanKonfirm					
	from CH_TrxCekTransfer t, CH_TrxCekTransferDetail td, MasterUser tu, CH_TrxKonfirmTransfer tk, MasterUser tku
	where t.NoPengajuan=td.NoPengajuan
		and t.NoPengajuan=tk.NoPengajuan 
		and t.UserID=tu.UserID
		and tk.UserKonfirm=tku.UserID
		and DATEADD(dd, 0, DATEDIFF(dd, 0, t.TanggalTransfer)) >= IsNULL(@TFrom, DATEADD(dd, 0, DATEDIFF(dd, 0, t.TanggalTransfer)))
		and DATEADD(dd, 0, DATEDIFF(dd, 0, t.TanggalTransfer)) <= IsNULL(@TTo, DATEADD(dd, 0, DATEDIFF(dd, 0, t.TanggalTransfer)))	
	order by TanggalTransfer asc
END





GO



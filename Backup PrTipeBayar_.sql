USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetPromoTipeBayar]    Script Date: 31/05/2023 11.28.29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |13/10/2020|
-- Description:	|Get Tipe Bayar Promo|
-- Project:		|Promo Tipe Bayar Cash Only|

-- Modified By	: |Peter|
-- Modified date: |27/12/2022|
-- Description	: |Tambah pengecekan status aktif promo (terutama untuk NCC)|
-- =============================================
CREATE PROCEDURE [dbo].[PrTipeBayar_GetPromoTipeBayar]
	@kodePromo		varchar(50),
	@isDetailed		int = null
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	IF @isDetailed IS NULL OR @isDetailed = 1
	BEGIN
		SELECT rtrim(KodeJenisPembayaran) KodeJenisPembayaran, pj.kodepromo2
		FROM PR_MasterPromoDetailJenisPembayaran pj, pr_masterpromo p
		WHERE KodePromo2 = @kodePromo
		and pj.kodepromo1=p.kodepromo and p.Status!='2'
	END
	ELSE
	BEGIN
		SELECT DISTINCT CASE
				WHEN b.KodeKategoriPembayaran IS NULL OR b.KodeKategoriPembayaran = '' THEN rtrim(a.KodeJenisPembayaran)
				ELSE b.KodeKategoriPembayaran
		END as 'KodeJenisPembayaran'
		FROM pr_masterpromo p, PR_MasterPromoDetailJenisPembayaran a
		LEFT JOIN CH_MasterJenisPembayaran b ON a.KodeJenisPembayaran = b.KodeJenisPembayaran
		WHERE KodePromo2 = @kodePromo
		and a.kodepromo1=p.kodepromo and p.Status!='2'
	END
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKodeJenisPembayaranVBB]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 02/08/2021
-- Description:	Cek Tipe Bayar VBB
-- =============================================


CREATE PROCEDURE [dbo].[PrTipeBayar_GetKodeJenisPembayaranVBB]
@noFaktur varchar(30)
AS
BEGIN


select A.KodeJenisPembayaran,A.NilaiPembayaran from TrxFakturBayar A
where A.NoFaktur=@noFaktur
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKodeJenisPembayaranTTP]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		David C.H
-- Create date: 02/08/2021
-- Description:	Cek Lock Tipe Bayar TTP
-- =============================================


CREATE PROCEDURE [dbo].[PrTipeBayar_GetKodeJenisPembayaranTTP]
@NoTTP varchar(30)
AS
BEGIN
	select A.KodeJenisPembayaran,SubTotalTerimaUang NilaiPembayaran from TrxTandaTerimaUangDetail A
	where NoTandaTerimaUang=@NoTTP
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKeteranganTipeBayarByNoSO]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |19/10/2020|
-- Description:	|Get Keterangan Tipe Bayar By No SO|
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
-- =============================================
-- Author:		|David|
-- Create date: |20/01/2021|
-- Description:	|Get TOP 1 KodePromo dari PR_TrxSODetailWithPromo, Jika data lebih dari 1 ambil yg valid|
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
CREATE PROCEDURE [dbo].[PrTipeBayar_GetKeteranganTipeBayarByNoSO]
	@noSO		varchar(16)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	DECLARE @kodePromo varchar(50)
	SELECT DISTINCT TOP 1 @kodePromo = KodePromo
	FROM PR_TrxSODetailWithPromo
	WHERE NoSO = @noSO
		AND RTRIM(KodePromo) <> ''
	
	SELECT TOP 10 a.NamaJenisPembayaran
	FROM MasterJenisPembayaran a 
	INNER JOIN PR_MasterPromoDetailJenisPembayaran b ON a.KodeJenisPembayaran = b.KodeJenisPembayaran
	WHERE b.KodePromo2 = @kodePromo
	ORDER BY a.NamaJenisPembayaran
END

GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetListKodeJenisPembayaran]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |27/11/2020|
-- Description:	|Get List Kode Jenis Pembayaran From Promo|
-- Project:		|Promo Tipe Bayar|
-- =============================================
Create PROCEDURE [dbo].[PrTipeBayar_GetListKodeJenisPembayaran]
	@kodePromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy

	SELECT RTRIM(a.KodeJenisPembayaran) as 'KodeJenisPembayaran', RTRIM(a.NamaJenisPembayaran) as 'NamaJenisPembayaran'
	FROM MasterJenisPembayaran a 
	INNER JOIN PR_MasterPromoDetailJenisPembayaran b ON a.KodeJenisPembayaran = b.KodeJenisPembayaran
	WHERE b.KodePromo2 = @kodePromo
	ORDER BY a.NamaJenisPembayaran
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKodePromoTipeBayar]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |19/10/2020|
-- Description:	|Get Kode Promo Tipe Bayar|
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
CREATE PROCEDURE [dbo].[PrTipeBayar_GetKodePromoTipeBayar]
	@kodePromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	SELECT DISTINCT KodePromo1
	FROM PR_MasterPromoDetailJenisPembayaran
	WHERE KodePromo2 = @kodePromo
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKodePromoTipeBayarByNoSO]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |19/10/2020|
-- Description:	|Get Kode Promo Tipe Bayar By No SO|
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
CREATE PROCEDURE [dbo].[PrTipeBayar_GetKodePromoTipeBayarByNoSO]
	@noSO		varchar(16)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	SELECT DISTINCT b.KodePromo1
	FROM PR_TrxSODetailWithPromo a
	INNER JOIN PR_MasterPromoDetailJenisPembayaran b ON a.KodePromo = b.KodePromo2
	WHERE a.NoSO = @noSO
END
GO

/****** Object:  StoredProcedure [dbo].[PrTipeBayar_GetKeteranganTipeBayar]    Script Date: 31/05/2023 11.28.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |19/10/2020|
-- Description:	|Get Keterangan Tipe Bayar|
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
CREATE PROCEDURE [dbo].[PrTipeBayar_GetKeteranganTipeBayar]
	@kodePromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	DECLARE @res varchar(max)
	SET @res = ''

	SELECT @res = @res + a.NamaJenisPembayaran + ', '
	FROM MasterJenisPembayaran a 
	INNER JOIN PR_MasterPromoDetailJenisPembayaran b ON a.KodeJenisPembayaran = b.KodeJenisPembayaran
	WHERE b.KodePromo2 = @kodePromo
	ORDER BY a.NamaJenisPembayaran

	SELECT LEFT(@res, LEN(@res) - 2)
END
GO


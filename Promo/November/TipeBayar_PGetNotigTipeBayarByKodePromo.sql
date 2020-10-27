USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[RioTipeBayar_GetPromoTipeBayar]    Script Date: 16/10/2020 10.47.27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Soni Gunawan
-- Create Date	: 15.10.2020
-- Description	: Get Tipe Bayar Promo
-- =============================================
Create PROCEDURE TipeBayar_PGetNotifTipeBayarByKodePromo
	@kodePromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	SELECT DISTINCT CASE
			WHEN b.KodeKategoriPembayaran IS NULL OR b.KodeKategoriPembayaran = '' THEN a.KodeJenisPembayaran
			ELSE b.KodeKategoriPembayaran
	END as 'KodeJenisPembayaran'
	INTO #PromoTipeBayar
	FROM 
		PR_MasterPromoDetailJenisPembayaran a
		LEFT JOIN CH_MasterJenisPembayaran b ON a.KodeJenisPembayaran = b.KodeJenisPembayaran
	WHERE KodePromo2 = @kodePromo

	SELECT 
		A.*,
		B.NamaJenisPembayaran
	FROM #PromoTipeBayar A
		INNER JOIN MasterJenisPembayaran B ON A.KodeJenisPembayaran=B.KodeJenisPembayaran
	UNION
	SELECT 
		A.*,
		B.NamaKategoriPembayaran AS NamaJenisPembayaran
	FROM #PromoTipeBayar A
		INNER JOIN CH_MasterKategoriPembayaran B ON A.KodeJenisPembayaran=B.KodeKategoriPembayaran
END
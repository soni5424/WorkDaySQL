USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[pr_PAddTrxSODetailWithPromo2]    Script Date: 05/25/2021 14:11:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author			: Rini Handini
-- Create date		: 15 Februari 2012
-- Description		: Promo Gabungan

-- Modified date	: 16 April 2012
-- Modified desc	: Promo Gabungan Revisi 3

-- Modified date	: 28 Juni 2012
-- Modified desc 	: Promo Gabungan Revisi 10

-- Modified By		: 
-- Modified date	: 11 Mei 2021
-- Modified desc 	: Get Promo

-- =============================================

Create procedure [dbo].[pr_PAddTrxSODetailWithPromo2]
	@NoSO				varchar(16),
	@KodeBarang			varchar(20),
	@KodeGudang			varchar(6),
	@DiscountVPR		decimal(18, 2),
	@DiscountVPRB		decimal(18, 2),
	@DiscountVPRT		decimal(18, 2),
	@DiscountVPRTB		decimal(18, 2),
	@KodePromo			varchar(50),
	@JumlahPakaiPromo	int,
	@KodeBarangUtama	varchar(50),
	@GiftDVC			decimal(18, 2),
	@GiftDVCB			decimal(18, 2),
	@VoucherCB			decimal(18, 2),
	@VoucherCBB			decimal(18, 2),
	@IDPromo			varchar(50),
	@JenisDVC			varchar(50)
as
BEGIN
	DECLARE @JmlPromo int,
			@JumlahTerpakaiPromo int

	SELECT @JmlPromo = p.JumlahPromo
	FROM PR_MasterPromo p
	WHERE p.KodePromo = @KodePromo

	SELECT @JumlahTerpakaiPromo = ISNULL(SUM(JumlahPakaiPromo), 0)
	FROM
		PR_TrxSODetailWithPromo t,
		TrxSO s
	where
		t.NoSO = s.NoSO
		AND t.KodePromo = @KodePromo
		AND s.StatusBatal = 'False'

	IF (@JmlPromo > 0)
	BEGIN
		IF (@JmlPromo < @JumlahTerpakaiPromo + @JumlahPakaiPromo)
		BEGIN
			DECLARE @ErrorMsg VARCHAR(MAX)
			SELECT @ErrorMsg = 'Jumlah Promo ' + @KodePromo + ' sudah mencapai batasnya'
			RAISERROR(@ErrorMsg, 16, 1)
		END
	END

	IF NOT EXISTS (SELECT NoSO from PR_TrxSODetailWithPromo where NoSO = @NoSO and KodeBarang = @KodeBarang and KodeGudang = @KodeGudang)
	BEGIN
		INSERT INTO PR_TrxSODetailWithPromo (
			NoSO,
			KodeBarang,
			KodeGudang,
			DiscountVPR,
			DiscountVPRB,
			DiscountVPRT,
			DiscountVPRTB,
			KodePromo,
			JumlahPakaiPromo,
			KodeBarangUtama,
			GiftDVC,
			GiftDVCB,
			VoucherCB,
			VoucherCBB,
			IDPromo,
			JenisDVC
		)
		VALUES (
			@NoSO,
			@KodeBarang,
			@KodeGudang,
			@DiscountVPR,
			@DiscountVPRB,
			@DiscountVPRT,
			@DiscountVPRTB,
			@KodePromo,
			@JumlahPakaiPromo,
			@KodeBarangUtama,
			@GiftDVC,
			@GiftDVCB,
			@VoucherCB,
			@VoucherCBB,
			@IDPromo,
			@JenisDVC
		)

		UPDATE
			PR_MasterPromoTerpakai
		SET
			JumlahPromoTerpakai = JumlahPromoTerpakai + @JumlahPakaiPromo
		WHERE
			KodePromo = @KodePromo
	END
END
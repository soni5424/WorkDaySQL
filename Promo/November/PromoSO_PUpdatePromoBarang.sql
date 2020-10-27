USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 19.10.20
-- Description	: Update Barang Promo
-- =============================================
ALTER PROCEDURE PromoSO_PUpdatePromoBarang
	@NoFakturUtama			varchar(50),
	@NoVoucher				varchar(100),
	@NoFakturBarangFree		varchar(50),
	@TanggalFKBarangFree	varchar(50),
	@KodeBarangFree			varchar(50),
	@NamaBarangFree			varchar(200)
AS
BEGIN
	UPDATE MasterPromoBarangDetailPakai 
	SET NoFakturBarangFree=@NoFakturBarangFree,
        TanggalFKBarangFree=@TanggalFKBarangFree,
        KodeBarangFree=@KodeBarangFree,
        NamaBarangFree=@NamaBarangFree
	WHERE NoFaktur=@NoFakturUtama AND NoVoucher=@NoVoucher

	SELECT * FROM MasterPromoBarangDetailPakai
	WHERE 
		NoFaktur=@NoFakturUtama 
		AND NoVoucher=@NoVoucher 
		AND NoFakturBarangFree=@NoFakturBarangFree
		AND TanggalFKBarangFree=@TanggalFKBarangFree
		AND KodeBarangFree=@KodeBarangFree
		AND NamaBarangFree=@NamaBarangFree
END
GO
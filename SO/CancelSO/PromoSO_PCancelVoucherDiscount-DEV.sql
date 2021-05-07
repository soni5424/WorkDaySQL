USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 20.10.20
-- Description	: CancelSO Promo November
-- =============================================
CREATE PROCEDURE PromoSO_PCancelVoucherDiscount
	@NoSo		varchar(50)
AS
BEGIN

	UPDATE MasterPromoDiscountDetailVoucher 
	SET StatusTerpakai=0 
	WHERE NoVoucher in (SELECT NoVoucher 
						FROM MasterPromoDiscountDetailPakai 
						WHERE NoSO = @NoSO and Status='1')

	UPDATE MasterPromoDiscountDetailPakai 
	SET Status=0 
	WHERE NoSO = @NoSO and status='1'

END
GO
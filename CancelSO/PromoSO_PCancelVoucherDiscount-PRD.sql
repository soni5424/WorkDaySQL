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

	UPDATE [192.168.9.27].Hartono.dbo.MasterPromoDiscountDetailVoucher 
	SET StatusTerpakai=0 
	WHERE NoVoucher in (SELECT NoVoucher 
						FROM [192.168.9.27].Hartono.dbo.MasterPromoDiscountDetailPakai 
						WHERE NoSO = @NoSO and Status='1')

	UPDATE [192.168.9.27].Hartono.dbo.MasterPromoDiscountDetailPakai 
	SET Status=0 
	WHERE NoSO = @NoSO and status='1'

END
GO
USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PromoSO_isBarangDiscount]    Script Date: 09/11/2020 12.26.50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author			: David Christian H
-- Create date		: 05/10/2020
-- Description		: Promo November SO
-- =============================================

ALTER PROCEDURE  [dbo].[PromoSO_isBarangDiscount]
	@KodeBarang varchar(50), 
	@SubTotalHarga decimal(18,2),
	@NoMember varchar(20),
	@flagPromo3 int = null
AS
BEGIN
DECLARE
@KodeVoucher varchar(200),
@JenisMember varchar (3),
@CekKodeBarang bit

IF (@flagPromo3 IS NULL)
	SET @flagPromo3 = 0

SET @CekKodeBarang= (select dbo.[PromoSO_CekBarangPromo](@KodeBarang))
SET @JenisMember = (select JenisMember from MasterMember where nomember=@NoMember) 
	
	IF (@CekKodeBarang=1 
	and (@flagPromo3 = 1 OR @SubtotalHarga >=1000000)
	and (@flagPromo3 = 1 OR @NoMember not in (select NoMember FROM MasterPromoDiscountDetailPakai where Status ='1'))
	and (@flagPromo3 = 1 OR @NoMember <> '00-00000001')
	and (@flagPromo3 = 1 OR @JenisMember='P'))
	and  convert(datetime,(convert(varchar(10),getdate(),103)),103) between convert(datetime,(convert(varchar(10),'05/11/2020',103)),103) and convert(datetime,(convert(varchar(10),'15/11/2020',103)),103)
		BEGIN
			IF (@flagPromo3 = 1)
			BEGIN
				SELECT 1 as result
			END
			ELSE
			BEGIN
				IF (@SubTotalHarga>=1000000 and @SubTotalHarga <2000000)
					BEGIN
						IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					END
				IF (@SubTotalHarga>=2000000 and @SubTotalHarga <5000000)
					BEGIN
						IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
						ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					END
				ELSE IF (@SubTotalHarga>=5000000 and @SubTotalHarga <7500000)
				BEGIN
					IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('7','8','9','10','11') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('7','8','9','10','11') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
				END
				ELSE IF (@SubTotalHarga>=7500000 )
				BEGIN
					IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('12','13','14','15','16') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('12','13','14','15','16') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('7','8','9','10','11') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('7','8','9','10','11') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('3','4','5','6') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
					ELSE IF EXISTS (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							BEGIN
							SET @KodeVoucher = (select top 1 NoVoucher from MasterPromoDiscountDetailVoucher where JenisVoucher in('1','2') and statusTerpakai=0)
							Update MasterPromoDiscountDetailVoucher set statusTerpakai='1' where NoVoucher=@KodeVoucher
							SELECT NilaiVoucher,NoVoucher from MasterPromoDiscountDetailVoucher where NoVoucher=@KodeVoucher
							END
				END	
			END
		END
END
GO


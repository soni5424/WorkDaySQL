USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PromoSO_CheckHSSDoubleCoupon]    Script Date: 09/11/2020 12.28.02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		|Rio|
-- Create date: |20/10/2020|
-- Description:	|Cek apakah faktur HSS |
-- Project:		|Promo Tipe Bayar Cash Only|
-- =============================================
ALTER PROCEDURE [dbo].[PromoSO_CheckHSSDoubleCoupon]
	@noFaktur		char(18)
AS
BEGIN
	SET NOCOUNT ON
	set dateformat dmy
	
	DECLARE @tanggalFaktur datetime
	SELECT @tanggalFaktur = Tanggal
	FROM TrxFaktur
	WHERE NoFaktur = @noFaktur
	
	-- check date
	IF (DATEADD(dd, 0, DATEDIFF(dd, 0, @tanggalFaktur)) >= CONVERT(datetime, '20201105') AND DATEADD(dd, 0, DATEDIFF(dd, 0, @tanggalFaktur)) <= CONVERT(datetime, '20201115'))
	BEGIN
		-- Promo 1
		DECLARE @ss TABLE (Result INT)
		
		DECLARE @kodeBarang char(20), @subTotalHarga decimal(18, 2), @noMember varchar(50)

		DECLARE myCursor CURSOR FOR   
		SELECT b.KodeBarang, b.SubTotalHarga + b.Discount as 'SubTotalHarga', a.PointRewardTo as 'NoMember'
		FROM TrxFaktur a
		INNER JOIN TrxFakturDetail b ON a.NoFaktur = b.NoFaktur
		WHERE a.NoFaktur = @noFaktur
		  
		OPEN myCursor
		FETCH NEXT FROM myCursor INTO @kodeBarang, @subTotalHarga, @noMember

		WHILE @@FETCH_STATUS = 0
		BEGIN
			insert into @ss exec PromoSO_isBarangDiscount @kodeBarang, @subTotalHarga, @noMember, 1
			FETCH NEXT FROM myCursor INTO @kodeBarang, @subTotalHarga, @noMember
		END

		CLOSE myCursor
		DEALLOCATE myCursor
		
		IF EXISTS (SELECT * FROM @ss WHERE Result = 1)
		BEGIN
			SELECT 1 as 'Result'
		END
		ELSE
		BEGIN
			-- Promo 2
			DECLARE @tmpPromo2 TABLE (KodeBarang char(20),KodeGudang char(6),SubTotalHarga decimal(18,2),PointRewardTo varchar(50),KodeStore char(2))
			insert into @tmpPromo2 exec PromoSO_CekValidPromoBarang @noFaktur, 1
			
			IF EXISTS (SELECT * FROM @tmpPromo2)
			BEGIN
				SELECT 1 as 'Result'
			END
			ELSE
			BEGIN
				SELECT 0 as 'Result'
			END
		END
	END
	ELSE
	BEGIN
		SELECT 0 as 'Result'
	END
END
GO


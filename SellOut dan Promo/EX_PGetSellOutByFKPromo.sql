USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 21.10.20
-- Description	: Excel Sell Out Promo
-- =============================================
alter PROCEDURE EX_PGetSellOutByFKPromo
	@From			varchar(50),
	@To				varchar(50),
	@Site			varchar(50)=NULL,
	@PG				varchar(50)=NULL
AS
BEGIN
	DECLARE @KodeStore	varchar(50)
	SELECT @KodeStore = KodeStore FROM MasterStore WHERE KodeStoreGP=@Site AND SALES_OFF LIKE '%S%'

	IF (@KodeStore='ALL' OR @KodeStore IS NULL)
		SET @KodeStore = ''

	IF (@PG='ALL' OR @PG IS NULL)
		SET @PG = ''

	SELECT DISTINCT
		(SELECT KodeStoreGP FROM MasterStore WHERE  KodeStore=A.KodeStore) AS Site,
		A.Tanggal AS TglFK,
		A.NoFaktur AS NoFK,
		A.NoSO,
		B.KodeBarang AS Article,
		(SELECT DESCRIPTION FROM SAP_ConfigMerchandiseCategory WHERE C.MATL_GROUP=MC) PG,
		CASE E.JenisPromo
			WHEN 'Z001' THEN 'Cash Back with Instalment'
			WHEN 'Z002' THEN 'Purchase with Purchase'
			WHEN 'Z003' THEN 'Gift on Purchase (BLT)'
			WHEN 'Z004'	THEN 'Point Reward for Payment'
			WHEN 'Z005' THEN 'Direct Discount'
			WHEN 'Z006' THEN 'Redemption Point'
			WHEN 'Z007' THEN 'Voucher for Next Transaction'
			WHEN 'Z008' THEN 'One Price for Group Item'
			WHEN 'Z009' THEN 'Gift With Purchase'
			WHEN 'Z010' THEN 'Lucky Draw'
			WHEN 'Z011' THEN 'Tender Type Restriction'
			WHEN 'Z012' THEN 'Direct Disc Total Value'
			WHEN 'Z015' THEN 'Discount Trade In'
			WHEN 'Z016' THEN 'Cetak SPK Trade In'
			WHEN 'Z017' THEN 'Leasing Restriction'
		END TypePromo,
		A.TotalHarga AS RpBruto,
		A.TotalHarga - A.TotalPembayaran AS Diskon,
		A.TotalPembayaran AS RpNetto
	FROM 
		TrxFaktur A
		INNER JOIN TrxFakturDetail B ON A.NoFaktur=B.NoFaktur
		INNER JOIN SAP_ARTICLE C ON B.KodeBarang=C.OLD_MAT_NO AND C.SITE='S001'
		INNER JOIN PR_TrxSODetailWithPromo D ON A.NoSO=D.NoSO
		INNER JOIN PR_MasterPromo E ON D.KodePromo=E.KodePromo
	WHERE
		dbo.getonlydate(A.Tanggal) BETWEEN CONVERT(datetime, @From, 103) AND CONVERT(datetime,@To, 103)
		AND A.KodeStore LIKE '%'+ @KodeStore+'%'
		AND C.MATL_GROUP LIKE '%' + @PG +'%'
	ORDER BY A.Tanggal ASC
END
GO
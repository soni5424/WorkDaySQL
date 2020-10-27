USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 22.10.20
-- Description	: 
-- =============================================
Create PROCEDURE EX_PGetSellOutByFK
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

	SELECT
		(SELECT KodeStoreGP FROM MasterStore WHERE  KodeStore=A.KodeStore) AS Site,
		A.Tanggal AS TglFK,
		A.NoFaktur AS NoFK,
		B.KodeBarang AS Article,
		(SELECT DESCRIPTION FROM SAP_ConfigMerchandiseCategory WHERE C.MATL_GROUP=MC) PG,
		A.TotalHarga AS RpBruto,
		A.TotalHarga - A.TotalPembayaran AS Diskon,
		A.TotalPembayaran AS RpNetto
	FROM 
		TrxFaktur A
		INNER JOIN TrxFakturDetail B ON A.NoFaktur=B.NoFaktur
		INNER JOIN SAP_ARTICLE C ON B.KodeBarang=C.OLD_MAT_NO AND C.SITE='S001'
	WHERE
		dbo.getonlydate(A.Tanggal) BETWEEN CONVERT(datetime, @From, 103) AND CONVERT(datetime,@To, 103)
		AND A.KodeStore LIKE '%'+ @KodeStore+'%'
		AND C.MATL_GROUP LIKE @PG +'%'
	ORDER BY A.Tanggal ASC
END
GO
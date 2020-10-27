USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 13.10.20
-- Description	: 
-- =============================================
CREATE PROCEDURE EX_PGetSellOutByFKDetail
	@From			datetime,
	@To				datetime,
	@Site			varchar(50)=NULL,
	@PG				varchar(50)=NULL,
	@Server			varchar(50)=NULL
AS
BEGIN
	
	DECLARE @KodeStore	varchar(50)
	SELECT @KodeStore = KodeStore FROM MasterStore WHERE SALES_OFF=@Site

	IF (@KodeStore='ALL' OR @KodeStore IS NULL)
		SET @KodeStore = ''

	IF (@PG='ALL' OR @PG IS NULL)
		SET @PG = ''

	SELECT 
		(SELECT SALES_OFF FROM MasterStore WHERE KodeStore=A.KodeStore) AS Site,
		A.Tanggal AS TglFK,
		A.NoFaktur AS NoFK,
		B.KodeBarang AS Article,
		C.MATL_GROUP AS PG,
		A.TotalHarga AS RpBruto,
		A.TotalHarga - A.TotalPembayaran AS Diskon,
		A.TotalPembayaran AS RpNetto
	FROM 
		TrxFaktur A
		INNER JOIN TrxFakturDetail B ON A.NoFaktur=B.NoFaktur
		INNER JOIN SAP_ARTICLE C ON B.KodeBarang=C.OLD_MAT_NO AND C.SITE='S001'
	WHERE
		dbo.getonlydate(A.Tanggal) BETWEEN dbo.getonlydate(@From) AND dbo.getonlydate(@To)
		AND A.KodeStore LIKE '%'+ @KodeStore+'%'
		AND C.PUR_GROUP LIKE '%'+ @PG +'%'
	ORDER BY A.Tanggal ASC	

END
GO
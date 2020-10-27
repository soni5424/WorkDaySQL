USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 23.10.20
-- Description	: Excel Sell Out Type Bayar
-- =============================================
Create PROCEDURE EX_PGetSellOutByFKTypeBayar
	@From			datetime,
	@To				datetime,
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
		(SELECT DESCRIPTION FROM SAP_ConfigMerchandiseCategory WHERE C.MATL_GROUP=MC) PG,
		E.KodeJenisPembayaran,
		D.NilaiPembayaran
	FROM 
		TrxFaktur A
		INNER JOIN TrxFakturDetail B ON A.NoFaktur=B.NoFaktur
		INNER JOIN SAP_ARTICLE C ON B.KodeBarang=C.OLD_MAT_NO AND C.SITE='S001'
		INNER JOIN TrxFakturBayar D ON A.NoFaktur=D.NoFaktur
		INNER JOIN (SELECT KodeJenisPembayaran, NamaJenisPembayaran FROM MasterJenisPembayaran 
					UNION
					SELECT KodeKategoriPembayaran AS KodeJenisPembayaran, NamaKategoriPembayaran AS NamaJenisPembayaran 
					from CH_MasterKategoriPembayaran) E ON D.KodeJenisPembayaran=E.KodeJenisPembayaran
	WHERE
		dbo.getonlydate(A.Tanggal) BETWEEN CONVERT(datetime, @From, 103) AND CONVERT(datetime,@To, 103)
		AND A.KodeStore LIKE '%'+ @KodeStore+'%'
		AND C.MATL_GROUP LIKE '%' + @PG +'%'
	ORDER BY A.Tanggal ASC
END
GO
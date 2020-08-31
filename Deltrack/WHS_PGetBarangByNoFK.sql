USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 26.8.20
-- Description	: Get KodeBarang dari FakturDetail
-- =============================================
CREATE PROCEDURE WHS_PGetBarangByNoFK
	@NoFK		varchar(50)
AS
BEGIN
	SELECT DISTINCT 
		RTRIM(A.KodeBarang) AS KodeBarang,
		D.SALES_OFF AS SiteDelivery
	FROM TrxFakturDetail A
		INNER JOIN TrxFaktur B ON A.NoFaktur=B.NoFaktur
		INNER JOIN TrxSOKirim C ON B.NoSO=C.NoSO
		INNER JOIN MasterStore D ON D.KodeStore=C.KodeStoreDepo
    WHERE A.NoFaktur=@NoFK
		AND A.KodeBarang NOT LIKE '%Transport%'
END
GO
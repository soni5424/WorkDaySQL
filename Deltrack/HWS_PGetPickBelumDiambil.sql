USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 28.9.20
-- =============================================
ALTER PROCEDURE HWS_PGetPickBelumDiambil
	@UserID		varchar(10),
	@TglAwal	varchar(10),
	@TglAkhir	varchar(10),
	@ShipPoint	varchar(4),
	@Sloc		varchar(4)
AS
BEGIN
	SELECT 
		A.DO,
		A.Item,
		A.Article,
		A.Sloc,
		CONVERT(varchar(10), A.DeliveryDate, 103) As DeliveryDate,
		A.ShippingPoint,
		A.Shipment,
		A.Faktur
	FROM HWS_PilihZPICK A
		LEFT JOIN HWS_Zpick B ON A.DO=B.DO AND A.Item=B.Item AND A.UserID=B.UserID AND B.DO IS NULL
	WHERE 
		A.StatusPilih=1
		AND A.UserID=@UserID
		AND dbo.getonlydate(A.DeliveryDate) >= CONVERT(Datetime, @TglAwal, 103)
		AND dbo.getonlydate(A.DeliveryDate) <= CONVERT(Datetime, @TglAkhir, 103)
		AND A.ShippingPoint LIKE '%'+@ShipPoint+'%'
		AND A.Sloc LIKE '%'+@Sloc+'%'
	ORDER BY DeliveryDate
END
GO
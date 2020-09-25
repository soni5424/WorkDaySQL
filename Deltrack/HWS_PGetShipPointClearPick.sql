
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 24.9.20
-- Description	: ShipPoint AutoComplete
-- =============================================
Alter PROCEDURE HWS_PGetShipPointClearPick
	@ShipPoint		varchar(4)
AS
BEGIN
	SELECT DISTINCT ShippingPoint AS ShipPoint
	FROM HWS_PilihZPICK 
	WHERE ShippingPoint LIKE @ShipPoint+'%'
END


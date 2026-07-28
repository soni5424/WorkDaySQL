--Table SQL Server - Delivery Tracking (Deltrack) : 
select * from masteruser where KodeBarcode='32100053'

--Get ShippingPoint dari Driver
exec HDS_PGetDriverShippingPoint '3016403'
SELECT * FROM HLS_SetupUserShippingPoint where userid = '3016403'

--Login
exec HDS_CekLogin '','32100053','3016403','8Hkx2v5y8yxRqckxHY1WfsdnaAk='

-- GetJadwalPengiriman
exec HDS_PGetJadwalPengiriman '231129040001','3016403','L 8382 GE'

--GetZRoute
exec HDS_PGetZRoute 'L 8382 GE','3016403'

-- Saat Pengurutan Jadwal (Deltrack) -> INSERT ke table HLS_ZRoute
SELECT top 100 * FROM HLS_ZRoute ORDER BY datetime DESC
SELECT * FROM HLS_ZRoute WHERE SIGNI = 'L 8382 GE' AND shipment = '1398582' ORDER BY datetime DESC
SELECT * FROM HLS_ZRoute WHERE shipment = '1398582' ORDER BY datetime DESC
-- Note : kolom Status ZSHIP harus = 1 (sudah GI)

-- Saat HLS - Update DT -> INSERT ke table HLS_DTShipment :
SELECT top 100 FROM HLS_DTShipment ORDER BY TPDAT DESC
SELECT * FROM HLS_DTShipment WHERE TKNUM = '1089143' ORDER BY TPDAT DESC
-- Note : kolom TPDAT harus tanggal hari itu (misal : 2023-12-12 00:00:00.000) -> agar di Web HDT bisa muncul

-- Saat HLS - Update DT -> INSERT ke table HLS_DTShipmentDelivery : 
SELECT top 100 FROM HLS_DTShipmentDelivery ORDER BY LFDAT DESC
SELECT * FROM HLS_DTShipmentDelivery WHERE TKNUM = '1089143' ORDER BY LFDAT DESC

-- Saat HLS - Update DT -> INSERT ke table HLS_DTShipmentDeliveryDetail :
SELECT top 100 * FROM HLS_DTShipmentDeliveryDetail WHERE VBELN = '2007891537' ORDER BY VBELN desc
SELECT det.* FROM HLS_DTShipmentDeliveryDetail det INNER JOIN HLS_DTShipmentDelivery d ON d.VBELN = det.VBELN WHERE d.TKNUM = '1092949' ORDER BY d.LFDAT DESC



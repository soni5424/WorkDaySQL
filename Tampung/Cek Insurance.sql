SELECT     TOP (1) Tanggal, NoFaktur, NoSOSAP_POS, NoSOSAP, Status, Keterangan, Keterangan1
FROM         SAP_TempSaveData
WHERE     (NoSOSAP_POS = '')
	and tanggal > '2021-05-26 13:47:00.000'
ORDER BY Tanggal DESC
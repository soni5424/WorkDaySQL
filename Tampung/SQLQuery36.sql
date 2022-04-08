select * from TrxSOKirim where noso='02A-07-A13-00280'
SELECT     TOP (200) KodeStoreSO, KodeStoreStock, KodeStoreKirim, StatusSTO, BatasHariKirim, KodeStoreTransit, Status, DropshipAdmin
FROM         SAP_SetupStoreSOSTO
WHERE     (KodeStoreSO = '07') AND (KodeStoreStock = '22') and KodeStoreKirim='20'
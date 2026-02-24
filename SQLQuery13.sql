SELECT     TOP (200) KodeGrupPermission, KodePermission, fCreate, fRead, fUpdate, fDelete, fPrint, fBarcodeRead, rowguid
FROM         GrupToPermission
WHERE     (KodePermission = 'socounterbarangcancelantrian') OR
                      (KodeGrupPermission = 'WHManager')
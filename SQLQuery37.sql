declare @KodePromo varchar(50)
set @KodePromo = '100000162-06'

select * from PR_MasterPromoDetailPotonganHarga where kodepromo=@KodePromo
select * from PR_MasterPromoDetailBarangFree where kodepromo=@KodePromo
select * from PR_MasterPromo where kodepromo=@KodePromo
select * from sap_promo where bonusbuyno=@KodePromo
select * from sap_promolistbuy where bonusbuyno=@KodePromo
select * from sap_promolistget where bonusbuyno=@KodePromo
select * from h_SAP_PromoPOStoMyHartono where kodepromo1=@KodePromo order by modified desc



select distinct top 1000  * FROM SAP_PromoListGet where bonusbuyno='100000162-06'

--exec sap_PAddPromoInterfaceByBonusBuyNo @KodePromo
--exec sap_PAddPromoInterfaceDetailByBonusByNo @KodePromo


--exec MyH_PGetPromoFreeToMyHartono  'HE', 'S001', '01', '100058708-02'
--exec MyH_PGetPromoPotHargaToMyHartono  'HE', 'S001', '01', '100058708-02'


SELECT    KodePromo1, Site, Created, Modified, Status, Message, Req, Resp
FROM         h_SAP_PromoPOStoMyHartono
ORDER BY Created DESC

SELECT   KodePromo1, Site, Created, Modified, Status, Message, Req, Resp
FROM         h_SAP_PromoPOStoMyHartono
where status = 1




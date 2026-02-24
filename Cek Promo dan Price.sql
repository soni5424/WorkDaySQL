select * from PR_MasterPromo where kodepromo='100096843-29'
select * from h_SAP_PromoPOStoMyHartono where kodepromo1='100096843-29' and site='O001' order by created desc
--insert into h_SAP_PromoPOStoMyHartono
select top 1 * from h_SAP_PromoPOStoMyHartono_history where kodepromo1='100096843-29' and site='O001' order by created desc
select * from h_SAP_PromoServToMyHartono_history where kodepromo='100096843-29' and site='O001' order by created desc


select top 100 * from h_SAP_PromoPOStoMyHartono where site='O001' order by created desc
select top 100 * from  h_SAP_PromoServToMyHartono where site='O001' order by created desc

select * from s_SAP_PricePOStoMyHartono where matnr='W-233_BLUE' and werks='O001' order by priceid desc
select * from sap_retail_price_vkp0 where matnr='W-233_BLUE' and werks='O001' order by priceid desc


select * from MasterMember where nomember='01-00097162'
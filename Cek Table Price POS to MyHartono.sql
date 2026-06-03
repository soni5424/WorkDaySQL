-- Cek Table
select top 10 * from [dbo].[h_SAP_PricePOStoMyHartono] order by created desc
select top 10 * from s_SAP_PricePOStoMyHartono where created >= '20260530' order by created desc


-- Hapus Table ini
select top 10 * from [dbo].[h_SAP_PricePOStoMyHartono_history] order by created desc
select top 10 * from h_SAP_PricePOStoMyHartono2 order by created desc


-- 
select dbo.getonlydate(createdHist), count(*) from [dbo].[h_SAP_PricePOStoMyHartono] 
where dbo.getonlydate(createdHist) >= '20260528'
group by dbo.getonlydate(createdHist)
order by dbo.getonlydate(createdHist) desc

select dbo.getonlydate(created), count(*) from s_SAP_PricePOStoMyHartono 
where dbo.getonlydate(created) >= '20260528'
group by dbo.getonlydate(created)
order by dbo.getonlydate(created) desc



select * from sap_retail_price_vkp0 where matnr='SELANGINLET' order by priceid desc
select * from sap_retail_price_vkp0 where matnr='90NB1682-M00810' order by priceid desc

select top 100 * from sap_retail_price_vkp0 
where created < '2026-05-28 10:00:00' and created >= '20260528'
order by modified asc

select dbo.getonlydate(created), count(*) from sap_retail_price_vkp0 
where dbo.getonlydate(created) >= '20260528'
group by dbo.getonlydate(created)
order by dbo.getonlydate(created) desc

select * from sap_article where old_mat_no='SELANGINLET'


select dbo.getonlydate(created), count(*) from s_SAP_PricePOStoMyHartono 
where dbo.getonlydate(created) >= '20260528'
group by dbo.getonlydate(created)
order by dbo.getonlydate(created) desc

select dbo.getonlydate(created), count(*) from sap_retail_price_vkp0 
where dbo.getonlydate(created) >= '20260528'
group by dbo.getonlydate(created)
order by dbo.getonlydate(created) desc
select z_price_tag, created, * from sap_article where z_price_tag is null and created > '20250922' and matl_group not like 'CE%'

select distinct matl_group from sap_article where z_price_tag is null and created > '20250922' 

--update sap_article set z_price_tag = 'LARGE' where z_price_tag is null and created > '20250922' and matl_group like 'CE%'
--update sap_article set z_price_tag = 'SMALL' where z_price_tag is null and created > '20250922' and matl_group like 'CO%'
--update sap_article set z_price_tag = 'SMALL' where z_price_tag is null and created > '20250922' and matl_group like 'KD0702'
--update sap_article set z_price_tag = 'SHA' where z_price_tag is null and created > '20250922' and matl_group in (
--'PC0103',
--'SK0504'
--)
--update sap_article set z_price_tag = 'LARGE' where z_price_tag is null and created > '20250922' and matl_group in (
--'DP0103',
--'EZ0102',
--'KD0416',
--'MK1005',
--'MK1039',
--'OE2054',
--'WG0203'
--)

"LARGE"

select * from sap_retail_price_vkp0 where matnr='SET_K05NSA'

select * from

select top 100 a.created, * from sap_article a order by a.created desc


select lifnr, created, * from sap_article where old_mat_no='WT150F50'

where old_mat_no='AAP-WHSET-IP4_HDH'
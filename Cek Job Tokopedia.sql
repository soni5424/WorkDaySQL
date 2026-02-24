SELECT     TOP (200) MP_ID, Shop_ID, Warehouse_ID, Article, Qty_SAP, Qty_MP, Response, Created_On, Created_By
FROM         HMP_UpdateStock2_Log
ORDER BY Created_On DESC


SELECT     count(*)
FROM         HMP_T_UpdateStock_Status
WHERE     send_to_mp is null

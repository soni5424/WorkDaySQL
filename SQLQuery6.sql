--exec BMS_GetPurchaseInfoData '1002601', '10202', 'M24', '0641', '', '20250806', 'DP01', ';;'
exec BMS_GetPurchaseInfoData '1002601', '10202     ', 'M24', ';0641;', null, '2025-08-06', 'DP01', null


	SELECT a.MATERIAL as 'Article', ISNULL(CONVERT(varchar(20), a.Created, 103), '') as 'CreatedOn', '10202' as 'VendorID',
		   (CASE
				WHEN a.Z_CONSIGMENT = '' THEN 'NORM'
				WHEN a.Z_CONSIGMENT = 'X' THEN 'ZCON'
				WHEN a.Z_CONSIGMENT IS NULL THEN 'NORM'
			END) as 'Status', ISNULL(a.TAX_CODE, '') as 'Tax', ISNULL(pirD.ListRp, 0) as 'OldListRp', 
		   ISNULL(pirD.ListRp, ISNULL(sa.ListRp, (CASE
				WHEN a.Z_CONSIGMENT = '' THEN 0
				WHEN a.Z_CONSIGMENT = 'X' THEN 1
				WHEN a.Z_CONSIGMENT IS NULL THEN 0
			END))) as 'ListRp', ISNULL(pirD.SRP, ISNULL(sa.SRP, 0)) as 'SRP', 
			ISNULL(pirD.Disc1, ISNULL(sa.VRDD1Percent, 0)) as 'Disc1', ISNULL(pirD.Disc1Rp, ISNULL(sa.VRDD1Rp, 0)) as 'Disc1Rp', ISNULL(pirD.RemarkDisc1, ISNULL(sa.VRDD1Remark, '')) as 'RemarkDisc1', 
			ISNULL(pirD.Disc2, ISNULL(sa.VRDD2Percent, 0)) as 'Disc2', ISNULL(pirD.Disc2Rp, ISNULL(sa.VRDD2Rp, 0)) as 'Disc2Rp', ISNULL(pirD.RemarkDisc2, ISNULL(sa.VRDD2Remark, '')) as 'RemarkDisc2', 
			ISNULL(pirD.Disc3, ISNULL(sa.VRDD3Percent, 0)) as 'Disc3', ISNULL(pirD.Disc3Rp, ISNULL(sa.VRDD3Rp, 0)) as 'Disc3Rp', ISNULL(pirD.RemarkDisc3, ISNULL(sa.VRDD3Remark, '')) as 'RemarkDisc3', 
			ISNULL(pirD.DiscPromo, 0) as 'DiscPromo', ISNULL(pirD.DiscPromoRp, 0) as 'DiscPromoRp', ISNULL(pirD.RemarkDiscPromo, '') as 'RemarkDiscPromo', CONVERT(varchar(20), '20250806') as 'ValidFrom',
			ISNULL(pirD.DPP, 0) as 'OldDPP', sa.DPPListRp as 'DPP', 
			ISNULL(pirD.ListRp, ISNULL(sa.ListRp, (CASE
				WHEN a.Z_CONSIGMENT = '' THEN 0
				WHEN a.Z_CONSIGMENT = 'X' THEN 1
				WHEN a.Z_CONSIGMENT IS NULL THEN 0
			END))) as 'OldListRpCheck', ISNULL(pirD.DPP, 0) as 'OldDPPCheck', 0 as 'TotalDisc1', 0 as 'TotalDisc2', 0 as 'TotalDisc3', 0 as 'TotalDiscPromo'
	FROM SAP_ARTICLE a
--	LEFT JOIN MM_SubmitArticle sa ON (sa.Article = a.MATERIAL OR (SUBSTRING(a.MATERIAL, 1, 3) = '000' AND SUBSTRING(a.MATERIAL, PATINDEX('%[^0]%', a.MATERIAL+'.'), LEN(a.MATERIAL)) = sa.Article)) AND sa.Status = 1
--	LEFT JOIN (select x.VendorID, y.Status, z.* from VP_NewArticle x, VP_NewArticleDetail y, VP_NewArticleDetailVRDD z where x.TrxID=y.TrxID and y.Status=1 and y.TrxID=z.TrxID and y.Article=z.Article) sa 
	LEFT JOIN (select x.VendorID, y.TrxID, y.Article, y.Status, z.DiscBasedOn, z.ListRp, z.DPPListRp, z.SRP, z.VRDD1Percent, z.VRDD1Rp, z.VRDD1Total, z.VRDD1Remark, z.VRDD2Percent, z.VRDD2Rp, z.VRDD2Total, z.VRDD2Remark, z.VRDD3Percent, z.VRDD3Rp, z.VRDD3Total, z.VRDD3Remark
				from VP_NewArticle x 
				inner join VP_NewArticleDetail y on x.TrxID=y.TrxID and y.Status=1 
				left join   z on y.TrxID=z.TrxID and y.Article=z.Article) sa 
	ON (sa.Article = a.MATERIAL OR (SUBSTRING(a.MATERIAL, 1, 3) = '000' AND SUBSTRING(a.MATERIAL, PATINDEX('%[^0]%', a.MATERIAL+'.'), LEN(a.MATERIAL)) = sa.Article)) AND sa.Status = 1
	LEFT JOIN FI_SetupPIRDetail pirD ON pirD.Article = a.MATERIAL
	WHERE (a.Pur_Group IN (SELECT PurchasingGroup FROM FI_SetupUserPG WHERE UserID = '1002601' AND Status = 1)) AND
		  (((a.LIFNR IS NULL OR a.LIFNR = '') AND sa.VendorID = '10202') OR a.LIFNR = '10202') AND
		  a.DISCNTIN_IDC = 0 AND a.Site = 'S001' AND 
		  --(@brand IS NULL OR @brand LIKE '%;' + a.BRAND_ID + ';%') AND
		  ('M24' IS NULL OR a.PUR_GROUP = 'M24') AND
		  ('DP01' IS NULL OR LEFT(a.MATL_GROUP, 4) = 'DP01') AND
		  --('' IS NULL OR '' LIKE '%;' + a.MATL_GROUP + ';%') AND
		  a.MATERIAL NOT IN (SELECT DISTINCT Article FROM SAP_ArticleHistory WHERE fieldname = 'mstae' AND newvalue <> '')
	ORDER BY
		CASE
			WHEN a.MATL_GROUP LIKE 'WG01%' THEN a.MATL_DESC
		END ASC,
		a.MATERIAL

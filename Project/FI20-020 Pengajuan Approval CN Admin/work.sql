SELECT A.NoFaktur
FROM CS_TrxPengajuanCNAdmin A
	LEFT JOIN CS_TrxApprovalCNAdmin B ON A.NoPengajuan = B.NoPengajuan
WHERE B.StatusApproval = 1 OR B.StatusApproval IS NULL
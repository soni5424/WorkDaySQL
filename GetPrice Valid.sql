SELECT DISTINCT	
	Matnr AS ArticleCode, 
	VFrom AS TanggalAwal,
	Vto As TanggalAkhir,
	A.KBERT AS ListPrice,
	PriceID
FROM SAP_RETAIL_PRICE_VKP0 A	
WHERE	
	WERKS='O001'
	AND dbo.getonlydate(VFROM) <= dbo.getonlydate(getdate())
	AND dbo.getonlydate(VTO) >= dbo.getonlydate(getdate())
	AND DELINDC IS NULL
	AND Matnr IN (SELECT KodeBarang FROM TTemp)
	AND PriceID IN (
		SELECT MAX(PriceID) 
		from SAP_RETAIL_PRICE_VKP0 
		where dbo.getonlydate(VFROM) <= dbo.getonlydate(getdate()) AND dbo.getonlydate(VTO) >= dbo.getonlydate(getdate()) 
		AND DELINDC IS NULL
		AND Matnr IN (SELECT KodeBarang FROM TTemp)
		AND WERKS='O001'
		group by Matnr
	)
order by matnr asc--, priceid desc
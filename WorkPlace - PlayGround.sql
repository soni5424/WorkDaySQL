	SELECT A.*
	FROM HWS_PilihZPICK A
		--LEFT JOIN HWS_Zpick B ON A.DO=B.DO AND A.Item=B.Item AND A.UserID=B.UserID
	WHERE 
		A.StatusPilih=1
		AND KodeStore<>'00' AND SALES_OFF!=''
		AND SALES_OFF LIKE @Site+'%'

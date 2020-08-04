select A.Nama, A.Nilai, B.Nilai 
from 
	masterparameter A,
	[192.168.9.27].hartono.dbo.Masterparameter B
where 
	A.nama = B.Nama
	AND A.Nilai != B.Nilai

select Nama
from masterparameter 
where Nama NOT IN (SELECT Nama FROM [192.168.9.27].hartono.dbo.Masterparameter)


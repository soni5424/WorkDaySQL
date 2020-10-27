exec PSB_PGetCorrectiveAction2 '1015413', 'Corrective'

select * from MasterUser where kodebarcode='11100085'

SELECT        distinct A.KodeStore, A.UserID, B.NamaUser, C.KodeGrupPermission
FROM            PSB_SetupAksesStoreArea A
			INNER JOIN MasterUser B ON A.UserID=B.UserID  
			LEFT JOIN UserToGrupPermission C ON A.UserID=C.UserID AND C.KodeGrupPermission like '%PSB%'
WHERE        A.KodeStore = '08'

select * from UserToGrupPermission where userid='1002601'


select * from masterstore

KTI		Koe Suryanto 			11300009	1005308
		Catur Widodo 			10000007	
		Gatot					11100070
BDB		Andria Liestiawan		11100082
		Franklin Satria Kusuma	11000013
		Kreshna 				12000030
BGJ		Tommy Nunggala			11100085
		Steven Wijaya			11900029
MSQ	 Stephen Sutanto			11900047
	Paring setiyoko				11100006
MLG	 Agus Iskandar				10800036
	 Diyaat						11100047
SDN	 Didik Harianto				10600017
	Heru Irawan 				11400026
PIN	Sanudin 	11400030
	 Adisa Memor	11000012
BDB, KTI, BGJ, MSQ, SDN, MLG	Jonathan Lie	12000050
PIN	Dicky Raharjo	11100099


select * from MasterParameter where Nama like '%api%'


select * from MyHartono_SetupAPI where nama='UpdateMemberHPC'

exec MyH_PGetSetupAPIMyHartono 'UpdateMemberHPC'

update mastermember set BlackList=0 where NoKartuMember='1212201523678912'
select BlackList, * from mastermember where NoKartuMember='1212201523678912'


exec MyH_PGetSetupAPIMyHartono 'UploadMemberOne'
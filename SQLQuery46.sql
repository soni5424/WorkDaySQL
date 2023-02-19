select top 100 PointRewardTo,* from TrxSO 
where 
	KodeWorkStation like 'a%' 
	and PointRewardTo!=NoMember 
	--and NoMember!='01-00109243'
order by Tanggal desc

select * from MasterMember where NoMember='01-00109243'
select * from MasterMember where NoMember='01-00062683'
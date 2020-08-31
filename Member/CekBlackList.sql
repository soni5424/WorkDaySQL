--no1
exec sap_PGetMember @jenis=1,@NoMember='',@NamaMember='',@NoKartuMember='1212200022842',@TglLahirMember='Jan  1 9999 12:00:00:000AM',@Alamat='',@KTP='' 

	select
		BlackList
		NoMember,
		NamaMember,
		NoKartuMember,
		NoKTP,
		NoSIM,
		TglLahirMember,
		Alamat,
		NoHP
	from
		MasterMember
	where
		NamaMember = 'SRI LESTARI'
		AND NoKartuMember like  '%1212200022842%'
		and TglLahirMember = 'Jan  1 9999 12:00:00:000AM'
		and Alamat like '%'
		and NoKTP like '%'



--no8
	exec sap_PGetMember '8', '', '', '1212121200022842', 1, '', ''
	select
		NoMember,
		NamaMember,
		NoKartuMember,
		NoKTP,
		NoSIM,
		TglLahirMember,
		Alamat,
		NoHP
	from
		MasterMember
	where
		(CustID_KUNNR !='' and CustID_KUNNR is not null)
		and Blacklist = '1'
		and NoKartuMember like '1212121200022842%'
		and NoKTP <> 'xxx'
		and NoKartuMember <> 'xxx'
		and KetBlackList like 'BL Suspend DM |%'--add Suspend Member - Abednego 17/01/2018


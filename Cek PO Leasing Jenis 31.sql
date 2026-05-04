----drop table #trxfakturincluderprbo
----drop table #trxvoidpenjualanrbo
----drop table #trxvoidpenjualanrbo
----drop table #trxfakturrbo
----------------------------- 9.19 ---------------------------

--	select
--		convert(varchar, f.tanggal, 111) as tanggal,
--		f.nofaktur,
--		f.namapenerima,
--		f.alamatpenerima,
--		f.keteranganso,
--		f.totalharga,
--		f.totalpembayaran,
--		f.nomember,
--		i.namamember as namaleasing 
--	--into
--	--	#trxfakturincluderprbo
--	from
--		[192.168.9.19].hartono.dbo.trxfaktur f,
--		[192.168.9.19].hartono.dbo.mastermemberfinance i
--	where
--		f.nomember = i.nomember
--		and convert(varchar, f.Tanggal, 111) >= convert(varchar, '20260301', 111)
--		and convert(varchar, f.Tanggal, 111) < convert(varchar, (dateadd(day, 1, '20260331')), 111)
----DONE #trxfakturincluderprbo
	
--	select 
--		r.noreturpenjualan,
--		r.nofaktur
--	--into
--	--	#trxreturpenjualanrbo
--	from
--		[192.168.9.19].hartono.dbo.trxreturpenjualan r,
--		#trxfakturincluderprbo f
--	where
--		r.nofaktur = f.nofaktur
----DONE #trxreturpenjualanrbo

--	select 
--		r.novoidpenjualan as noreturpenjualan,
--		r.nofaktur
--	--into
--	--	#trxvoidpenjualanrbo
--	from
--		[192.168.9.19].hartono.dbo.trxvoidpenjualan r,
--		#trxfakturincluderprbo f
--	where
--		r.nofaktur = f.nofaktur
----DONE #trxfakturincluderprbo
		
----OPEN #trxfakturincluderprbo
--	select 
--		*
--	--into
--	--	#trxfakturrbo
--	from
--		#trxfakturincluderprbo
--	where
--		nofaktur not in (select nofaktur from #trxreturpenjualanrbo union select nofaktur from #trxvoidpenjualanrbo)
----DONE #trxfakturincluderprbo

		
--	select
--		d.nofaktur,
--		d.kodebarang,
--		d.hargabarang,
--		d.jumlah,
--		d.discount,
--		a.namabarang
--	into 
--		#trxfakturdetailrbo
--	from
--		#trxfakturrbo f,
--		[192.168.9.19].hartono.dbo.trxfakturdetail d,
--		[192.168.9.19].hartono.dbo.masterbarang a
--	where
--		f.nofaktur = d.nofaktur
--		and d.kodebarang = a.kodebarang
----DONE #trxfakturdetailrbo
		
--	select
--		f.tanggal,
--		f.nofaktur,
--		'' as nopoleasing,
--		f.namapenerima,
--		f.alamatpenerima,
--		f.namaleasing,
--		d.kodebarang,
--		d.namabarang,
--		d.jumlah,
--		d.hargabarang,
--		d.discount,
--		f.keteranganso,
--		'Non PPn' as faktur,
--		f.totalharga,
--		f.totalpembayaran,
--		f.totalharga - f.totalpembayaran as sisabayar,
--		'' as pur_group,
--		'' as matl_group
--	into
--		#selloutleasingrbo
--	from
--		#trxfakturrbo f,
--		#trxfakturdetailrbo d
--	where
--		f.nofaktur = d.nofaktur
--	--------------------------- 9.19 ---------------------------

--drop table #trxfakturincluderphe	
--drop table #trxreturpenjualanhe
--drop table #trxfakturhe
--drop table #trxfakturdetailhe
--drop table #masterbaranghe
--drop table #sap_trxfkpoleasing

	--------------------------- 9.27 ---------------------------
--select * from MasterMemberFinance where NoMember = '01-00083761'
--select NoMember, * from TrxFaktur where nofaktur='FK-06-J24-04965'
--	select * 
--	from
--		trxfaktur f,
--		mastermemberfinance i
--	where
--		f.nomember = i.nomember
--		and f.nofaktur = 'FK-06-J24-04965'



	--select
	--	convert(varchar, f.tanggal, 111) as tanggal,
	--	f.nofaktur,
	--	f.namapenerima,
	--	f.alamatpenerima,
	--	f.keteranganso,
	--	f.totalharga,
	--	f.totalpembayaran,
	--	f.nomember,
	--	i.namamember as namaleasing 
	--from
	--	trxfaktur f,
	--	mastermemberfinance i
	--where
	--	f.nomember = i.nomember
	--	and convert(varchar, f.Tanggal, 111) >= convert(varchar, '2026/03/01', 111)
	--	and convert(varchar, f.Tanggal, 111) < convert(varchar, (dateadd(day, 1, '2026/03/31')), 111)




	select * from #trxfakturincluderphe where nofaktur in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by NoFaktur
	
	select 
		r.noreturpenjualan,
		r.nofaktur
	into
		#trxreturpenjualanhe
	from
		trxreturpenjualan r,
		#trxfakturincluderphe f
	where
		r.nofaktur = f.nofaktur
		
	select * from #trxreturpenjualanhe where nofaktur in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by NoFaktur

	select 
		*
	into
		#trxfakturhe
	from
		#trxfakturincluderphe
	where
		nofaktur not in (select nofaktur from #trxreturpenjualanhe)

	select * from #trxfakturhe where nofaktur in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by nofaktur
		
	select
		d.nofaktur,
		d.kodebarang,
		d.hargabarang,
		d.jumlah,
		d.discount
	into 
		#trxfakturdetailhe
	from
		#trxfakturhe f,
		trxfakturdetail d
	where
		f.nofaktur = d.nofaktur

	select * from #trxfakturdetailhe where nofaktur in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by NoFaktur
	
	select distinct
		a.material,
		a.old_mat_no,
		a.matl_group,
		a.pur_group,
		a.matl_desc
	into
		#masterbaranghe
	from
		sap_article a,
		#trxfakturdetailhe d
	where
		a.discntin_idc = 'False'
		and a.old_mat_no = d.kodebarang

	select distinct
		d.nofaktur,
		a.material,
		a.old_mat_no,
		a.matl_group,
		a.pur_group,
		a.matl_desc,
		a.discntin_idc 
	from
		sap_article a,
		#trxfakturdetailhe d
	where
		a.old_mat_no = d.kodebarang
		and d.nofaktur in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by d.nofaktur   
		
	select
		l.nofk,
		l.nopoleasing
	into 
		#sap_trxfkpoleasing
	from
		SAP_TrxFKPOLeasing l,
		#trxfakturhe f
	where
		l.nofk = f.nofaktur		

	select * from #sap_trxfkpoleasing where nofk in (
	'FK-08-C03-05685',
	'FK-06-F86-00320',
	'FK-06-J24-04965',
	'FK-12-K84-06117',
	'FK-06-J24-05115',
	'FK-06-F86-00511',
	'FK-06-F86-00890'
	)
	order by nofk


	select
		f.tanggal,
		f.nofaktur,
		isnull(l.nopoleasing, '') as nopoleasing,
		f.namapenerima,
		f.alamatpenerima,
		f.namaleasing,
		d.kodebarang,
		--a.matl_desc as namabarang,
		d.jumlah,
		d.hargabarang,
		d.discount,
		f.keteranganso,
		'PPn' as faktur,
		f.totalharga,
		f.totalpembayaran,
		f.totalharga - f.totalpembayaran as sisabayar
		--a.pur_group,
		--a.matl_group
	--into
	--	#selloutleasinghe
	from
		#trxfakturhe f
		inner join #trxfakturdetailhe d on f.nofaktur = d.nofaktur
		--inner join #masterbaranghe a on d.kodebarang = a.old_mat_no
		left join #sap_trxfkpoleasing l on l.nofk = f.nofaktur
	where f.nofaktur in (
		'FK-08-C03-05685',
		'FK-06-F86-00320',
		'FK-06-J24-04965',
		'FK-12-K84-06117',
		'FK-06-J24-05115',
		'FK-06-F86-00511',
		'FK-06-F86-00890'
	)
	order by f.NoFaktur

-- DONE #selloutleasinghe		
	--------------------------- 9.27 ---------------------------
	

	select
		x.tanggal,
		x.nofaktur,
		x.nopoleasing,
		x.namapenerima,
		x.alamatpenerima,
		x.namaleasing,
		x.kodebarang,
		x.namabarang,
		x.jumlah,
		x.hargabarang,
		x.discount,
		x.keteranganso,
		x.faktur,
		x.totalharga,
		x.totalpembayaran,
		x.sisabayar,
		x.pur_group,
		x.matl_group
	from
		(select * from #selloutleasingrbo
		UNION
		select * from #selloutleasinghe
		--UNION
		--select * from #selloutleasinghm
		) as x

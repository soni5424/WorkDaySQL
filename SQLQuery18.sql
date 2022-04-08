


select distinct fi.NoFaktur, f.Tanggal, f.NamaPembeli, f.NamaPenerima
		from TrxFaktur f, TrxFakturInsurance fi
		where fi.NoFaktur=f.NoFaktur
		and fi.Tanggal>=cast(convert(varchar(10),dateadd(year,-2,getdate()),112) as datetime)'+
		and fi.NoFaktur like ''%'+@NoFaktur+'%'
		' and f.NamaPembeli like ''%'+@NamaPembeli+'%'' and fi.NoFaktur not in (select nofaktur from trxreturpenjualan) and fi.NoFaktur not in (select nofaktur from trxvoidpenjualan)'+
		' and f.NamaPenerima like ''%'+@NamaPenerima+'%'''
		if @Tanggal!=''
			set @str=@str+' and convert(varchar(8),fi.Tanggal,112)= '''+@TglFilter+''''
		set @str=@str+' order by f.Tanggal desc'

print (@str)
exec (@str)


END


select * from masterparameter












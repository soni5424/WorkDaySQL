declare @NamaSP varchar(100)
set @NamaSP = 'SPPB_PCekKuotaPengiriman'

select * from HIS_SQLHistory 
where Name like '%'+@NamaSP+'%'
order by ModifyDate desc

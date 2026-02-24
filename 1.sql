select * from TrxSOKirim 
where noso in (	select NoSo from TrxFaktur where nofaktur in  (select NoFaktur from CB_LogNotifFaktur))
	and kodestoredepo in ('11')

select NoFaktur from CB_LogNotifFaktur where nofaktur in  ('FK-07-A07-00031', 'FK-07-A39-00022', 'FK-07-A08-00033', 'FK-07-A49-00016')


select * from TrxSOKirim 
where noso in (	select NoSo from TrxFaktur where nofaktur in  ('FK-07-A07-00031', 'FK-07-A39-00022', 'FK-07-A08-00033', 'FK-07-A49-00016'))
	and kodestoredepo in ('11', '20')

select * from TrxSOKirim 
where noso in (	select NoSo from TrxFaktur where nofaktur in  ('FK-07-A73-00027',
'FK-07-A79-00007',
'FK-07-A66-00018',
'FK-07-A77-00015',
'FK-07-A23-00016',
'FK-07-A33-00018',
'FK-07-A11-00020',
'FK-07-A14-00015'
))
	--and kodestoredepo in ('11', '20')

'FK-07-A73-00027',
'FK-07-A79-00007',
'FK-07-A66-00018',
'FK-07-A77-00015',
'FK-07-A23-00016',
'FK-07-A33-00018',
'FK-07-A11-00020',
'FK-07-A14-00015'

select noso, * from TrxFaktur where nofaktur='FK-07-A07-00031'

select Grup, Nama, Nilai from MasterPilihan where grup like '%SendNotifStoreCnC%' order by nilai
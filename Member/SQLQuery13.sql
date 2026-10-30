select sum(totalharga) from TrxFaktur where tanggal >= '20260901' and tanggal < '20261001'



215.217.359.604

select NoSOSAP_SALESDOCUMENT, * from TrxFaktur where nofaktur in (
'FK-01-B15-03348',
'FK-01-B15-03349',
'FK-01-B15-03350',
'FK-01-B15-03351',
'FK-01-B15-03355',
'FK-01-B15-03356'
)


--HPC-100102-439 tidak ada pada table [10.50.5.59].Hartono.dbo.MasterMemberHPC 


select * from VBWMasterMember_PG_HE where nofaktur in (
'FK-01-B15-03348',
'FK-01-B15-03349',
'FK-01-B15-03350',
'FK-01-B15-03351',
'FK-01-B15-03355',
'FK-01-B15-03356'
)


select distinct len(nomember) from VBWMasterMember_PG_HE 


select top 5 * from VBWMasterMember_ALL where no_member_hpc in (
'HCR-030101-001',
'HPC-100102-439'
)



FK-01-B15-03348
FK-01-B15-03349
FK-01-B15-03350
FK-01-B15-03351


select * from TrxReturPenjualan where nofaktur='FK-12-Q25-00594'
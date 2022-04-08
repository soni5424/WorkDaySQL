update SD_DetailPakaiVoucher set NoSO='02B-01-S54-45274',KodeBarang='NAF72MB1WSG',KodeGudang='1005', TanggalPakai='2021-05-24 11:17:32.010',status='1' where NoVoucher='SSF-003002' and NoMember='01-00126103'
update SD_MasterVoucher set Terpakai='1' where NoVoucher='SSF-003002'


update SD_DetailPakaiVoucher set NoSO='FK-04-K64-86379',KodeBarang='PS1200LSJ-B',KodeGudang='1002', TanggalPakai='2021-05-24 11:15:07.120',status='1' where NoVoucher='SSF-003001' and NoMember='04-00011882'
update SD_MasterVoucher set Terpakai='1' where NoVoucher='SSF-003001'


select * from SD_DetailPakaiVoucher where NoVoucher='SSF-003002'

update SD_DetailPakaiVoucher set noso='02B-04-S60-17288' where NoVoucher='SSF-003001' and NoMember='04-00011882'
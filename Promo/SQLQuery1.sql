select * from MasterPromoBarangDetailPakai A
join MasterPromoDiscountDetailBarang  B on A.NoVoucher=B.NoVoucher
where status=1 and statusterpakai=1 and status=1


select distinct OLD_MAT_NO from SAP_ARTICLE where MATL_DESC like '%samsung%LED%32%'

select * from SAP_Promo order by modified desc
select * from SAP_Promo where BonusBuyNo='100000367-02'
select * from PR_MasterPromo where kodepromo='100000367-01'
select * from PR_MasterPromo where kodepromo='100000367-02'
select * from PR_MasterPromoDetailBarangFree where kodepromo='100000367-01'
select * from PR_MasterPromoDetailBarangUtama where kodepromo='100000367-01'
select * from PR_MasterPromoDetailJenisPembayaran where kodepromo='100000367-01'

select * from CH_MasterJenisPembayaran where KodeJenisSAP in (
'C005',
'C006',
'C012',
'C034',
'C042',
'C046',
'C047',
'C048',
'C049',
'C057',
'C060',
'C065',
'C066',
'C072',
'C083',
'C084',
'C085',
'C092',
'C093',
'C099',
'C101',
'C105',
'C106',
'C109',
'C110',
'C111'
)

select * from CH_MasterJenisPembayaran where KodeJenisSAP in (
'D001','D002','D003','D008','O002','O003'
)


100000367-01, 100000367-02

@kodejenispembayaranbb
select isnull((
	select *
	from CH_MasterJenisPembayaran 
	where KodeJenisSAP = substring(@Article, 4, len(@Article))), '')

				select *,substring(ArticleGet, 4, len(ArticleGet))
				from SAP_PromoListGet
				where BonusBuyNo='100000367-02'


				SAP_PromoListGet 

select * from SAP_Promo where BonusBuyNo='100000367-02'

select * 
from PR_MasterPromoDetailJenisPembayaran 
where 
	KodePromo1 = '100000367-02'
	and KodePromo2 = substring(cast(@intBBFlag as varchar(11)), 1, 9) + '-' + substring(cast(@intBBFlag as varchar(11)), 10, 2) 
	and KodeJenisPembayaran = @kodejenispembayaranbb




	exec TB_PGetJenisPembayaranTipeBayar 


select * from CH_MasterJenisPembayaran
select * from MasterJenisPembayaran where kode
select * from  CH_MasterKategoriPembayaran

exec TipeBayar_GetPromoTipeBayar '100000367-01'
exec RioTipeBayar_GetPromoTipeBayar  '100000367-01', 0
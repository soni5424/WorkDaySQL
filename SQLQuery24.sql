exec MyH_PGetPromoFreeToMyHartonoSite2 'HE', '100082143-01'
exec MyH_PGetPromoPotHargaToMyHartonoSite2 'HE', '100082143-01'


select * from PR_MasterPromo where kodepromo='100082143-01'

select * from h_SAP_PromoPOStoMyHartono where kodepromo1='100082143-01'
select * from PR_MasterPromoDetailBarangFree where kodepromo='100082143-01'


SELECT * FROM dbo.PR_MasterPromoDetailBarangFree
WHERE ((JenisNilai = 'IDR') OR ((JenisNilai = '%') AND (PotonganVPR <> 100)))
	and kodepromo='100082143-01'
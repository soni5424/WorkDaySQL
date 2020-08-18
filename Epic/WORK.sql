
exec SA_PCekMCSiteSama 'ESV05CRC', 'ESV05CRCA1E'

select * from masterstore where kodestore='12'

exec WEB_PGetBatasHariKirim '12', '01'

	SELECT *
	FROM SAP_SetupStoreSOSTO
	WHERE KodeStoreSO = '07'
	AND KodeStoreStock = '12'
	AND KodeStoreKirim = '01'


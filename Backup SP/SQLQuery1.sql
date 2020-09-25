			
	---------- HE ----------
	-- Promo Per Barang

	DECLARE @HargaPOS	DECIMAL(18,2)

	SELECT TOP 1 @HargaPOS = KBERT
	FROM SAP_RETAIL_PRICE_VKP0
	WHERE WERKS = 'Q001'
	AND VTWEG = '10'
	AND VFROM <= dbo.getonlydate(GETDATE())
	AND VTO >= dbo.getonlydate(GETDATE())
	AND MATNR = (
		SELECT MATERIAL
		FROM SAP_Article
		WHERE OLD_MAT_NO =  'G4010'
		AND SITE = 'Q001'
	)
	ORDER BY PRICEID DESC

	SELECT p.KodePromo, pph.Jumlah, pph.JenisNilai, p.JumlahPromo, pt.JumlahPromoTerpakai, pbu.KodeBarang, p.KeteranganSO, p.LongDesc5,
		CASE 
			WHEN pph.JenisNilai = '%' THEN 
				pph.Jumlah * (SELECT TOP 1 KBERT FROM SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = pbu.KodeBarang ORDER BY PRICEID DESC) / 100 
			ELSE pph.Jumlah 
		END AS JumlahPotongan,
		CASE WHEN EXISTS(SELECT Jenis_MP FROM MP_MasterMarketplace WHERE CHARINDEX(Jenis_MP, p.KeteranganSO) > 0) THEN 1 ELSE 0 END AS MPPromo
	--INTO #AllPromo
	FROM PR_MasterPromo p,
	PH_MasterPromoDetailStore ps,
	PR_MasterPromoDetailPotonganHarga pph,
	PR_MasterPromoDetailBarangUtama pbu,
	[192.168.20.1\SQLPOS].Hartono.dbo.PR_MasterPromoTerpakai pt
	WHERE p.KodePromo = ps.KodePromo
	AND ps.KodeStore = '10'
	AND p.Status = ''
	AND p.KodePromo = pbu.KodePromo
	AND p.KodePromo = pt.KodePromo
	AND p.CustType != 'ZC03'
	AND p.KodePromo = pph.KodePromo
	AND pbu.KodeBarang != ''
	AND pbu.Jumlah = 1
	AND DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) >= p.TanggalAwal
	AND DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= p.TanggalAkhir
	AND (p.JumlahPromo = 0 OR (p.JumlahPromo > 0 AND p.JumlahPromo > pt.JumlahPromoTerpakai))
	AND p.LimitByCustomer <> 1
	AND p.Monday <> 'X'
	AND p.Tuesday <> 'X'
	AND p.Wednesday <> 'X'
	AND p.Thursday <> 'X'
	AND p.Friday <> 'X'
	AND p.Saturday <> 'X'
	AND p.Sunday <> 'X'
	and pbu.KodeBarang= 'G4010'
	--ORDER BY JumlahPotongan DESC, DESC
	ORDER BY
		CASE WHEN pph.JenisNilai = '%' THEN pph.Jumlah * @HargaPOS / 100 
		ELSE pph.Jumlah 
		END DESC,
		MPPromo DESC


	-- Article Marketplace
	SELECT SKU, MBM.Kode_MP, KodeBrgInsurance, Ongkir, Margin, FLAG_IT, HE_HM, Discontinue,MM.FLAG_STOK_JKT,
		COALESCE((SELECT TOP 1 KBERT FROM SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = MBM.SKU ORDER BY PRICEID DESC), 0) AS Harga_POS,
		COALESCE((SELECT TOP 1 KBERT FROM SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = MBM.KodeBrgInsurance ORDER BY PRICEID DESC), 0) AS Harga_Insurance,
		COALESCE(CASE
			WHEN MM.FLAG_STOK_JKT = 'X' THEN (SELECT SUM(ATP_QUAN) FROM MyHartono_ATPDATA_Temp WHERE MATNR = MBM.SKU AND WERKS + LGORT IN (SELECT Nilai FROM MasterPilihan WHERE Grup = 'MPGudangStokJKT'))
			ELSE (SELECT SUM(ATP_QUAN) FROM MyHartono_ATPDATA_Temp WHERE MATNR = MBM.SKU AND WERKS + LGORT IN (SELECT Nilai FROM MasterPilihan WHERE Grup = 'MPGudangStok'))
		END, 0) AS Stok
	INTO #ArticleMarketplace
	FROM MP_MasterBarangMarketplace MBM
	LEFT JOIN MP_MasterMarketplace MM ON MBM.Kode_MP = MM.Kode_MP
	WHERE HE_HM = 'HE'
	AND Discontinue = ''

	-- Result
	SELECT AM.*,
		AP.KodePromo, COALESCE(AP.Jumlah, 0) AS Jumlah, AP.JenisNilai, COALESCE(AP.JumlahPromo, 0) AS JumlahPromo, COALESCE(AP.JumlahPromoTerpakai, 0) AS JumlahPromoTerpakai, AP.KodeBarang, AP.KeteranganSO,
		CASE
			WHEN AP.JenisNilai = 'IDR' THEN AM.Harga_POS - AP.Jumlah
			WHEN AP.JenisNilai = '%' THEN AM.Harga_POS - (AM.Harga_POS * AP.Jumlah / 100)
			ELSE AM.Harga_POS
		END AS HargaPotong,
		CASE WHEN AM.FLAG_IT = 'X' THEN
			CASE WHEN AM.Stok <= 2 THEN 0
				 WHEN AM.Stok >= 3 AND AM.Stok <10 THEN AM.Stok
				 WHEN AM.Stok >= 10 THEN 10 END
		WHEN AM.FLAG_IT = '' THEN
			CASE WHEN AM.Stok < 10 THEN 0
				 WHEN AM.Stok >= 10 THEN 5 END
		END AS Stok_MP
	INTO #Result
	FROM #ArticleMarketplace AM
	LEFT JOIN #AllPromo AP ON AM.SKU = AP.KodeBarang AND AP.KodePromo = (
		SELECT TOP 1 KodePromo
		FROM #AllPromo
		WHERE AM.SKU = KodeBarang
		AND (AP.LongDesc5 = '<' + (SELECT Jenis_MP FROM MP_MasterMarketplace WHERE Kode_MP = AM.Kode_MP) + '>' OR AP.LongDesc5 = '')
	)

	-- Transaction
	INSERT INTO MP_UpdateHargaDanStok
	SELECT SKU, Kode_MP, GETDATE() AS Tanggal, Harga_POS, ISNULL(KodePromo, '') AS KodePromo, ISNULL(Jumlah, 0) AS Potongan, ISNULL(JenisNilai, 'IDR') AS JenisNilai, HargaPotong, KodeBrgInsurance, Harga_Insurance, Ongkir, Margin,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 AS Harga_MP,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100 AS Diskon,
		CEILING((
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 +
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100) / 1000
		) * 1000 AS Harga_Coret,
		Stok,
		CASE WHEN JumlahPromo > 0 THEN
			CASE WHEN Stok_MP >= JumlahPromo - JumlahPromoTerpakai THEN JumlahPromo - JumlahPromoTerpakai
			ELSE Stok_MP END
		ELSE Stok_MP
		END AS Stok_MP,
		'1'
	FROM #Result
	
	INSERT INTO MP_HistoryHargaDanStok
	SELECT SKU, Kode_MP, GETDATE() AS Tanggal, Harga_POS, ISNULL(KodePromo, '') AS KodePromo, ISNULL(Jumlah, 0) AS Potongan, ISNULL(JenisNilai, 'IDR') AS JenisNilai, HargaPotong, KodeBrgInsurance, Harga_Insurance, Ongkir, Margin,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 AS Harga_MP,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100 AS Diskon,
		CEILING((
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 +
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100) / 1000
		) * 1000 AS Harga_Coret,
		Stok,
		CASE WHEN JumlahPromo > 0 THEN
			CASE WHEN Stok_MP >= JumlahPromo - JumlahPromoTerpakai THEN JumlahPromo - JumlahPromoTerpakai
			ELSE Stok_MP END
		ELSE Stok_MP
		END AS Stok_MP
	FROM #Result
	
	DROP TABLE #AllPromo
	DROP TABLE #ArticleMarketplace
	DROP TABLE #Result

	---------- HM ----------
	-- Promo Per Barang
	SELECT p.KodePromo, pph.Jumlah, pph.JenisNilai, p.JumlahPromo, pt.JumlahPromoTerpakai, pbu.KodeBarang, p.KeteranganSO, p.LongDesc5,
		CASE WHEN pph.JenisNilai = '%' THEN pph.Jumlah * (SELECT TOP 1 KBERT FROM [192.168.9.28].Hartono.dbo.SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = pbu.KodeBarang ORDER BY PRICEID DESC
) / 100 ELSE pph.Jumlah END AS JumlahPotongan,
		CASE WHEN EXISTS(SELECT Jenis_MP FROM MP_MasterMarketplace WHERE CHARINDEX(Jenis_MP, p.KeteranganSO) > 0) THEN 1 ELSE 0 END AS MPPromo
	INTO #AllPromoHM
	FROM [192.168.9.28].Hartono.dbo.PR_MasterPromo p,
	[192.168.9.28].Hartono.dbo.PH_MasterPromoDetailStore ps,
	[192.168.9.28].Hartono.dbo.PR_MasterPromoDetailPotonganHarga pph,
	[192.168.9.28].Hartono.dbo.PR_MasterPromoDetailBarangUtama pbu,
	[192.168.20.1\SQLHM].Hartono.dbo.PR_MasterPromoTerpakai pt
	WHERE p.KodePromo = ps.KodePromo
	AND ps.KodeStore = '10'
	AND p.Status = ''
	AND p.KodePromo = pbu.KodePromo
	AND p.KodePromo = pt.KodePromo
	AND p.CustType != 'ZC03'
	AND p.KodePromo = pph.KodePromo
	AND pbu.KodeBarang != ''
	AND pbu.Jumlah = 1
	AND DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) >= p.TanggalAwal
	AND DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) <= p.TanggalAkhir
	AND (p.JumlahPromo = 0 OR (p.JumlahPromo > 0 AND p.JumlahPromo > pt.JumlahPromoTerpakai))
	AND p.LimitByCustomer <> 1
	AND p.Monday <> 'X'
	AND p.Tuesday <> 'X'
	AND p.Wednesday <> 'X'
	AND p.Thursday <> 'X'
	AND p.Friday <> 'X'
	AND p.Saturday <> 'X'
	AND p.Sunday <> 'X'
	ORDER BY JumlahPotongan DESC, MPPromo DESC

	-- Article Marketplace
	SELECT SKU, MBM.Kode_MP, KodeBrgInsurance, Ongkir, Margin, FLAG_IT, HE_HM, Discontinue,MM.FLAG_STOK_JKT,
		COALESCE((SELECT TOP 1 KBERT FROM [192.168.9.28].Hartono.dbo.SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = MBM.SKU ORDER BY PRICEID DESC), 0) AS Harga_POS,
		COALESCE((SELECT TOP 1 KBERT FROM [192.168.9.28].Hartono.dbo.SAP_RETAIL_PRICE_VKP0 WHERE WERKS = 'Q001' AND VTWEG = '10' AND VFROM <= GETDATE() AND VTO >= GETDATE() AND MATNR = MBM.KodeBrgInsurance ORDER BY PRICEID DESC), 0) AS Harga_Insurance,
		COALESCE(CASE
			WHEN MM.FLAG_STOK_JKT = 'X' THEN (SELECT SUM(ATP_QUAN) FROM [192.168.9.28].Hartono.dbo.MyHartono_ATPDATA_Temp WHERE MATNR = MBM.SKU AND WERKS + LGORT IN (SELECT Nilai FROM MasterPilihan WHERE Grup = 'MPGudangStokJKT'))
			ELSE (SELECT SUM(ATP_QUAN) FROM [192.168.9.28].Hartono.dbo.MyHartono_ATPDATA_Temp WHERE MATNR = MBM.SKU AND WERKS + LGORT IN (SELECT Nilai FROM MasterPilihan WHERE Grup = 'MPGudangStok'))
		END, 0) AS Stok
	INTO #ArticleMarketplaceHM
	FROM MP_MasterBarangMarketplace MBM
	LEFT JOIN MP_MasterMarketplace MM ON MBM.Kode_MP = MM.Kode_MP
	WHERE HE_HM = 'HM'
	AND Discontinue = ''

	-- Result
	SELECT AM.*,
		AP.KodePromo, COALESCE(AP.Jumlah, 0) AS Jumlah, AP.JenisNilai, COALESCE(AP.JumlahPromo, 0) AS JumlahPromo, COALESCE(AP.JumlahPromoTerpakai, 0) AS JumlahPromoTerpakai, AP.KodeBarang, AP.KeteranganSO,
		CASE
			WHEN AP.JenisNilai = 'IDR' THEN AM.Harga_POS - AP.Jumlah
			WHEN AP.JenisNilai = '%' THEN AM.Harga_POS - (AM.Harga_POS * AP.Jumlah / 100)
			ELSE AM.Harga_POS
		END AS HargaPotong,
		CASE WHEN AM.FLAG_IT = 'X' THEN
			CASE WHEN AM.Stok <= 2 THEN 0
				 WHEN AM.Stok >= 3 AND AM.Stok <10 THEN AM.Stok
				 WHEN AM.Stok >= 10 THEN 10 END
		WHEN AM.FLAG_IT = '' THEN
			CASE WHEN AM.Stok < 10 THEN 0
				 WHEN AM.Stok >= 10 THEN 5 END
		END AS Stok_MP
	INTO #ResultHM
	FROM #ArticleMarketplaceHM AM
	LEFT JOIN #AllPromoHM AP ON AM.SKU = AP.KodeBarang AND AP.KodePromo = (
		SELECT TOP 1 KodePromo
		FROM #AllPromoHM
		WHERE AM.SKU = KodeBarang
		AND (AP.LongDesc5 = '<' + (SELECT Jenis_MP FROM MP_MasterMarketplace WHERE Kode_MP = AM.Kode_MP) + '>' OR AP.LongDesc5 = '')
	)

	-- Transaction
	INSERT INTO MP_UpdateHargaDanStok
	SELECT SKU, Kode_MP, GETDATE() AS Tanggal, Harga_POS, ISNULL(KodePromo, '') AS KodePromo, ISNULL(Jumlah, 0) AS Potongan, ISNULL(JenisNilai, 'IDR') AS JenisNilai, HargaPotong, KodeBrgInsurance, Harga_Insurance, Ongkir, Margin,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 AS Harga_MP,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100 AS Diskon,
		CEILING((
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 +
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100) / 1000
		) * 1000 AS Harga_Coret,
		Stok,
		CASE WHEN JumlahPromo > 0 THEN
			CASE WHEN Stok_MP >= JumlahPromo - JumlahPromoTerpakai THEN JumlahPromo - JumlahPromoTerpakai
			ELSE Stok_MP END
		ELSE Stok_MP
		END AS Stok_MP,
		'1'
	FROM #ResultHM
	
	INSERT INTO MP_HistoryHargaDanStok
	SELECT SKU, Kode_MP, GETDATE() AS Tanggal, Harga_POS, ISNULL(KodePromo, '') AS KodePromo, ISNULL(Jumlah, 0) AS Potongan, ISNULL(JenisNilai, 'IDR') AS JenisNilai, HargaPotong, KodeBrgInsurance, Harga_Insurance, Ongkir, Margin,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 AS Harga_MP,
		CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100 AS Diskon,
		CEILING((
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 +
			CEILING((HargaPotong + (HargaPotong * Margin / 100) + Ongkir + Harga_Insurance) / 1000 ) * 1000 * 8 / 100) / 1000
		) * 1000 AS Harga_Coret,
		Stok,
		CASE WHEN JumlahPromo > 0 THEN
			CASE WHEN Stok_MP >= JumlahPromo - JumlahPromoTerpakai THEN JumlahPromo - JumlahPromoTerpakai
			ELSE Stok_MP END
		ELSE Stok_MP
		END AS Stok_MP
	FROM #ResultHM

	DROP TABLE #AllPromoHM
	DROP TABLE #ArticleMarketplaceHM
	DROP TABLE #ResultHM
END


USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[PTAG_PGetPriceTagForPrintPOSBaru_Init]    Script Date: 07/04/2022 14:56:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================

create PROCEDURE [dbo].[PTAG_PGetPriceTagForPrintPOSBaru_Init]
	@KodeStore varchar(2)
AS
begin
DECLARE 
@KodeBarang varchar(20),
@HargaBarangUtama decimal(18,2),
@TanggalUpload datetime

	DECLARE db_cursor CURSOR FOR 
	SELECT TOP 500 KodeBarang FROM MasterPriceTagBaru_TempArticle WHERE Status = '0' AND KodeStore = @KodeStore

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @KodeBarang

	WHILE @@FETCH_STATUS = 0  
	BEGIN 
		select * 
		into #temphargabarangutama
		from(
			select 
			top 1 
			v.matnr,
			v.kbert
			from 
			sap_retail_price_vkp0 v,
			SAP_Article x,
			masterstore y
			where 
			v.matnr = x.material
			and v.vfrom <= getdate() 
			and getdate()-1 < v.vto
			and v.delindc is null
			and v.werks = x.site
			and x.discntin_idc = 'False'
			and x.old_mat_no = @KodeBarang
			and x.site = y.sales_off
			and y.kodestore = @KodeStore
			and matnr=@KodeBarang
			order by 
			v.priceid desc)A


		SET @HargaBarangUtama = (select kbert from #temphargabarangutama)

		SELECT *
		INTO #Promo
		FROM(
		select
			p.KodePromo,
			h.jumlah,
			u.jumlah as jumlahbrgutama,
			h.jenisnilai,
			p.status,
			u.keterangancheck,
			u.kodebarang,
			x.kodestore,
			p.TanggalAkhir TanggalAkhirPromoReguler,
			y.TanggalAkhir TanggalAkhirPromoNCC,
			ISNULL(KodeJenisPembayaran,'')KodeJenisPembayaran,
			CASE 
				when h.jenisnilai = 'IDR' and u.jumlah = 1 then isnull(@HargaBarangUtama,0) - h.jumlah 
				when h.jenisnilai = '%' and u.jumlah = 1 then isnull(@HargaBarangUtama,0) - (isnull(@HargaBarangUtama,0)*h.jumlah/100) 
				else isnull(@HargaBarangUtama,0) 
			END AS HargaSetelahDiscount
			from
			pr_masterpromo p
			join pr_masterpromodetailbarangutama u on p.kodepromo = u.kodepromo
			join pr_masterpromodetailpotonganharga h on p.kodepromo = h.kodepromo
			join ph_masterpromodetailstore x on p.kodepromo = x.kodepromo
			left join PR_MasterPromoDetailJenisPembayaran y on y.KodePromo2=p.KodePromo and y.tanggalawal <= getdate() and getdate()-1 < y.tanggalakhir
			and kodejenispembayaran in
			(
			SELECT
			 KodeJenisPembayaran
			FROM
				 MasterJenisPembayaran
			WHERE
				 (KodeJenisPembayaran <> 'DPR' OR KodeJenisPembayaran <> 'RPVBB' OR KodeJenisPembayaran <> 'TTP' OR KodeJenisPembayaran <> 'VBB')
			AND  
				 (KodeJenisPembayaran NOT IN (SELECT KodeJenisPembayaran FROM MB_MasterJenisPembayaranLama))
			AND (KodeJenisPembayaran NOT IN (SELECT DISTINCT
				 KodeJenisPembayaran FROM CH_SetupJenisPembayaranCard WHERE JenisCredit <> '')
			))

			where
			x.kodestore = @KodeStore
			and p.tanggalawal <= getdate()
			and getdate()-1 < p.tanggalakhir
			--and y.tanggalawal <= getdate()
			--and getdate()-1 < y.tanggalakhir
			and p.status = ''
			and u.statusberhenti = 'False'
			and u.keterangancheck = 'CIP'
			and u.kodebarang = @KodeBarang
			and h.jenisnilai is not null
			and p.JumlahPromo = 0
			and p.Monday='' and p.Tuesday='' and p.Wednesday='' and p.Thursday='' and p.Friday='' and p.Saturday='' and p.Sunday=''
			)A

		--select * from #Promo

		select * 
		into #result
		from
		(
		select top 1 *, 
		case when Harga > 500000 and (CicilanMember ='1' or CicilanMix='1' or CicilanPL='1') then (Harga/6)
		ELSE 0
		END AS HargaCicilan,
		case when Harga > 500000 and (CicilanMember ='1' or CicilanMix='1' or CicilanPL='1') then '1'
		when (Harga <= 500000 and CicilanMix='1') then '2'
		ELSE '0'
		END AS CekCicilan,
		coalesce(dbo.fGetHargaInsuranceBarang(KodeBarang,Harga),-1) as PaketPerlindungan,
		ISNULL((SELECT CONVERT(varchar(20),MIN(TanggalAkhir),103) FROM
		(
				select TanggalAkhirPromoReguler TanggalAkhir
				union all
				select TanggalAkhirPromoNCC TanggalAkhir
				union all
				select TanggalAkhirCicilanPL TanggalAkhir
				union all
				select TanggalAkhirCicilanMember TanggalAkhir
				union all 
				select TanggalAkhirCicilanMix TanggalAkhir
				union all
				select TanggalAkhirVKP0 TanggalAkhir
		)A
		where TanggalAkhir is not null
		),'')TanggalBerlaku
		from(
		select
			a.KodeBarang,
			b.matl_desc as NamaBarang,
			b.brand_name as MerkBarang,
			b.MATL_DESC as ShortDescription,
			g.description as KodeSubJenis,
			b.longtext as KeteranganBarang, 
			'' as ketpromo,
			--coalesce(dbo.fGetHargaInsuranceBarang(a.KodeBarang,a.HargaDisplay),-1) as PaketPerlindungan,
			0 as HargaDisplay,
			0 as HargaBestPrice,
			--isnull(c.kbert, 0) as Harga,
			case when b.z_insurance='X' then 1 else 0 end as BestPrice,
			case when e.kodebarang is not null and isnull(c.kbert,0) > 500000 then 1 else 0 end as CicilanMember,
			e.TanggalAkhir TanggalAkhirCicilanMember,
			a.KodeStore, 
			isnull((case 
					when d.jenisnilai = 'IDR' and d.jumlahbrgutama = 1 then d.jumlah 
					when d.jenisnilai = '%' and d.jumlahbrgutama = 1 then cast(d.jumlah as varchar(10)) 
					else 0 
					end), 0) as Cashback,
			isnull((case 
					when d.jenisnilai = 'IDR' then 'Rp' 
					when d.jenisnilai = '%' then '%' 
					else '' 
					end), '') as JenisCB,
			isnull((case 
					when d.jenisnilai = 'IDR' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - d.jumlah 
					when d.jenisnilai = '%' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - (isnull(c.kbert,0)*d.jumlah/100) 
					else isnull(c.kbert,0) 
					end), 0) as Harga,
			isnull((case 
					when h.jenisnilai = 'IDR' and h.jumlahbrgutama = 1 then isnull(c.kbert,0) - h.jumlah 
					when h.jenisnilai = '%' and h.jumlahbrgutama = 1 then isnull(c.kbert,0) - (isnull(c.kbert,0)*h.jumlah/100)
					when d.jenisnilai = 'IDR' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - d.jumlah 
					when d.jenisnilai = '%' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - (isnull(c.kbert,0)*d.jumlah/100)  
					else isnull(c.kbert,0) 
					end), 0) as SpecialPrice,
			case when f.kodebarang is not null then 1 else 0 end as CicilanPL,
			f.TanggalAkhir TanggalAkhirCicilanPL,
			isnull((case 
					when d.jenisnilai = 'IDR' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - d.jumlah + isnull(dbo.fGetHargaInsuranceBarangAllInOnePrice(a.KodeBarang,a.HargaDisplay),0) 
					when d.jenisnilai = '%' and d.jumlahbrgutama = 1 then isnull(c.kbert,0) - (isnull(c.kbert,0)*d.jumlah/100) + isnull(dbo.fGetHargaInsuranceBarangAllInOnePrice(a.KodeBarang,a.HargaDisplay),0) 
					else isnull(c.kbert,0) + isnull(dbo.fGetHargaInsuranceBarangAllInOnePrice(a.KodeBarang,a.HargaDisplay),0) 
					end), 0) as AllInOnePrice,
		isnull(dbo.fGetHargaInsuranceBarangAllInOnePrice(a.KodeBarang,a.HargaDisplay),0) AS x,
		a.KodeBarang AS y,
		a.HargaDisplay AS z,
		case when i.kodebarang is not null then 1 else 0 end as CicilanMix,
		i.TanggalAkhir TanggalAkhirCicilanMix,
		d.TanggalAkhirPromoReguler,
		h.TanggalAkhirPromoNCC,
		ISNULL(d.KodePromo,'') KodePromoReguler,
		ISNULL(h.KodePromo,'') KodePromoNCC,
		c.vto TanggalAkhirVKP0 
		FROM 
			MasterPriceTag a 
			inner join SAP_Article b on a.KodeBarang = b.old_mat_no
			inner join MasterStore s on a.KodeStore = s.KodeStore and b.Site = s.sales_off
			inner join SAP_ConfigMerchandiseCategory g on b.matl_group = g.mc
			left join (select top 1 
							v.matnr,
							v.kbert,
							v.vto
						from 
							sap_retail_price_vkp0 v,
							SAP_Article x,
							masterstore y
						where 
							v.matnr = x.material 
							and v.vfrom <= getdate() 
							and getdate()-1 < v.vto
							and v.delindc is null
							and v.werks = x.site
							and x.discntin_idc = 'False'
							and x.old_mat_no = @KodeBarang
							and x.site = y.sales_off
							and y.kodestore = @KodeStore
						order by 
							v.priceid desc) as c on b.material = c.matnr
			left join (select top 1
							KodePromo,
							jumlah,
							jumlahbrgutama,
							jenisnilai,
							status,
							keterangancheck,
							kodebarang,
							kodestore,
							TanggalAkhirPromoReguler,
							TanggalAkhirPromoNCC  
						from
							#Promo
						where KodeJenisPembayaran =''
						order by
							HargaSetelahDiscount asc) as d ON a.KodeBarang = d.KodeBarang and a.KodeStore = d.KodeStore
			left join (select top 1
							KodeBarang,TanggalAkhir 
						from 
							MB_MasterBarangCicilanMember
						where 
							tanggalawal <= getdate()
							and getdate()-1 < tanggalakhir
							and KodeBarang = @KodeBarang
						order by
							tanggalakhir desc) as e on a.KodeBarang = e.KodeBarang
			left join (select top 1
							KodeBarang,TanggalAkhir
						from
							MKT_MasterBarangCicilanReguler 
						where 
							tanggalawal < getdate()
							and getdate()-1 < tanggalakhir
							and KodeBarang = @KodeBarang
						order by
							tanggalakhir desc) as f on a.KodeBarang = f.KodeBarang
			left join (select top 1
							jumlah,
							jumlahbrgutama,
							jenisnilai,
							status,
							keterangancheck,
							kodebarang,
							kodestore,
							TanggalAkhirPromoReguler,
							TanggalAkhirPromoNCC,
							KodePromo  
						from
							#Promo
						where KodeJenisPembayaran <>''
						order by
							HargaSetelahDiscount asc) as h ON a.KodeBarang = h.KodeBarang and a.KodeStore = h.KodeStore
			left join (select top 1
							KodeBarang,TanggalAkhir
						from
							PR_MasterCicilanTotalDetailBarang
						where 
							tanggalawal < getdate()
							and getdate()-1 < tanggalakhir
							and KodeBarang = @KodeBarang
							and statuspromo=''
						order by
							tanggalakhir desc) as i on a.KodeBarang = i.KodeBarang
		where
			a.KodeStore = @KodeStore
			and a.KodeBarang = @KodeBarang
			and b.discntin_idc = 'False'
		)a
		order by a.Harga asc)b

		-- Updated by Anton 29/03/2022
		-- Simpan pricetag ke table
		SET @TanggalUpload = (SELECT GETDATE())

		IF EXISTS (SELECT * FROM MasterPriceTagBaru WHERE KodeBarang = @KodeBarang and KodeStore = @KodeStore)
			BEGIN
				UPDATE
					MasterPriceTagBaru 
				SET
					KodeBarang = TempResult.KodeBarang,
					NamaBarang = TempResult.NamaBarang,
					MerkBarang = TempResult.MerkBarang,
					ShortDescription = TempResult.ShortDescription,
					KodeSubJenis = TempResult.KodeSubJenis,
					KeteranganBarang = TempResult.KeteranganBarang,
					ketpromo = TempResult.ketpromo,
					HargaDisplay = TempResult.HargaDisplay,
					HargaBestPrice = TempResult.HargaBestPrice,
					BestPrice = TempResult.BestPrice,
					CicilanMember = TempResult.CicilanMember,
					TanggalAkhirCicilanMember = TempResult.TanggalAkhirCicilanMember,
					KodeStore = TempResult.KodeStore,
					Cashback = TempResult.Cashback,
					JenisCB = TempResult.JenisCB,
					Harga = TempResult.Harga,
					SpecialPrice = TempResult.SpecialPrice,
					CicilanPL = TempResult.CicilanPL,
					TanggalAkhirCicilanPL = TempResult.TanggalAkhirCicilanPL,
					AllInOnePrice = TempResult.AllInOnePrice,
					x = TempResult.x,
					y = TempResult.y,
					z = TempResult.z,
					CicilanMix = TempResult.CicilanMix,
					TanggalAkhirCicilanMix = TempResult.TanggalAkhirCicilanMix,
					TanggalAkhirPromoReguler = TempResult.TanggalAkhirPromoReguler,
					TanggalAkhirPromoNCC = TempResult.TanggalAkhirPromoNCC,
					KodePromoReguler = TempResult.KodePromoReguler,
					KodePromoNCC = TempResult.KodePromoNCC,
					TanggalAkhirVKP0 = TempResult.TanggalAkhirVKP0,
					HargaCicilan = TempResult.HargaCicilan,
					CekCicilan = TempResult.CekCicilan,
					PaketPerlindungan = TempResult.PaketPerlindungan,
					TanggalBerlaku = TempResult.TanggalBerlaku,
					TanggalUpload = @TanggalUpload
				FROM
					(SELECT * FROM #result) AS TempResult
				WHERE 
					MasterPriceTagBaru.KodeBarang = TempResult.KodeBarang
				AND MasterPriceTagBaru.KodeStore = TempResult.KodeStore

				INSERT INTO MasterPriceTagBaruHistory SELECT *, @TanggalUpload FROM #result
			END
		ELSE
			BEGIN
				INSERT INTO MasterPriceTagBaru SELECT *, @TanggalUpload FROM #result

				INSERT INTO MasterPriceTagBaruHistory SELECT *, @TanggalUpload FROM #result
			END

		UPDATE MasterPriceTagBaru_TempArticle SET Status='1' WHERE KodeBarang=@KodeBarang AND KodeStore=@KodeStore

		DROP TABLE #temphargabarangutama
		DROP TABLE #Promo
		DROP TABLE #result

		FETCH NEXT FROM db_cursor INTO @KodeBarang
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 


end
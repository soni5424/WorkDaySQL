			select distinct p.KodePromo, p.NamaPromo, 
				convert(varchar(25), p.TanggalAwal, 120) TanggalAwal, convert(varchar(25), p.TanggalAkhir, 120)
				TanggalAkhir, p.JumlahPromo KuotaPromo, p.MemberOnly, p.Status, pbu.KodeBarang KodeBarangUtama,
				pbu.Jumlah QtyBarangUtama, pbf.KodeBarangFree, pbf.JumlahBarangFree QtyBarangFree,
				pbf.PotonganVPR, pbf.JenisNilai, p.Monday, p.Tuesday, p.Wednesday, p.Thursday, p.Friday,
				p.Saturday, p.Sunday, p.LimitByCustomer, LongDesc1, LongDesc2, LongDesc3, LongDesc4, LongDesc5

			from 
				PR_MasterPromo p,
				PH_MasterPromoDetailStore ps,
				PR_MasterPromoDetailBarangFree pbf,
				PR_MasterPromoDetailBarangUtama pbu
			where 
				p.KodePromo = ps.KodePromo
				and (p.KodePromo NOT IN (SELECT KodePromo FROM dbo.PR_MasterPromoDetailBarangFree
						WHERE (JenisNilai = 'IDR') OR ((JenisNilai = '%') AND (PotonganVPR <> 100))))
				and (p.Status = '')
				and p.KodePromo=pbu.KodePromo
				and p.CustType!='ZC03'
				and p.KodePromo=pbf.KodePromo
				and isnull(p.Wednesday,'')=''
				and pbu.KodeBarang!=''
				and pbu.Jumlah=1
				and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))>=p.TanggalAwal
				and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))<=p.TanggalAkhir
				and isnull(pbf.KodeBarangFree,'')!=''
				and p.KodePromo='100084762-02'
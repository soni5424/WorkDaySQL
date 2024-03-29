
select
	p.KodePromo,
	p.NamaPromo,
	p.TanggalAwal,
	p.TanggalAkhir,
	p.JumlahPromo,
	p.JumlahPromoTerpakai,
	p.JenisPromo,
	p.KeteranganSO,
	u.Jumlah,
	p.PromotionNo,
	p.CustType,
	p.NDNR, -- save untuk cek saat retur
	p.MemberOnly,
	p.LimitByCustomer
from
	PR_MasterPromo p,
	PR_MasterPromoDetailBarangUtama u
where
	p.KodePromo = u.KodePromo
	and u.KodeBarang = 'HP8401/00'
	and u.StatusCheck = 'True'
	and u.StatusBerhenti = 'False'
	and cast(convert(varchar, p.TanggalAwal, 111) as datetime) <= cast(convert(varchar, getdate(), 111) as datetime)
	and cast(convert(varchar, getdate(), 111) as datetime) <= cast(convert(varchar, p.TanggalAkhir, 111) as datetime)
	and '10' in (select s.KodeStore from PH_MasterPromoDetailStore s where s.KodePromo = p.KodePromo)
	and p.KodePromo not like 'PR%'
	and p.Status = ''
	and p.SOType = ''








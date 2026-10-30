USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[PGetMemberPurchaseByKodeJenis]    Script Date: 27/08/2026 10.23.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 25.4.16
-- Description		: Add JenisKelamin
-- =============================================

-- =============================================
-- Modified By		: Rini Handini
-- Modified Date	: 05/05/2021
-- Description		: Add Faktur HM
-- =============================================

/* =============================================
exec PGetMemberPurchaseByKodeJenis '07-00148151', '20200820', '20260820', null, 0
exec PGetMemberPurchaseByKodeJenis '07-00148151', null, null, null, 0
 ============================================= */

	
	select 
		NoMember,
		NamaMember,
		JenisKelamin
	into
		#MasterMember
	from
		MasterMember
	where
		NoMember = isnull('07-00148151', NoMember)
		
	select 
		NoFaktur, 
		Tanggal, 
		PointRewardTo as NoMember
	into 
		#TrxFakturHE
	from
		TrxFaktur
	where
		PointRewardTo = isnull('07-00148151', PointRewardTo)
		and Tanggal >= isnull('20200820', Tanggal)
		and Tanggal < isnull('20260820', Tanggal+1)

	select * from #TrxFakturHE order by tanggal
		
	select
		d.NoFaktur,
		d.KodeBarang, 
		d.KodeGudang, 
		d.Jumlah, 
		d.HargaBarang, 
		d.Discount, 
		d.SubTotalHarga
	into
		#TrxFakturDetailHE
	from
		#TrxFakturHE f,
		TrxFakturDetail d,
		MasterBarang b
	where
		f.NoFaktur = d.NoFaktur
		and d.KodeBarang = b.KodeBarang
		and b.KodeJenis = isnull(@KodeJenis, b.KodeJenis) 

	select 
		NoFaktur, 
		Tanggal, 
		PointRewardTo as NoMember
	into 
		#TrxFakturHM
	from
		[192.168.9.28].Hartono.dbo.TrxFaktur
	where
		PointRewardTo = isnull(@NoMember, PointRewardTo)
		and Tanggal >= isnull(@TglAwal, Tanggal)
		and Tanggal < isnull(@TglAkhir+1, Tanggal+1)
		
	select
		d.NoFaktur,
		d.KodeBarang, 
		d.KodeGudang, 
		d.Jumlah, 
		d.HargaBarang, 
		d.Discount, 
		d.SubTotalHarga
	into
		#TrxFakturDetailHM
	from
		#TrxFakturHM f,
		[192.168.9.28].Hartono.dbo.TrxFakturDetail d,
		[192.168.9.28].Hartono.dbo.MasterBarang b
	where
		f.NoFaktur = d.NoFaktur
		and d.KodeBarang = b.KodeBarang
		and b.KodeJenis = isnull(@KodeJenis, b.KodeJenis)		
		
	select
		x.*
	from (
		select 
			f.NoFaktur, 
			f.Tanggal, 
			f.NoMember, 
			m.NamaMember,
			m.JenisKelamin, 
			d.KodeBarang, 
			d.KodeGudang, 
			d.Jumlah, 
			d.HargaBarang, 
			d.Discount, 
			d.SubTotalHarga
		from
			#TrxFakturHE f,
			#TrxFakturDetailHE d,
			#MasterMember m
		where
			f.NoFaktur = d.NoFaktur
			and f.NoMember = m.NoMember
		UNION
		select 
			f.NoFaktur, 
			f.Tanggal, 
			f.NoMember, 
			m.NamaMember,
			m.JenisKelamin, 
			d.KodeBarang, 
			d.KodeGudang, 
			d.Jumlah, 
			d.HargaBarang, 
			d.Discount, 
			d.SubTotalHarga
		from
			#TrxFakturHM f,
			#TrxFakturDetailHM d,
			#MasterMember m
		where
			f.NoFaktur = d.NoFaktur
			and f.NoMember = m.NoMember
	) as x
	order by
		x.Tanggal desc,
		x.NoFaktur,
		x.KodeBarang
END
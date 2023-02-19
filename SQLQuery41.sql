USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MyH_PGetPromoPotHargaToMyHartonoTanpaSite]    Script Date: 06/02/2022 15:01:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Created By		: Soni Gunawan
-- Created Date		: 21.4.22
-- Description		: 
-- =============================================
-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 27.5.22
-- Description		: Remark Status
-- =============================================
-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 30.5.22
-- Description		: Add Filter h_SAP_PromoPOStoMyHartono.Site
-- =============================================

-- select * from h_SAP_PromoPOStoMyHartono where kodepromo1='100081200-01'
-- select * from h_SAP_PromoServToMyHartono where kodepromo='100081200-01'
-- exec MyH_PGetPromoPotHargaToMyHartonoSite  'HE'

Create PROCEDURE [dbo].[MyH_PGetPromoPotHargaToMyHartonoSite]
	@jenis		varchar(50) ='HM'
AS
BEGIN
	set dateformat dmy;
	SET NOCOUNT ON;
	declare @tListArticle table (articleCode varchar(50), articleCodeCheck varchar(50))
	
	select distinct pr.KodePromo, pr.NamaPromo, pr.TanggalAwal, pr.TanggalAkhir, pr.KuotaPromo, pr.MemberOnly, pr.Status,
		(case when @jenis='HM' then a.OLD_MAT_NO+'-[HM]' else a.OLD_MAT_NO end) KodeBarangUtama, QtyBarangUtama,
		pr.PotonganVPR, pr.JenisNilai, pr.Monday, pr.Tuesday, pr.Wednesday, pr.Thursday,
		pr.Friday, pr.Saturday, pr.Sunday, pr.LimitByCustomer, LongDesc1, LongDesc2, LongDesc3, LongDesc4, LongDesc5,
		pr.site, (select KodeStore FROM MasterStore WHERE SALES_OFF=pr.site and KodeStore != '00') AS KodeStore
	from
		SAP_ARTICLE a
		inner join (
			select distinct p.KodePromo, p.NamaPromo,
				convert(varchar(25), p.TanggalAwal, 120) TanggalAwal, convert(varchar(25), p.TanggalAkhir, 120) TanggalAkhir,
				p.JumlahPromo KuotaPromo, p.MemberOnly,  p.Status, pbu.KodeBarang KodeBarangUtama, pbu.Jumlah QtyBarangUtama,
				pph.Jumlah PotonganVPR, pph.JenisNilai, p.Monday, p.Tuesday, p.Wednesday, p.Thursday, p.Friday,
				p.Saturday, p.Sunday, p.LimitByCustomer, LongDesc1, LongDesc2, LongDesc3, LongDesc4, LongDesc5, 
				h.site
			from 
				PR_MasterPromo p,
				PH_MasterPromoDetailStore ps,
				PR_MasterPromoDetailPotonganHarga pph,
				PR_MasterPromoDetailBarangUtama pbu,
				h_SAP_PromoPOStoMyHartono h
			where 
				p.KodePromo = ps.KodePromo
				and ps.KodeStore IN (SELECT KodeStore FROM MasterStore A, h_SAP_PromoPOStoMyHartono B WHERE A.SALES_OFF=B.Site AND p.KodePromo=B.KodePromo1 AND B.Status=0)
				and (p.KodePromo NOT IN (SELECT KodePromo FROM dbo.PR_MasterPromoDetailBarangFree 
						WHERE (JenisNilai = 'IDR') OR ((JenisNilai = '%') AND (PotonganVPR <> 100))))
				and p.KodePromo=pbu.KodePromo
				and p.CustType!='ZC03'
				and p.KodePromo=pph.KodePromo
				and isnull(p.Wednesday,'')=''
				and pbu.KodeBarang!=''
				and pbu.Jumlah=1
				and h.status=0 
				and h.KodePromo1=p.KodePromo
		) pr on a.OLD_MAT_NO=pr.KodeBarangUtama
	where 
		a.Article_Type not in ('ZGIF','ZPAY','ZSET','ZSTC')
		and a.material not in (select material from SAP_ARTICLE 
								where Article_Type='DIEN' 
									and Pur_Group in ('M16', 'M18', 'N01', 'N02', 'N03', 'N04'))
		and a.DISCNTIN_IDC=0
		and a.MATERIAL not in (select distinct Article from SAP_ArticleHistory where FieldName='MSTAE' and NewValue!='')
END

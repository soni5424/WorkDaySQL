USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MyH_PGetPromoFreeToMyHartono]    Script Date: 04/26/2022 14:41:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Created By	: Soni Gunawan
-- Created Date	: 21.4.22
-- Description	: 
-- =============================================

-- EXEC MyH_PGetPromoPotHargaToMyHartono 'HE', 'S001', '01', '100078132-13'
ALTER PROCEDURE [dbo].[MyH_PGetPromoFreeToMyHartono]
	@jenis		varchar(50),
	@Site		varchar(10)=NULL,
	@KodeStore	varchar(10)=NULL,
	@KodePromo varchar (100)=NULL
AS
BEGIN
	set dateformat dmy;
	SET NOCOUNT ON;
	declare @tListArticle table (articleCode varchar(50), articleCodeCheck varchar(50))
	
	if(@Site is NULL) set @Site='O001'
	if(@KodeStore is NULL) set @KodeStore='07'
		
	select distinct pr.KodePromo, pr.NamaPromo, pr.TanggalAwal, pr.TanggalAkhir, pr.KuotaPromo, pr.MemberOnly,
		pr.Status, (case when @jenis='HM' then a.OLD_MAT_NO+'-[HM]' else a.OLD_MAT_NO end) KodeBarangUtama,	
		QtyBarangUtama, pr.KodeBarangFree, pr.QtyBarangFree, pr.PotonganVPR, pr.JenisNilai, @KodeStore KodeStore,
		pr.Monday, pr.Tuesday, pr.Wednesday, pr.Thursday, pr.Friday, pr.Saturday, pr.Sunday, pr.LimitByCustomer,
		LongDesc1, LongDesc2, LongDesc3, LongDesc4, LongDesc5
	from
		SAP_ARTICLE a
		inner join (
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
				PR_MasterPromoDetailBarangUtama pbu,
				h_SAP_PromoPOStoMyHartono h
			where 
				p.KodePromo = ps.KodePromo
				and ps.KodeStore=@KodeStore
				and (p.KodePromo NOT IN (SELECT KodePromo FROM dbo.PR_MasterPromoDetailBarangFree
						WHERE (JenisNilai = 'IDR') OR ((JenisNilai = '%') AND (PotonganVPR <> 100))))
				--and (p.Status = '')
				and p.KodePromo=pbu.KodePromo
				and p.CustType!='ZC03'
				and p.KodePromo=pbf.KodePromo
				and isnull(p.Wednesday,'')=''
				and pbu.KodeBarang!=''
				and pbu.Jumlah=1
				--and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))>=p.TanggalAwal
				--and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))<=p.TanggalAkhir
				and isnull(pbf.KodeBarangFree,'')!=''
				and h.KodePromo1 = p.KodePromo
				--and h.Status=0
				and p.KodePromo LIKE '%'+ISNULL(@KodePromo,'')+'%'
		) pr on a.OLD_MAT_NO=pr.KodeBarangUtama
	where a.SITE=@Site
		and a.Article_Type not in ('ZGIF','ZPAY','ZSET','ZSTC')
		and a.material not in (select material from SAP_ARTICLE 
								where Article_Type='DIEN' 
									and Pur_Group in ('M16', 'M18', 'N01', 'N02', 'N03', 'N04')
									and Site=@Site)
		and a.DISCNTIN_IDC=0
		--and a.MATERIAL not in (select distinct Article from SAP_ArticleHistory where FieldName='MSTAE' and NewValue!='')
		--and KodePromo LIKE '%'+ISNULL(@KodePromo,'')+'%'		
END
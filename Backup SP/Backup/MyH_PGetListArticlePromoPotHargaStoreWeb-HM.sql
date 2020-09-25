USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[MyH_PGetListArticlePromoPotHargaStoreWeb]    Script Date: 22/04/2020 12.07.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author		: Peter
-- Create date	: 27/03/2019
-- Description	: Get List Promo Pot Harga Untuk Web per Store
-- =============================================
ALTER PROCEDURE [dbo].[MyH_PGetListArticlePromoPotHargaStoreWeb]
	@jenis		varchar(50),
	@Site		varchar(10)=NULL,
	@KodeStore	varchar(10)=NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set dateformat dmy;
	SET NOCOUNT ON;
	declare @tListArticle table (articleCode varchar(50), articleCodeCheck varchar(50))
	
	if(@Site is NULL)
		set @Site='O001'
	if(@KodeStore is NULL)
		set @KodeStore='07'

	/*		
	if(@jenis='HE')
	Begin
		insert into @tListArticle
		select distinct KodeBarang articleCode, KodeBarang articleCodeCheck from MyHartono_ListArticle where right(rtrim(KodeBarang),4)!='[HM]'
	End
	else if(@jenis='HM')
	Begin
		insert into @tListArticle
		select distinct KodeBarang articleCode, stuff(rtrim(KodeBarang),len(rtrim(KodeBarang))-4,5,'') articleCodeCheck from MyHartono_ListArticle where right(rtrim(KodeBarang),4)='[HM]'
	End
	*/
	
	select distinct pr.KodePromo, pr.NamaPromo, pr.TanggalAwal, pr.TanggalAkhir, pr.KuotaPromo, pr.MemberOnly, pr.Status,
	--m.articleCode KodeBarangUtama,
	(case when @jenis='HM' then a.OLD_MAT_NO+'-[HM]' else a.OLD_MAT_NO end) KodeBarangUtama,
	QtyBarangUtama, pr.PotonganVPR, pr.JenisNilai, @KodeStore KodeStore
	from
	--@tListArticle m inner join SAP_ARTICLE a on m.articleCodeCheck=a.OLD_MAT_NO and a.SITE=@Site	
	SAP_ARTICLE a 
	inner join (
		select distinct p.KodePromo, p.NamaPromo, 
		convert(varchar(25), p.TanggalAwal, 120) TanggalAwal, convert(varchar(25), p.TanggalAkhir, 120) TanggalAkhir,
		p.JumlahPromo KuotaPromo, p.MemberOnly,
		p.Status, pbu.KodeBarang KodeBarangUtama, pbu.Jumlah QtyBarangUtama, pph.Jumlah PotonganVPR, pph.JenisNilai 
		from 
		PR_MasterPromo p,
		PH_MasterPromoDetailStore ps,
		PR_MasterPromoDetailPotonganHarga pph,
		PR_MasterPromoDetailBarangUtama pbu
		where 
		p.KodePromo = ps.KodePromo
		and ps.KodeStore=@KodeStore
		and (p.KodePromo NOT IN 
				(SELECT KodePromo FROM dbo.PR_MasterPromoDetailBarangFree 
				WHERE (JenisNilai = 'IDR') OR ((JenisNilai = '%') AND (PotonganVPR <> 100)))
			)
		and (p.Status = '')
		and p.KodePromo=pbu.KodePromo
		and p.CustType!='ZC03' and isnull(p.LimitByCustomer,0)=0
		and p.KodePromo=pph.KodePromo
		and isnull(p.Wednesday,'')=''
		and pbu.KodeBarang!=''
		and pbu.Jumlah=1
		and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))>=p.TanggalAwal
		and DATEADD(dd, 0, DATEDIFF(dd, 0, getdate()))<=p.TanggalAkhir
	) pr
	on a.MATERIAL=pr.KodeBarangUtama
	where a.SITE=@Site
	and a.Article_Type not in ('ZGIF','ZPAY','ZSET','ZSTC')
	and a.material not in (
		select material from SAP_ARTICLE 
		where Article_Type='DIEN' and Pur_Group in ('M16', 'M18', 'N01', 'N02', 'N03', 'N04')
		and Site=@Site
		)
	--where pr.KodePromo is not null
END






GO


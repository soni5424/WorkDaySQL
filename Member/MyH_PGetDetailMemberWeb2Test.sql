USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MyH_PGetDetailMemberWeb2Test]    Script Date: 16/03/2021 11.23.22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Created By	: Soni Gunawan
-- Created Date	: 11/02/2021
-- Description	: Only for Test, boleh di delete
-- =============================================

ALTER PROCEDURE [dbo].[MyH_PGetDetailMemberWeb2Test]
	@NoMember	varchar(50)
AS
Begin
	set dateformat dmy;
	
	select (case when BlackList=0 then '0' else '1' end) Status, isnull(NoHP,'') NoHP, NoMember, NamaMember, NoKartuMember, 
	TempatLahir, Alamat, NoKTP, convert(varchar(10), TglLahirMember, 120) TglLahirMember,
	JenisKelamin, Kota, isnull(KodePos,'') KodePos, RewardPoint
	from MasterMember
	where (JenisMember = 'P') AND (LastModified >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()-1)))
		and NoMember like '%'+isnull(@NoMember,'')+'%'
End

USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PSB_PGetDashboardManager]    Script Date: 06/10/2020 12.52.05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 11/12/2019
-- Description:	PGetDashboardManager

-- Modified:		Daniel
-- Modified date: 23/03/2020
-- Description:	Area diganti setup area

-- Modified:		Daniel
-- Modified date: 14/04/2020
-- Description:	Karena pergantian setup area untuk mendapatkan kodestore dirubah

-- Modified:		Daniel
-- Modified date: 20/04/2020
-- Description:	modified nama area
-- =============================================
ALTER PROCEDURE [dbo].[PSB_PGetDashboardManager]
	@Site varchar(500),
	@Area varchar(500),
	@PsbDate1 varchar(10),
	@PsbDate2 varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--	declare @KodeStore varchar(50)
--	set @KodeStore = (select KodeStore from PSB_SetupPoint where KodeSetup = @Area)	
	select distinct '' as PSBNo,(convert(varchar(10),b.Date,103))as Date,b.Site,
		(select namaarea from PSB_MasterArea where KodeArea = b.Area) as Area, --Nama Area
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) ) as Findings,
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) and status = 'VOID') as Void, 
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) and status = 'PASS' and Target in (select Target from psb_setup where Corrective = '1'))as Pass,
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) and status = 'PASS' and Target in (select Target from psb_setup where Corrective = '0')) as PassNon,
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) and status = 'FAIL' and Target in (select Target from psb_setup where Corrective = '1')) as Failed,
		(select count(NoDetail) from psb_trxPSB c,psb_trxPSBDetail d where c.PSBNo = d.PSBNo and b.Site = c.Site and c.Area like b.Area  and convert(datetime,(convert(varchar(10),SubmitDate,103)),103) = convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103) and status = 'FAIL' and Target in (select Target from psb_setup where Corrective = '0')) as FailedNon		
		from psb_trxPSB b left join psb_trxPSBDetail a on a.PSBNo = b.PSBNo 
		where b.Site = @Site --and b.Area like '%'+@Area+'%' 
		and b.Area in (select KodeArea from PSB_MasterArea where KodeStore in (select KodeStore from PSB_SetupPoint where KodeSetup = @Area) and KodeSetup = @Area) --KodeStore = @KodeStore
		and convert(datetime,(convert(varchar(10),a.SubmitDate,103)),103)
		between convert(datetime,(convert(varchar(10),@PsbDate1,103)),103) and convert(datetime,(convert(varchar(10),@PsbDate2,103)),103)
	group by a.SubmitDate,(convert(varchar(10),b.Date,103)),b.Site,b.Area
END






GO


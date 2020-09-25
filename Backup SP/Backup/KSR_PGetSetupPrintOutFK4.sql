USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[KSR_PGetSetupPrintOutFK4]    Script Date: 08/05/2020 13.44.30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author		: Peter L
-- Create date	: 02/03/2017
-- Description	: Get Setup PrintOut FK By NoFK
-- =============================================
ALTER PROCEDURE [dbo].[KSR_PGetSetupPrintOutFK4]
	@NoFaktur varchar(50)
AS
BEGIN
set dateformat dmy

declare @TglNow datetime
set @TglNow=(select DATEADD(D, 0, DATEDIFF(D, 0, GETDATE())))

		if exists(select x.NoFaktur, sum(x.SubTotalHarga) SubTotalHarga from
			(
				select distinct f.NoFaktur,fd.KodeBarang,fd.SubTotalHarga from TrxFaktur f, TrxFakturDetail fd, SAP_ARTICLE a, mastermember m 
				where f.NoFaktur=fd.NoFaktur and fd.KodeBarang=a.OLD_MAT_NO and
				--f.PointRewardTo=m.NoMember and m.jenismember='P' and
				--f.PointRewardTo=m.NoMember and m.jenismember='P' and
				f.Tanggal>='20200429' and f.Tanggal<'20200506' and
				a.Article_Type='HAWA' and
				fd.Discount=0 and
				f.NoFaktur=@NoFaktur
				--and a.Brand_Name='ARISTON' 
				--fd.Kodebarang in
				--(
				--	Select Nilai from KSR_SetupDetailPrintOutFK where GroupNo=4 and Nama='MATERIAL'
				--)
				and fd.Kodebarang in
				(
					'CRL1188/1', 'CRL1188/2', 'CRL1188/3', 'CRL1188/5'
				)
			)x
			group by x.NoFaktur
			--having sum(x.SubTotalHarga)>=500000				
		)		
		begin
			--update KSR_SetupPrintOutFK
			--set tbPrintOutFKNoFK1=@NoFaktur
			--where GroupNo=4
			
			select GroupNo,lblPrintoutFKB1,lblPrintoutFKB2,lblPrintoutFKB3,lblPrintoutFKB4,lblPrintoutFKK1,lblPrintoutFKdari1,@NoFaktur tbPrintOutFKNoFK1, 
					lblPrintoutFKSK1,lblPrintoutFKSK2,LinePrintOutFK1,LinePrintOutFK2,LinePotong1
			from KSR_SetupPrintOutFK where GroupNo=4
		end
			
END





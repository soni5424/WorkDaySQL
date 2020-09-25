USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[KSR_PGetSetupPrintOutFK2]    Script Date: 14/08/2020 14.27.38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author		: Peter L
-- Create date	: 02/03/2017
-- Description	: Get Setup PrintOut FK By NoFK
-- =============================================
ALTER PROCEDURE [dbo].[KSR_PGetSetupPrintOutFK2]
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
				f.Tanggal>='20200722' and f.Tanggal<'20200813' and
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
					'HWD-C520IC', 'HWD730N_N', 'HWD-760_N', 'HWD-738BK_N', 'HWD999SH_N', 'HWD-C538SL', 
					'HWD-C505_N', 'HWD-C500E_N', 'HWD-C106_N', 'HWD-C200SS_N', 'HWD-C580S-BK', 
					'HWD-C202SS_N', 'HWD-C570S-BK', 'HWD-C575S-BK', 'HWD-C590G-BK', 'HWDZ88_BR_N', 
					'HWD-Z90_N', 'HWD-Z95_N', 'HWD-Z96_N', 'HWD-Z980SBK', 'HWD-Z980S-SL', 'HWD-Z970S-BK', 
					'HWD-Z990GBK'
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
			from KSR_SetupPrintOutFK where GroupNo=2
		end
			
END




GO


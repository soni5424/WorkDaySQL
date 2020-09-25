USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[KSR_PGetSetupPrintOutFK2]    Script Date: 21/07/2020 03.22.36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author		: |Peter L|
-- Create date	: |02/03/2017|
-- Description	: |Get Setup PrintOut FK By NoFK|
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
				--datename(dw,f.Tanggal) in ('Friday','Saturday','Sunday') and
				--f.PointRewardTo=m.NoMember and m.jenismember='P' and
				f.Tanggal>='20191014' and f.Tanggal<'20191104' and
				a.Article_Type='HAWA' and
				fd.Discount=0 and
				f.NoFaktur=@NoFaktur 
				--and fd.Kodebarang in
				--(
				--	'20240-56', '20230-56', '20220-56', '18986-56', '21501-56', '19005-56',
				--	'21510-56', '20345-56', '22281-56', '20840-56', '20810-56', '22570-56', 
				--	'18995-56', '20221-56', '19270-56', '21200-56', '20700-56', '20130-56', 
				--	'20365-56', '21350-56'
				--)
				and a.MATL_GROUP in
				(
					'AV0103', 'AV0301', 'AV0303', 'AV0401', 
					'AV0404', 'AV0406', 'AV0407', 'AV0408', 
					'AV0601', 'AV0602', 'AV0603', 'AV0604', 
					'AV0605', 'AV0607', 'AV0701', 'AV0702', 
					'AV0703', 'AV0704', 'AV0707', 'AV0708', 
					'AV0709', 'AV0801', 'AV0802', 'AV0804', 
					'AV0805', 'AV0806', 'AV0808', 'AV0809', 
					'AV0811', 'AV0812', 'AV0901', 'AV0906', 
					'AV0907', 'AV1001', 'AV1002', 'AV1101', 
					'WG0101', 'WG0102', 'WG0103', 'WG0104', 
					'WG0105', 'WG0106', 'WG0107', 'WG0108', 
					'WG0201', 'WG0202', 'WG0203', 'WG0204', 
					'WG0205', 'WG0206', 'WG0301', 'WG0302', 
					'WG0401', 'WG0402', 'WG0403', 'WG0501', 
					'WG0502', 'WG0503', 'WG0504', 'WG0505'
				)
			)x
			group by x.NoFaktur
			--having sum(x.SubTotalHarga)>=2500000
		)		
		begin
			--update KSR_SetupPrintOutFK
			--set tbPrintOutFKNoFK1=@NoFaktur
			--where GroupNo=2
					
			select GroupNo,lblPrintoutFKB1,lblPrintoutFKB2,lblPrintoutFKB3,lblPrintoutFKB4,lblPrintoutFKK1,lblPrintoutFKdari1,@NoFaktur tbPrintOutFKNoFK1, 
					lblPrintoutFKSK1,lblPrintoutFKSK2,LinePrintOutFK1,LinePrintOutFK2,LinePotong1
			from KSR_SetupPrintOutFK where GroupNo=2
		end
			
END




GO


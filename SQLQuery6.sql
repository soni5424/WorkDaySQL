USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[PBLTGetNextNoBLTPromoVDPSHA2022]    Script Date: 04/04/2022 20:35:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author			: Anton Nyoto W.
-- Create date		: 25/03/2022
-- Description		: BLT VDP SHA 2022
-- =============================================

ALTER PROCEDURE [dbo].[PBLTGetNextNoBLTPromoVDPSHA2022]
	@NoFaktur	varchar(18)
AS
begin

	declare @KodeBarang	varchar(50)

	set @KodeBarang = (select isnull((select top 1 d.KodeBarang
										from
											TrxFaktur f, 
											TrxFakturDetail d
										where
											f.NoFaktur = @NoFaktur
											and f.NoFaktur = d.NoFaktur
											and d.KodeBarang in (
											'CR-0631F',
											'CR-0655F',
											'CR-0671V',
											'CR-0810F',
											'CR-1020F/BK',
											'CR-1020F/WH',
											'CR-1055BK',
											'CR-1055RD',
											'CR-1065RD',
											'CR-1122',
											'CR-1413',
											'CR-1713',
											'CR-3021',
											'CR-3521',
											'CRP-CHSS1009F',
											'CRP-JHT1012F',
											'CRP-PK1000S',
											'CRP-R0612F',
											'CRP-RT1008F')
										order by
											d.SubtotalHarga / d.Jumlah desc
										), ''))							

	if(@KodeBarang in ('CR-0631F','CR-0655F','CR-0671V','CR-0810F','CR-1020F/BK','CR-1020F/WH','CR-1055BK','CR-1055RD','CR-1065RD','CR-1122','CR-1413','CR-1713','CR-3021','CR-3521','CRP-CHSS1009F','CRP-JHT1012F','CRP-PK1000S','CRP-R0612F','CRP-RT1008F'))
		begin
			IF EXISTS (SELECT TOP 1 a.NoBLT
				FROM MasterBLT2 a
				JOIN KHAE_MasterVoucher b ON a.NoBLT = b.NoBLT
				WHERE a.Terpakai = 0
				AND b.Nama = 'VDP SHA 2 2022')
				--AND b.KodeBarang = @KodeBarang)
					SELECT TOP 1 a.NoBLT
					FROM MasterBLT2 a
					JOIN KHAE_MasterVoucher b ON a.NoBLT = b.NoBLT
					WHERE a.Terpakai = 0
					AND b.Nama = 'VDP SHA 2 2022'
					ORDER BY NEWID() -- Update Random 04/042022
					--AND b.KodeBarang = @KodeBarang
			ELSE
				SELECT 0
		end
	else
		select 0

	/*
	if (@KodeBarang in ('LC32DX288IBZ'))
		select 1 -- 2jt
	else if (@KodeBarang in ('20LB450A'))
		select 2 -- 1.2jt
	else if (@KodeBarang in ('RT20FARWDSA'))
		select 3 -- 750rb
	else 
		select 0
	*/
end


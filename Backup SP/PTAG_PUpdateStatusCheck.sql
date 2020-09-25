USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PTAG_PUpdateStatusCheck]    Script Date: 30/06/2020 16.45.12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author	: Yongky
-- Create date	: 24 Oktober 2012
-- Description	: Update Status Cetak Price Tag

-- Modified By		: Peter 
-- Modified Date	: 26/08/16
-- Description		: Closed insert MasterPriceTagCetakHistory

-- Modified By		: Ferry Hartono
-- Modified Date	: 30/03/2020
-- Description		: Update to all store
-- Project			: |SD20-019|
-- =============================================

ALTER PROCEDURE [dbo].[PTAG_PUpdateStatusCheck]
(
  @KodeBarang varchar(20),
  @KodeStore varchar(2),
  @UserID varchar(10)
)
AS
Begin

	UPDATE MasterPriceTagCheck
	set StatusCheck = 1,
		TanggalCheck = getdate(),
		UserIDCheck = @UserID
	where KodeBarang= @KodeBarang 
	--and KodeStore = @KodeStore Closed | Ferry Hartono - 30/03/2020

	if exists
	(
	  select * 
	  from MasterPriceTagCetak
	  Where KodeBarang = @KodeBarang
	  and KodeStore = @KodeStore
	)
	Begin
	if exists
	(
	  select * 
	  from MasterPriceTagCetak
	  Where KodeBarang = @KodeBarang
	  and KodeStore = @KodeStore
          and statuscetak = 1
	)
        begin
        --Closed Price tag 2015 rev 7 - Peter 26/08/2016
		--insert into MasterPriceTagCetakHistory
		--select * 
		--from MasterPriceTagCetak
		--Where KodeBarang = @KodeBarang
		--and KodeStore = @KodeStore
  --              and statuscetak = 1

		delete from  MasterPriceTagCetak
		Where KodeBarang = @KodeBarang
		and KodeStore = @KodeStore
                and statuscetak = 1	

		insert into MasterPriceTagCetak
		(
		  KodeBarang,
		  KodeStore,
		  TanggalUpload,
		  TanggalPList,
                  KeteranganCetakUlang

		)
		select
		   KodeBarang,
		   KodeStore,
		   TanggalUpload,
		   TanggalPList,
                   0
		from MasterPriceTagCheck
		where KodeBarang = @KodeBarang
		and KodeStore = @KodeStore 
        End
		
	End Else
	Begin
		insert into MasterPriceTagCetak
		(
		  KodeBarang,
		  KodeStore,
		  TanggalUpload,
		  TanggalPList,
                  KeteranganCetakUlang

		)
		select
		   KodeBarang,
		   KodeStore,
		   TanggalUpload,
		   TanggalPList,
                   0
		from MasterPriceTagCheck
		where KodeBarang = @KodeBarang
		and KodeStore = @KodeStore 
	End
End



GO


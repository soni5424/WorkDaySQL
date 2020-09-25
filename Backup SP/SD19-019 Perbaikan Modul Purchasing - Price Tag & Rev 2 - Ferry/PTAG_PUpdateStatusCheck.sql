USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PTAG_PUpdateStatusCheck]    Script Date: 15/06/2020 21:34:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author	: Yongky
-- Create date	: 24 Oktober 2012
-- Description	: Update Status Cetak Price Tag
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
	and KodeStore = @KodeStore

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
		insert into MasterPriceTagCetakHistory
		select * 
		from MasterPriceTagCetak
		Where KodeBarang = @KodeBarang
		and KodeStore = @KodeStore
                and statuscetak = 1

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


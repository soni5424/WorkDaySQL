USE [Hartono]
GO

/****** Object:  Trigger [dbo].[trMasterPriceTag]    Script Date: 03/07/2020 11.25.27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author	: Yongky
-- Create date	: 03 Agustus 2013
-- Description	: Insert MasterPriceTagCheck
-- =============================================

ALTER TRIGGER [dbo].[trMasterPriceTag]
ON [dbo].[MasterPriceTag]
FOR INSERT,UPDATE
AS
Begin 
  declare @KodeBarang varchar(20),
          @KodeStore varchar(2),
          @TanggalPList datetime,
          @TanggalUpload datetime

  select @KodeBarang = KOdeBarang,
         @KodeStore = KodeStore,
         @TanggalPList = TanggalPList,
         @TanggalUpload = TanggalUpload

  from Inserted

  if not exists(select @KodeBarang from MasterPriceTagCheck where KodeBarang = @KodeBarang and KodeStore = @KodeStore )
  Begin
    Insert Into MasterPriceTagCheck(KOdeBarang, KodeStore, TanggalPlist, TanggalUpload, StatusCheck)
    select @KodeBarang, @KodeStore, @TanggalPList, @TanggalUpload, 0
  End
  Else
  Begin
--    Insert Into MasterPriceTagCheckHistory 
--    Select * from MasterPriceTagCheck where KodeBarang = @KodeBarang and KodeStore = @KodeStore 

    Delete from MasterPriceTagCheck where KodeBarang = @KodeBarang and KodeStore = @KodeStore 

    Insert Into MasterPriceTagCheck(KOdeBarang, KodeStore, TanggalPlist, TanggalUpload, StatusCheck)
    select @KodeBarang, @KodeStore, @TanggalPList, @TanggalUpload, 0
  End


End




GO


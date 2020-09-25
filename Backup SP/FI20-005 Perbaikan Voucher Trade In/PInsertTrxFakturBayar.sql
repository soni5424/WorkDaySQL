USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PInsertTrxFakturBayar]    Script Date: 28/05/2020 14.38.08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER          PROCEDURE [dbo].[PInsertTrxFakturBayar]
-- ==============================================================================
-- Stored procedure untuk memasukkan data ke table TrxFakturBayar

-- Modified By	: Peter L
-- Modified date: 11/05/2018
-- Description	: tambah pengecekan jika tipe bayar TTP 0 update jadi CASH 0
-- ==============================================================================
(
    @NoFaktur    char(18),
    @KodeJenisPembayaran    char(10),
    @NilaiPembayaran    decimal(18,2),
    @NoJenisPembayaran    varchar(50),
    @StatusPembayaran    char(10),
	@ProsentaseCharge decimal(6,2),
	@Charge decimal(18,2)
)
-- with encryption
AS

SET @NoJenisPembayaran = COALESCE(@NoJenisPembayaran, '') 

--Add Peter 11/05/2018
IF (@KodeJenisPembayaran='TTP') and (@NilaiPembayaran=0)
	Set @KodeJenisPembayaran='CASH'
--if (@KodeJenisPembayaran  <> 'TDC') and (@KodeJenisPembayaran  <> 'TDCB')
--Begin
INSERT TrxFakturBayar (
    NoFaktur,
    KodeJenisPembayaran,
    NilaiPembayaran,
    NoJenisPembayaran,
    StatusPembayaran,
	ProsentaseCharge,
	Charge
)
VALUES (
    @NoFaktur,
    @KodeJenisPembayaran,
    @NilaiPembayaran,
    @NoJenisPembayaran,
    @StatusPembayaran,
	@ProsentaseCharge,
	@Charge
)
--end else
--Begin
if (@KodeJenisPembayaran  = 'TDC') or (@KodeJenisPembayaran  = 'TDCB') or (@KodeJenisPembayaran  = 'TDCT') 
Begin
  Update TrxFaktur
  set  Charge = Charge -  @NilaiPembayaran
           where nofaktur  = @NoFaktur 
End
 
  if (@KodeJenisPembayaran  = 'TDC') 
  begin
  update TrxFakturBayarVPR
  set NilaiVPR1 = NilaiVPR1 + @NilaiPembayaran,
         NoJenisPembayaran1 = @NoJenisPembayaran
  where nofaktur = @NoFaktur
  end else

  if (@KodeJenisPembayaran  = 'TDCB') 
  begin
  update TrxFakturBayarVPR
  set NilaiVPR2 = NilaiVPR2 + @NilaiPembayaran,
         NoJenisPembayaran2 = @NoJenisPembayaran
  where nofaktur = @NoFaktur
  end else

  if (@KodeJenisPembayaran  = 'TDCT') 
  begin
  update TrxFakturBayarVPR
  set NilaiVPR3 = NilaiVPR3 + @NilaiPembayaran,
         NoJenisPembayaran3 = @NoJenisPembayaran
  where nofaktur = @NoFaktur
  end
  
--End





 













GO


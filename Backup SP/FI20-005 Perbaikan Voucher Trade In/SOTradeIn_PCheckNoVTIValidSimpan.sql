USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SOTradeIn_PCheckNoVTIValidSimpan]    Script Date: 28/05/2020 14.38.29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		: Peter L
-- Create date	: 01/02/2017
-- Description	: Check NoVTI yang akan digunakan untuk tipe Bayar VTI valid

-- Modified By	: Peter L
-- Modified date: 01/02/2017
-- Desc			: tambah reason_rej is null
-- =============================================

ALTER PROCEDURE [dbo].[SOTradeIn_PCheckNoVTIValidSimpan]
	@NoVTI		varchar(50),
	@NoSO		varchar(50),
	@NoMember	varchar(50)
	
AS
BEGIN

if exists (select NoTradeIn from PR_TrxTradeIn t, PR_MasterPromo p where t.KodePromo=p.KodePromo and p.NDNR='X' and t.NoTradeIn=@NoVTI)
Begin	
	if exists (select distinct NoSO, (count(sd.KodeBarang)*sd.Jumlah) x from TrxSODetail sd, (select distinct old_mat_no from SAP_Article where Article_type='HAWA') a where sd.KodeBarang=a.Old_Mat_No and sd.SubtotalHarga>0 and sd.Discount=0 and isnull(sd.reason_rej,'')!='Z2' and sd.NoSO=@NoSO group by sd.NoSO,sd.Jumlah having (count(sd.KodeBarang)*sd.Jumlah)=1)
	begin
		if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and Status=1)
		begin 
			if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and NoMember='')
			begin
				select ''
			end
			else
				if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and NoMember=@NoMember)
					select ''
				else
					select 'Member Tidak Sesuai Dengan Tiket Trade In'
		end
		else
			select 'Voucher Trade In Tidak Valid'
	end
	else
		select '1 tiket trade in hanya bisa untuk 1 pembelian barang per faktur atau Promo mengandung No Diskon No Retur'
End	
else if exists (select NoTradeIn from PR_TrxTradeIn t, PR_MasterPromo p where t.KodePromo=p.KodePromo and isnull(p.NDNR,'')='' and t.NoTradeIn=@NoVTI)
Begin
	if exists (select distinct NoSO, (count(sd.KodeBarang)*sd.Jumlah) x from TrxSODetail sd, (select distinct old_mat_no from SAP_Article where Article_type='HAWA') a where sd.KodeBarang=a.Old_Mat_No and sd.SubtotalHarga>0 and isnull(sd.reason_rej,'')!='Z2' and sd.NoSO=@NoSO group by sd.NoSO,sd.Jumlah having (count(sd.KodeBarang)*sd.Jumlah)=1)
	begin
		if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and Status=1)
		begin 
			if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and NoMember='')
			begin
				select ''
			end
			else
				if exists (select NoTradeIn from PR_TrxTradeIn where NoTradeIn=@NoVTI and NoMember=@NoMember)
					select ''
				else
					select 'Member Tidak Sesuai Dengan Tiket Trade In'
		end
		else
			select 'Voucher Trade In Tidak Valid'
	end
	else
		select '1 tiket trade in hanya bisa untuk 1 pembelian barang per faktur atau Promo mengandung No Diskon No Retur'
End
else
	select 'No VTI Tidak Valid'

END














GO


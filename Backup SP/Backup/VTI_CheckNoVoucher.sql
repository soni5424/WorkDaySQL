USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[VTI_CheckNoVoucher]    Script Date: 07/04/2020 15.26.38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |24/03/2020|
-- Description:	|Check No Voucher|
-- Project:		|FI20-005 Perbaikan Voucher Trade In - VTI|
-- =============================================
CREATE PROCEDURE [dbo].[VTI_CheckNoVoucher]
	@noVoucher		varchar(50),
	@noSO			varchar(50)
AS
BEGIN
	set dateformat dmy

	IF NOT EXISTS (SELECT * FROM PR_TrxTradeIn WHERE NoTradeIn = @noVoucher)
	BEGIN
		SELECT 'error|No VTI Tidak Ditemukan' as 'result'
	END
	ELSE
	BEGIN
		DECLARE @status int, @tanggal datetime, @noMember varchar(50), @nominal decimal(18,2)
		SELECT @status = Status, @tanggal = Tanggal, @noMember = NoMember, @nominal = Nominal
		FROM PR_TrxTradeIn
		WHERE NoTradeIn = @noVoucher
		
		IF @status != 1
		BEGIN
			SELECT 'error|No VTI Tidak Dapat Digunakan' as 'result'
		END
		ELSE
		BEGIN
			IF CONVERT(varchar(10), @tanggal, 103) != CONVERT(varchar(10), GETDATE(), 103)
			BEGIN
				SELECT 'error|No VTI Sudah Tidak Berlaku' as 'result'
			END
			ELSE
			BEGIN
				DECLARE @pointRewardTo varchar(50)
				SELECT @pointRewardTo = PointRewardTo
				FROM TrxSO
				WHERE NoSO = @noSO
				
				IF @noMember != @pointRewardTo
				BEGIN
					SELECT 'error|No VTI Tidak Dapat Dipindahtangankan' as 'result'
				END
				ELSE
				BEGIN
					SELECT 'ok|' + CONVERT(varchar(50), @nominal) as 'result'
				END
			END
		END
	END
END
GO


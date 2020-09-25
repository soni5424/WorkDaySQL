USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SD_PCekNoSOCounterBarangMasukAntrian]    Script Date: 03/06/2020 09.12.49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abednego
-- Create date: 18/09/2017
-- Description:	Check In SO to Counter

-- Modified By		: Rini Handini
-- Modified date	: 10/11/2017
-- Description		: Check CounterID di SO kosong, return NONE
-- =============================================
ALTER PROCEDURE [dbo].[SD_PCekNoSOCounterBarangMasukAntrian]
	-- Add the parameters for the stored procedure here
	@NoSO	varchar(18),
	@KodeStore	varchar(2),
	@KodeWS		varchar(3)
AS
BEGIN
	if exists(select NoSO from TrxSO where NoSO = @NoSO and (IDCounter is null or IDCounter = ''))
		select 'NONE'
	else
	begin
		IF EXISTS(
			SELECT a.IDCounter 
			FROM TrxSO a
			JOIN CB_SetupCounterBarang b
			ON a.IDcounter = b.IDCounter
			WHERE a.NoSO = @NoSO
			AND b.KodeStore = @KodeStore
			AND b.KodeWS = @KodeWS )
		BEGIN
			SELECT ''
		END
		ELSE
		BEGIN
			SELECT b.NamaCounter 
			FROM TrxSO a
			JOIN CB_SetupCounterBarang b
			ON a.IDcounter = b.IDCounter
			WHERE a.NoSO = @NoSO
		END
	end
END

GO


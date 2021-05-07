USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PCekValidUlangiOpname]    Script Date: 04/22/2021 11:02:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author			: Soni Gunawan
-- Modified date	: 20.11.15
-- Description		: 
-- =============================================

ALTER PROCEDURE [dbo].[PCekValidUlangiOpname]
    @PID varchar(50)
as
BEGIN
	DECLARE @PID2	varchar(50),
			@Flag	bit

	SET @Flag = 0

	DECLARE PID_cursor CURSOR FOR
	SELECT @PID AS PID2
	UNION
	SELECT PID2 FROM PIDJoin WHERE PID1=@PID
	UNION 
	SELECT PID1 FROM PIDJoin WHERE PID2=@PID

	OPEN PID_cursor
	FETCH NEXT FROM PID_cursor into @PID2

	WHILE @@FETCH_STATUS = 0
	BEGIN
		if (exists (SELECT * FROM PIDclose  where  (statusPOST<>'1' or statusPOST is null)  and PID = @PID2 ))
			SET @Flag = 1

		FETCH NEXT FROM PID_cursor into @PID2
	END;
	CLOSE PID_cursor
	DEALLOCATE PID_cursor

	IF (@Flag=1)
		select 'OPEN'
	else
		select 'Proses Opname sudah disimpan, Silahkann memproses PID yang baru.'
END

GO


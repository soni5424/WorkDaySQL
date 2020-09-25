USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[GA_PSupportSaveProjectApprove]    Script Date: 07/04/2020 09.45.31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Ferry Hartono>
-- Create date: <Create Date,,11/06/2019>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GA_PSupportSaveProjectApprove]
	-- Add the parameters for the stored procedure here
	@ProjectID				SQL_VARIANT,
	@PICUtama				SQL_VARIANT,
	@RequestVendor			SQL_VARIANT,
	@RequestPIC				SQL_VARIANT,
	@RequestPerlengkapan	SQL_VARIANT,
	@UserID					SQL_VARIANT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE
		@Status					VARCHAR(16),
		@StatusOld				VARCHAR(16),
		@OldRequestVendor		VARCHAR(5),
		@OldRequestPIC			VARCHAR(5),
		@OldRequestPerlengkapan	VARCHAR(5),
		@CatatanVendor			VARCHAR(1000),
		@CatatanPIC				VARCHAR(1000),
		@CatatanPerlengkapan	VARCHAR(1000)

	SET @OldRequestVendor = ''
	SET @OldRequestPIC = ''
	SET @OldRequestPerlengkapan = ''

	SET @Status = CASE
		WHEN CONVERT(VARCHAR(5), @RequestVendor) = 'YA' THEN 'PendingChecked'
		--WHEN CONVERT(VARCHAR(5), @RequestPIC) = 'YA' THEN 'PendingChecked'
		WHEN CONVERT(VARCHAR(5), @RequestPerlengkapan) = 'YA' THEN 'PendingChecked'
		ELSE 'Approve'
	END
	
	SELECT TOP 1 @StatusOld = Status
	FROM GA_Support
	WHERE TrxID = @ProjectID
	ORDER BY Tanggal DESC

	SELECT TOP 1 @CatatanVendor = CatatanRequestVendor, @CatatanPIC = CatatanRequestPIC, @CatatanPerlengkapan = CatatanRequestPerlengkapan
	FROM GA_Support_History_Request
	WHERE TrxID = @ProjectID
	ORDER BY Tanggal DESC

    -- Insert statements for procedure here
	IF (@StatusOld <> 'Start') BEGIN
		UPDATE GA_Support SET Status = @Status, UserIDGA = dbo.GA_FSupportGetUserEmployee(CONVERT(VARCHAR(8), @PICUtama), 'User') WHERE TrxID = @ProjectID
		INSERT INTO GA_Support_History_Status VALUES (CONVERT(VARCHAR(10), @ProjectID), GETDATE(), CONVERT(VARCHAR(8), @UserID), @Status, @StatusOld)
	END
	IF (@StatusOld = 'Start' AND CONVERT(VARCHAR(5), @RequestPIC) = 'YA') BEGIN
		UPDATE GA_Scheduled
		SET TanggalNonAktif = CONVERT(VARCHAR, GETDATE(), 112)
		WHERE TrxID = @ProjectID
		AND UserIDGA IN (
			SELECT dbo.GA_FSupportGetUserEmployee(CONVERT(VARCHAR(8), EmployeeID), 'User')
			FROM GA_Support_PIC_Tambahan
			WHERE TrxID = CONVERT(VARCHAR(10), @ProjectID)
		)
	END
	UPDATE GA_Support_Request SET FlagChecked = '1' WHERE TrxID = CONVERT(VARCHAR(10), @ProjectID)
	INSERT INTO GA_Support_History_Request VALUES (
		CONVERT(VARCHAR(10), @ProjectID),
		GETDATE(),
		CONVERT(VARCHAR(5), @RequestVendor),
		@OldRequestVendor,
		CONVERT(VARCHAR(5), @RequestPIC),
		@OldRequestPIC,
		CONVERT(VARCHAR(5), @RequestPerlengkapan),
		@OldRequestPerlengkapan,
		CONVERT(VARCHAR(8), @UserID),
		@CatatanVendor,
		@CatatanPIC,
		@CatatanPerlengkapan
	)
	INSERT INTO GA_Support_History_UserIDGA VALUES (CONVERT(VARCHAR(10), @ProjectID), dbo.GA_FSupportGetUserEmployee(CONVERT(VARCHAR(8), @PICUtama), 'User'), GETDATE())

	SELECT @ProjectID
END
GO


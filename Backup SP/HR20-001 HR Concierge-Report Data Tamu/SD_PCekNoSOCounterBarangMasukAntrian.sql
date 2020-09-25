USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[HR_PT_CekOtorisasiAdmin]    Script Date: 25/08/2020 09.43.44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |10/01/2020|
-- Description:	|Cek Otorisasi Login Admin|
-- Project:		|HR19-002 Psikotes Online|
-- =============================================
ALTER PROCEDURE [dbo].[HR_PT_CekOtorisasiAdmin]
	@userID			varchar(10),
	@pass			varchar(128),
	@kodeStore		varchar(2)
AS
BEGIN
	SET NOCOUNT ON
	
	IF EXISTS (SELECT * FROM MasterUser WHERE UserID = @userID AND Password = @pass)
	BEGIN
		IF EXISTS (SELECT KodePermission
				   FROM GrupToPermission
				   WHERE KodeGrupPermission IN (SELECT DISTINCT KodeGrupPermission
												FROM UserToGrupPermission
												WHERE UserId = @userID AND (KodeStore = '--' OR KodeStore = @kodeStore))
					     AND KodePermission = 'HRPTOtorisasiAdmin')
		BEGIN
			SELECT NamaUser
			FROM MasterUser
			WHERE UserID = @userID AND Password = @pass
		END
		ELSE
		BEGIN
			SELECT 'Akses ditolak' as 'Message'
		END
	END
	ELSE
	BEGIN
		SELECT 'UserID atau Password salah' as 'Message'
	END
END


GO


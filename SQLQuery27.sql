USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[MB_PUpdateCharValue]    Script Date: 02/11/2022 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create date	: 11.2.22
-- Description	: Update Char Value
-- =============================================
Create PROCEDURE [dbo].[MB_PUpdateCharValue]
	@Char		varchar(30),
	@CharValue	varchar(100),
	@ValDesc	varchar(100),
	@UserID		varchar(8)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [Hartono].[dbo].[SAP_ConfigCharacteristicValue]
	SET 	  
	  [ValueDesc] = @ValDesc,
	  [Date] = getdate(),
	  [UserInput] = @UserID
	WHERE 
		[Characteristic] = @Char
		AND [Value] = @CharValue
END

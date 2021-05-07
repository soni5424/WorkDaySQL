USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[BMS_PSaveLogRegisterArticleImageDataTemp]    Script Date: 04/05/2021 09:37:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Ricky|
-- Create date: |31/03/2021|
-- Description:	|Save Log Register Article Image Data Temp|
-- Project:		|BMS 2021|
-- =============================================
CREATE PROCEDURE [dbo].[BMS_PSaveLogRegisterArticleImageDataTemp]
(
	@trxID			varchar(17),
	@article		varchar(22),
	@filePath		varchar(500),
	@status			int,
	@statusNote		varchar(250),
	@userIDLogin	varchar(20)
)
AS
BEGIN	
	INSERT INTO BMS_RegisterArticleImageLog (TrxID, Article, FilePath, Status, StatusNote, StatusDate, UserStatus)
	VALUES(@trxID, @article, @filePath,@status, @statusNote, getdate(), @userIDLogin)
END
GO


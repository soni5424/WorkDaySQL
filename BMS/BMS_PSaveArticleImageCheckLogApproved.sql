USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[BMS_PSaveArticleImageCheckLogApproved]    Script Date: 04/05/2021 09:37:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Ricky|
-- Create date: |11/01/2021|
-- Description:	|Save Article Image Check Log Approved|
-- Project:		|BMS 2021|
-- =============================================
CREATE PROCEDURE [dbo].[BMS_PSaveArticleImageCheckLogApproved]
(
	@trxID			varchar(17),
	@article		varchar(22),
	@status			int,
	@statusNote		varchar(250),
	@userIDLogin	varchar(20)
)
AS
BEGIN	
	INSERT INTO BMS_ArticleImageCheckApprovedLog
	VALUES(@trxID, @article, @status, @statusNote, getdate(), @userIDLogin)
END
GO


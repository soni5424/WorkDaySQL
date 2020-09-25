USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[FI_PGetFinishSupportFollowUp]    Script Date: 16/06/2020 20.24.12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			|David C.H|
-- Create date:		|28/04/2020|
-- Description:		|Get Finish SupportFollowUp|
-- Project:			|FI20-003 Internal Finance Support System Rev 2|
-- =============================================
ALTER PROCEDURE [dbo].[FI_PGetFinishSupportFollowUp]
@SupportReqNo varchar(16)
AS
BEGIN 
select SupportReqNo,CONVERT (varchar,RequestDate,103)+' '+CONVERT (varchar(5),RequestDate,108) RequestDate,A.SupportID,SupportDesc,Subject,SupportNote,SupportAttachment,A.Status,CONVERT(varchar,FollowUpDate,103)FollowUpDate,(SELECT NamaUser from masteruser where userid=UserFollowUp) UserFollowUp,CONVERT(varchar,FinishingTarget,103)FinishingTarget,FollowUpNote,FollowUpAttachment, KodeStore,
ISNULL(FinishUseriD,'')FinishUseriD,ISNULL(CONVERT(varchar,StatusFinish),'') StatusFinish,ISNULL(CONVERT(varchar,FinishDate,103)+' '+CONVERT (varchar(5),RequestDate,108),'') FinishDate,ISNULL(FinishNote,'')FinishNote,ISNULL(FinishAttachment,'') FinishAttachment,
ISNULL((select namauser from masteruser B where B.UserID=FinishUserID),'')NamaUserID
from FI_TrxSupportRequest A join FI_MasterSupportID B on A.SupportID=B.SupportID
where SupportReqNo=@SupportReqNo
END
GO


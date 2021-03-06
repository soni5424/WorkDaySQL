USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[FI_PGetSupportDashboard]    Script Date: 13/05/2020 13.11.29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			|David C.H|
-- Create date:		|19/03/2020|
-- Description:		|Get Support Dashboard|
-- Project:			|FI20-0013 Internal Finance Support System|
-- =============================================
ALTER PROCEDURE [dbo].[FI_PGetSupportDashboard]
@SupportID varchar(50),
@Status varchar(50),
@UserID varchar(10),
@KodeStore varchar(2)
AS
BEGIN 
DECLARE @StatusID bit

IF (@Status='APPROVED')
	SET @StatusID = 1
ELSE IF (@Status='REJECTED')
	SET @StatusID = 0

IF(@Status='ALL')
	BEGIN
	SELECT DISTINCT(A.SupportID) SupportID,Convert(varchar,RequestDate,103)+' '+Convert(varchar(5),RequestDate,108) RequestDate, SupportDesc,(SELECT NamaUser from MasterUser where UserID=A.UserID)RequestedBy,Subject,
		CASE WHEN A.Status is null THEN 'NEW'
	WHEN A.Status ='1' then 'APPROVED'
	WHEN A.Status='0' then 'REJECTED'
	end as status
, ISNULL((SELECT NamaUser from MasterUser where UserID=UserFollowUp),'')StatusBy,ISNULL(Convert(varchar,FollowUpdate,103)+' '+Convert(varchar(5),FollowUpdate,108),'') StatusDate
	from  FI_TrxSupportRequest A join FI_MasterSupportID B on A.SupportID=B.SupportID 
	join FI_MasterSupportIDDetail C on C.SupportID=B.SupportID 
	join MasterUser D on D.KodeBarcode=C.KodeBarcode
	where A.SupportID like '%'+@SupportID+'%' and D.UserID like '%'+@UserID+ '%' and A.KodeStore like '%'+@KodeStore+'%'
	END
ELSE IF (@Status='NEW')
	BEGIN
	SELECT DISTINCT(A.SupportID) SupportID,Convert(varchar,RequestDate,103)+' '+Convert(varchar(5),RequestDate,108) RequestDate, SupportDesc,(SELECT NamaUser from MasterUser where UserID=A.UserID)RequestedBy,Subject,
		CASE WHEN A.Status is null THEN 'NEW'
	WHEN A.Status ='1' then 'APPROVED'
	WHEN A.Status='0' then 'REJECTED'
	end as status,A.SupportID
, ISNULL((SELECT NamaUser from MasterUser where UserID=UserFollowUp),'')StatusBy,ISNULL(Convert(varchar,FollowUpdate,103)+' '+Convert(varchar(5),FollowUpdate,108),'') StatusDate
	from  FI_TrxSupportRequest A join FI_MasterSupportID B on A.SupportID=B.SupportID 
	join FI_MasterSupportIDDetail C on C.SupportID=B.SupportID 
	join MasterUser D on D.KodeBarcode=C.KodeBarcode
	where A.SupportID like '%'+@SupportID+'%' and A.Status is null and  D.UserID like '%'+@UserID+ '%' and A.KodeStore like '%'+@KodeStore+'%'
	END
ELSE
	BEGIN
	SELECT DISTINCT(A.SupportID) SupportID, Convert(varchar,RequestDate,103)+' '+Convert(varchar(5),RequestDate,108) RequestDate, SupportDesc,(SELECT NamaUser from MasterUser where UserID=A.UserID)RequestedBy,Subject,
		CASE WHEN A.Status is null THEN 'NEW'
	WHEN A.Status ='1' then 'APPROVED'
	WHEN A.Status='0' then 'REJECTED'
	end as status
, ISNULL((SELECT NamaUser from MasterUser where UserID=UserFollowUp),'')StatusBy,ISNULL(Convert(varchar,FollowUpdate,103)+' '+Convert(varchar(5),FollowUpdate,108),'') StatusDate
	from  FI_TrxSupportRequest A join FI_MasterSupportID B on A.SupportID=B.SupportID 
	join FI_MasterSupportIDDetail C on C.SupportID=B.SupportID 
	join MasterUser D on D.KodeBarcode=C.KodeBarcode
	where A.SupportID like '%'+@SupportID+'%' and A.Status =@StatusID and  D.UserID like '%'+@UserID+ '%' and A.KodeStore like '%'+@KodeStore+'%'
	END
END

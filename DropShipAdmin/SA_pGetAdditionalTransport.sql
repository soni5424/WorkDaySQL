USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SA_pGetAdditionalTransport]    Script Date: 16/03/2021 13.43.17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SA_pGetAdditionalTransport]
@Mode int
AS

IF(@Mode='1')
begin
	select Nilai,Nama from MasterParameter where Nama= 'AdditionalTransport'
end
/*
ELSE IF (@Mode='2')
begin
	select Nilai,Nama from masterpilihan where grup='StoreAdditionalTransport'
end
ELSE IF (@Mode='3')
begin
	select Nilai,Nama from masterpilihan where grup='StoreKirimAdditionalTransport'
end
 */
GO


USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[MM_GetDropshipAdminPrice]    Script Date: 16/03/2021 13.43.24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		|Rio|
-- Create date: |25/02/2021|
-- Description:	|Get Dropship Admin Lineitem Price|
-- Project:		|Auto Add Line Item Dropship Admin|
-- =============================================
CREATE PROCEDURE [dbo].[MM_GetDropshipAdminPrice]
	@kodeStore	char(2)
AS
BEGIN
	set dateformat dmy
	
	SELECT TOP 1 KBERT as 'Price'
	FROM SAP_RETAIL_PRICE_VKP0 a
	INNER JOIN MasterStore b ON a.WERKS = b.Sales_Off
	INNER JOIN MasterParameter c ON a.MATNR = c.Nilai AND c.Nama = 'AdditionalTransport'
	WHERE b.KodeStore = @kodeStore
	ORDER BY a.PRICEID DESC
END
GO


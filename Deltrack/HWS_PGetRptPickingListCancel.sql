SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: 22.9.20
-- Description	: ZPick - Report Picking List Cancel
-- =============================================

alter PROCEDURE HWS_PGetRptPickingListCancel
	@UserLogin	varchar(8),
	@TglAwal	varchar(10),
	@TglAkhir	varchar(10),
	@Site		varchar(4),
	@Sloc		varchar(4)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		A.TransactID,
		A.DO,
		A.Item,
		A.Article,
		A.Sloc,
		CONVERT(varchar(10), A.DeliveryDate, 103) As DeliveryDate,
		A.ShippingPoint,
		A.Shipment,
		A.Faktur,
		A.UserID,
		A.WorkStation,
		CONVERT(varchar(10), A.Tanggal, 103) AS Tanggal,
		A.Site
	FROM 
		HWS_PilihZPICKCancel A
		INNER JOIN MasterStore B ON A.Site=B.SALES_OFF
		INNER JOIN SAP_SetupShippingPoint C ON B.KodeStore=C.KodeStore
	WHERE
		A.UserID=@UserLogin
		AND dbo.getonlydate(A.Tanggal) >= CONVERT(Datetime, @TglAwal, 103) 
		AND dbo.getonlydate(A.Tanggal) <= CONVERT(Datetime, @TglAkhir, 103)
		AND A.Site LIKE '%'+@Site+'%'
		AND A.Sloc LIKE '%'+@Sloc+'%'
END
GO
USE HARTONO
GO
-- =============================================
-- Created By	: Soni Gunawan
-- Create Date	: .10.20
-- Description	: Save Zpick
-- =============================================
alter PROCEDURE HWS_PSavePickCancel
    @DO             varchar(10),
    @Item           int,
    @Article        varchar(30),
    @Sloc           varchar(4),
    @DeliveryDate   varchar(10),
    @ShippingPoint  varchar(4),
    @Shipment       varchar(6),
    @Faktur         varchar(15),
    @UserID         varchar(7),
    @WorkStation    varchar(3),
    @Site           varchar(4)
AS
BEGIN
	
    INSERT INTO [dbo].[HWS_PilihZPICKCancel] (
        [DO]
        ,[Item]
        ,[Article]
        ,[Sloc]
        ,[DeliveryDate]
        ,[ShippingPoint]
        ,[Shipment]
        ,[Faktur]
        ,[UserID]
        ,[WorkStation]
        ,[Tanggal]
        ,[Site]
    ) VALUES (
        @DO,
        @Item,
        @Article,
        @Sloc,
        CONVERT(Datetime, @DeliveryDate, 103),
        @ShippingPoint,
        @Shipment,
        @Faktur,
        @UserID,
        @WorkStation,
        getdate(),
        @Site
    )

END
GO
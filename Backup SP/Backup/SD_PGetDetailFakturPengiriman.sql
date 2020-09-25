USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[SD_PGetDetailFakturPengiriman]    Script Date: 08/04/2020 14.03.15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Modified By		: Soni Gunawan
-- Modified Date	: 20.8.18
-- Description		: SAP_MasterUser to MasterUser 

-- Modified By		: Yongky
-- Modified Date	: 27/11/2018
-- Description		: Ganti like @NoFaktur dengan =
-- =============================================

ALTER PROCEDURE [dbo].[SD_PGetDetailFakturPengiriman]
	@NoFaktur varchar(18)
AS
BEGIN
	SELECT 
		FK.*,
		isnull(SD.ShipmentNo_TKNUM,'') As NoShipment, 
		SH.CreatedOnDate_ERDAT As TglShipment,
		isnull(SH.ShipmentNo_TKNUM,'') As NoSuratJalan,
		isnull(SH.ContainerID_SIGNI,'') As Armada,
		isnull(MU.NamaUser,'') As Driver,
		CASE
			WHEN 
				SH.Planned_STDIS=1
				AND SH.CheckIn_STREG=0
				AND SH.LoadStart_STLBG=0
				AND SH.LoadEnd_STLAD=0
				AND SH.ShipmentCompletion_STABF=0
				AND SH.ShipmentStart_STTBG=0
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Document Shipment Dibuat'
			WHEN
				SH.CheckIn_STREG=1
				AND SH.LoadStart_STLBG=0
				AND SH.LoadEnd_STLAD=0
				AND SH.ShipmentCompletion_STABF=0
				AND SH.ShipmentStart_STTBG=0
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Mobil Siap Diisi Barang'
			WHEN
				SH.LoadStart_STLBG=1
				AND SH.LoadEnd_STLAD=0
				AND SH.ShipmentCompletion_STABF=0
				AND SH.ShipmentStart_STTBG=0
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Barang Siap Dimasukkan Ke Mobil'
			WHEN
				SH.LoadEnd_STLAD=1
				AND SH.ShipmentCompletion_STABF=0
				AND SH.ShipmentStart_STTBG=0
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Barang Sudah Dimasukkan ke Mobil'
			WHEN
				SH.ShipmentCompletion_STABF=1
				AND SH.ShipmentStart_STTBG=0
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Dokumen Shipment Siap'
			WHEN
				SH.ShipmentStart_STTBG=1
				AND SH.ShipmentEnd_STTEN=0
			THEN 'Mobil Dalam Perjalanan'
			WHEN
				SH.ShipmentEnd_STTEN=1
			THEN 'Mobil Kembali'
			ELSE ''
		END StatusShipment,
		CASE
			WHEN SH.ShipmentEnd_STTEN=1 THEN 'Terkirim'
			WHEN 
				SH.Planned_STDIS=1 
				AND CheckIn_STREG=1
				AND LoadStart_STLBG=1
				AND LoadEnd_STLAD=1	
				AND ShipmentCompletion_STABF=1 
				AND ShipmentStart_STTBG=1 
				AND SH.ShipmentEnd_STTEN=0
				AND (SELECT COUNT(*) FROM SAP_ShipmentDetailDoc_LIPS 
						WHERE refdocument_vgbel=FK.NoSOSAP_SalesDocument) > 1 
			THEN 'Kembali (Damage/Gagal Terkirim)'
			ELSE ''
		END As StatusTerkirim,
		CASE
			WHEN SH.ShipmentCompletion_STABF=1 THEN SH.ActShipCompleteDate_DTABF
			ELSE ''
		END As JadwalKirim,
		FK.StatusPembayaran
	FROM (
		SELECT c.nofaktur AS NoFakturInduk,
			c.KeteranganSO,
			c.Tanggal,
			c.TglPengiriman,
			c.NamaPenerima,
			c.AlamatPenerima,
			c.AlamatPenerima2_STR_SUPPL3,
			c.AlamatPenerima3_LOCATION,
			c.AlamatPenerima4_STR_SUPPL1,
			c.AlamatPenerima5_STR_SUPPL2,
			c.TelpPenerima,
			c.NoSOSAP_SalesDocument, 
			X.StatusPembayaran
		FROM (
				SELECT DISTINCT 
					d.nofaktur,
					d.tglpengiriman,
					d.noso,
					d.keteranganso,
					d.tanggal,
					d.namapenerima,
					d.alamatpenerima,
					d.AlamatPenerima2_STR_SUPPL3,
					d.AlamatPenerima3_LOCATION,
					d.AlamatPenerima4_STR_SUPPL1,
					d.AlamatPenerima5_STR_SUPPL2,
					d.telppenerima,
					d.NoSOSAP_SalesDocument
				FROM 
					trxfaktur d,
					trxfakturdetail r 
				WHERE 
					d.nofaktur=r.nofaktur
					--AND d.NoFaktur LIKE '%'+@NoFaktur+'%'
					AND d.NoFaktur = @NoFaktur --27/11/2018
			) c,
			trxfaktur x
		WHERE 
			c.noso=x.noso 
--			and x.nofaktur='FK-07-S50-00004'
		) FK --END FK
	LEFT JOIN SAP_ShipmentDetailDoc_LIPS SDD ON FK.NoSOSAP_SalesDocument = SDD.RefDocument_VGBEL
	LEFT JOIN SAP_ShipmentDetail_VTTP SD ON SDD.DeliveryNo_VBELN = SD.DeliveryNo_VBELN
	LEFT JOIN SAP_ShipmentHeader_VTTK SH ON SH.ShipmentNo_TKNUM = SD.ShipmentNo_TKNUM
	LEFT JOIN SAP_ShipmentPartner_VTPA PA ON  PA.PartnerFunc_PARVW = 'ZD' AND ShipmentNo_VBELN = SH.ShipmentNo_TKNUM
	LEFT JOIN MasterUser MU ON MU.kodebarcode =  substring(PA.Vendor_LIFNR, 3, len(PA.Vendor_LIFNR-3))
END
GO


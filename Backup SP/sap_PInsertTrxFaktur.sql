USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[sap_PInsertTrxFaktur]    Script Date: 17/09/2020 08.45.22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Modif By		: Ferry Hartono
-- Modif Date	: 13.7.20
-- Description	: +DoubleVal Cek SO Already Faktur
-- =============================================

ALTER PROCEDURE [dbo].[sap_PInsertTrxFaktur] (
    @NoFaktur				varchar(18),
    @JenisFaktur			varchar(2),
    @Tanggal				datetime,
    @TglPengiriman			datetime,
    @NoMember				varchar(11),
    @NamaPemesan			varchar(50),
    @NamaPembeli			varchar(50),
    @AlamatPembeli			varchar(50),
    @KodeWilayahPembeli		varchar(30),
    @TelpPembeli			varchar(50),
    @NamaPenerima			varchar(50),
    @AlamatPenerima			varchar(500),
    @KodeWilayahPenerima	varchar(30),
    @TelpPenerima			varchar(50),
    @KodeUserKasir			varchar(10),
    @KodeStore				varchar(2),
    @KodeWorkStation		varchar(3),
    @NoSO					varchar(16),
    @RevisionSO				int,
    @StatusProses			bit,
    @JumlahPrint			int,
    @JenisTransaksi			varchar(2),
    @StatusPemasangan		bit,
    @TotalHarga				decimal(18,2),
    @TotalPembayaran		decimal(18,2),
    @PointSalesFaktur		decimal(10,2),
    @PointRewardMember		decimal(10,2),
    @StatusPenyerahan		varchar(2),
    @StatusPembayaran		varchar(50),
	@IsPerlengkapan			bit,
	@TglPemasangan			datetime,
	@Charge					decimal(18,2),
	@NamaPenerimaPlk		varchar(50),
	@AlamatPenerimaPlk		varchar(500),
	@KodeWilayahPenerimaPlk	varchar(30),
	@TelpPenerimaPlk		varchar(50),
	@TotalPointRedeem		int,
	@StatusPenyerahanPlk	varchar(2),
	@GroupPengiriman		varchar(50),
	@KodeSPG				varchar(50),
	@KodeSales				varchar(50),
	@PointRewardTo			varchar(50),
	@FakturPajak			bit,
	@Keterangan				varchar(200),
	@KeteranganSO			varchar(200),
	@KeteranganPlk			varchar(200),
	@JenisKredit			bit,
    @NoSOSAP_SALESDOCUMENT		varchar(10),
    @AlamatPenerima2_STR_SUPPL3	varchar(50),
    @AlamatPenerima3_LOCATION	varchar(40),
    @AlamatPenerima4_STR_SUPPL1 varchar(40),
    @AlamatPenerima5_STR_SUPPL2 varchar(40),
	@SALES_OFF				varchar(4),
	@SM						varchar(50),
	@ASM1					varchar(50),
	@ASM2					varchar(50),
	@ASM3					varchar(50),
	@ASM4					varchar(50),
	@ASM5					varchar(50)
) AS
BEGIN 
	IF EXISTS (SELECT * FROM TrxFaktur WHERE NoSO = @NoSO)
	BEGIN
		DECLARE @ErrorMsg VARCHAR(MAX)
		SELECT @ErrorMsg = 'Nomor SO ' + NoSO + ' telah difakturkan dengan nomor faktur ' + NoFaktur FROM TrxFaktur WHERE NoSO = @NoSO
		RAISERROR(@ErrorMsg, 16, 1)
	END

	declare  @nomembersap varchar(10)
	select top 1 @nomembersap=CustID_KUNNR from mastermember where nomember=@NoMember

	INSERT TrxFaktur (
		NoFaktur,
		JenisFaktur,
		Tanggal,
		TglPengiriman,
		NoMember,
		NamaPemesan,
		NamaPembeli,
		AlamatPembeli,
		KodeWilayahPembeli,
		TelpPembeli,
		NamaPenerima,
		AlamatPenerima,
		KodeWilayahPenerima,
		TelpPenerima,
		KodeUserKasir,
		KodeStore,
		KodeWorkStation,
		NoSO,
		RevisionSO,
		StatusProses,
		JumlahPrint,
		JenisTransaksi,
		StatusPemasangan,
		TotalHarga,
		TotalPembayaran,
		PointSalesFaktur,
		PointRewardMember,
		StatusPenyerahan,
		StatusPembayaran,
 		IsPerlengkapan,
		TglPemasangan,
		Charge,
		NamaPenerimaPlk,
		AlamatPenerimaPlk,
		KodeWilayahPenerimaPlk,
		TelpPenerimaPlk,
		TotalPointRedeem,
		StatusPenyerahanPlk,
		GroupPengiriman,
		KodeSPG,
		KodeSales,
		PointRewardTo,
		FakturPajak,
		Keterangan,
		KeteranganSO,
		KeteranganPlk,
		JenisKredit,
		NoSOSAP_SALESDOCUMENT,
		CustID_KUNNR,
		AlamatPenerima2_STR_SUPPL3,
		AlamatPenerima3_LOCATION,
		AlamatPenerima4_STR_SUPPL1,
		AlamatPenerima5_STR_SUPPL2,
		SALES_OFF,
		SM,
		ASM1,
		ASM2,
		ASM3,
		ASM4,
		ASM5
	) VALUES (
		@NoFaktur,
		@JenisFaktur,
		getdate(),
		@TglPengiriman,
		@NoMember,
		@NamaPemesan,
		@NamaPembeli,
		@AlamatPembeli,
		@KodeWilayahPembeli,
		@TelpPembeli,
		@NamaPenerima,
		@AlamatPenerima,
		@KodeWilayahPenerima,
		@TelpPenerima,
		@KodeUserKasir,
		@KodeStore,
		@KodeWorkStation,
		@NoSO,
		@RevisionSO,
		@StatusProses,
		@JumlahPrint,
		@JenisTransaksi,
		@StatusPemasangan,
		@TotalHarga,
		@TotalPembayaran,
		@PointSalesFaktur,
		@PointRewardMember,
		@StatusPenyerahan,
		@StatusPembayaran,
		@IsPerlengkapan,
		@TglPemasangan,
		@TotalHarga,
		@NamaPenerimaPlk,
		@AlamatPenerimaPlk,
		@KodeWilayahPenerimaPlk,
		@TelpPenerimaPlk,
		@TotalPointRedeem,
		@StatusPenyerahanPlk,
		@GroupPengiriman,
		@KodeSPG,
		@KodeSales,
		@PointRewardTo,
		@FakturPajak,
		@Keterangan,
		@KeteranganSO,
		@KeteranganPlk,
		@JenisKredit,
		@NoSOSAP_SALESDOCUMENT,
		@nomembersap,
		@AlamatPenerima2_STR_SUPPL3,
		@AlamatPenerima3_LOCATION,
		@AlamatPenerima4_STR_SUPPL1,
		@AlamatPenerima5_STR_SUPPL2,
		@SALES_OFF,
		@SM,
		@ASM1,
		@ASM2,
		@ASM3,
		@ASM4,
		@ASM5
	)

	update TrxSO set StatusInvoiced = 1 where NoSO = @NoSO
	update MasterMember set Piutang = COALESCE(Piutang,0) + (@TotalHarga - @TotalPembayaran) where NoMember = @NoMember
	insert into TrxFakturBayarVPR 
	select @NoFaktur, 0,'',0,'',0,'',''

	if exists (select * from trxsokirim where noso = @NoSO and deliverycenter = 1) 
		if not exists (select * from TrxFakturKirimDvc where noso = @NoSO)
		begin
			insert into TrxFakturKirimDvc
			select distinct @NoSO, getdate(), 0,kodestoredepo 
			from trxsokirim where noso= @NoSO
		end
END
GO


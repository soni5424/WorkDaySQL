USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[TI_PPengecekanCetak]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		: Daniel
-- Create date	: <Create Date,,>
-- Description	: <Description,,>

-- Modified By	: Rini Handini
-- Modified Date: 16/04/2021
-- Description	: Perbaikan Bug

-- Modified By	: Rini Handini
-- Modified Date: 20/04/2021
-- Description	: Ganti NoMember ke PointRewardTo

-- Modified By	: Soni.Gunawan
-- Modified Date: 29/03/2023
-- Description	: Fix StatusBatal = 0 diganti menjadi StatusBatal IS NULL

-- =============================================

CREATE PROCEDURE [dbo].[TI_PPengecekanCetak]
	@NoPromo varchar(50),
	@NoFaktur varchar(50),
	@Tanda varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	if(@Tanda = 1)
	Begin
		declare @HasilMember varchar(50)
		set @HasilMember = (select case when memberonly = '' then '0' else memberonly end from pr_masterpromo where kodepromo = @NoPromo)
		if(@HasilMember = '0')
			begin
				select 'berhasil' as hasil
			end
		else if(@HasilMember = 'X' or @HasilMember = 'x')
			begin	
				select COALESCE((select jenismember from trxfaktur LEFT JOIN mastermember 
				ON trxfaktur.pointrewardto = mastermember.nomember 
				where nofaktur = @NoFaktur and jenismember = 'P'),'0')as hasil
			end
	end
	if(@Tanda = 2)
	begin
		declare @MasterPromoLimit int, @NilaiTradeIn int,@hasilPerbandingan int
		set @MasterPromoLimit = ( select limitbycustomer from pr_masterpromo where kodepromo = @NoPromo)
		
		set @NilaiTradeIn = (select count(*) from pr_trxformtradein where statusbatal is NULL and kodepromo = @NoPromo and pointrewardto in(select pointrewardto from trxfaktur where nofaktur= @NoFaktur )) -- Soni 29/3/23
		if(@MasterPromoLimit > 0)
		begin
			if(@NilaiTradeIn < @MasterPromoLimit)
				begin
					select '1' as hasil
				end
			else
				begin
					select '0' as hasil
				end
		end
		else
			begin
				select '1' as hasil
		end
	end
END
GO

/****** Object:  StoredProcedure [dbo].[PR_PGetStoreGP]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create date	: 27.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PGetStoreGP]
AS
BEGIN
	SELECT 
		cast (0 as bit) AS PickKodeStore, 
		KodeStore, 
		NamaLokasi, 
		KodeStoreGP
	FROM MasterStore
	WHERE KodeStore != '00'
END

GO

/****** Object:  StoredProcedure [dbo].[PR_PUpdateTradeInBerkuota]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create Date	: 27.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PUpdateTradeInBerkuota]
	@KodeStore		varchar(50),
	@KodePromo		varchar(50),
	@ModifiedBy		varchar(50),
	@Status			int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota
	SET 
		[Status] = @Status
		,[ModifiedBy] = @ModifiedBy
		,[ModifiedOn] = getdate()
	WHERE [Store] = @KodeStore
		AND [KodePromo] = @KodePromo

END
GO

/****** Object:  StoredProcedure [dbo].[PR_PGetTradeInBerkuota]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create date	: 27.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PGetTradeInBerkuota]
	@KodePromo		varchar(50)=''	
AS
BEGIN
	SET NOCOUNT ON;

	IF (@KodePromo != '')
		SELECT 
			(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=Store) AS KodeStoreGP
			,[Store]
			,[KodePromo]
			,[NamaPromo]
			, CASE 
				WHEN [Status] = 0 THEN 'Deactivate'
				WHEN [Status] = 1 THEN 'Active'
			  END Status
			,[CreatedBy]
			,[CraetedOn]
			,[ModifiedBy]
			,[ModifiedOn]
		FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota
		WHERE KodePromo=@KodePromo
	ELSE
		SELECT 
			(SELECT KodeStoreGP FROM MasterStore WHERE KodeStore=Store) AS KodeStoreGP
			,[Store]
			,[KodePromo]
			,[NamaPromo]
			, CASE 
				WHEN [Status] = 0 THEN 'Deactivate'
				WHEN [Status] = 1 THEN 'Active'
			  END Status
			,[CreatedBy]
			,[CraetedOn]
			,[ModifiedBy]
			,[ModifiedOn]
		FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota
END
GO

/****** Object:  StoredProcedure [dbo].[PR_PValidTradeInBerkuota]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create date	: 28.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PValidTradeInBerkuota]
	@KodePromo		varchar(50),
	@KodeStoreGP	varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @KodeStore		varchar(50)
	SELECT @KodeStore=KodeStore FROM MasterStore WHERE KodeStoreGP=@KodeStoreGP

	IF (EXISTS(SELECT * FROM PR_MasterPromo WHERE KodePromo=@KodePromo))
	BEGIN
		IF (EXISTS(SELECT * FROM PR_MasterPromo WHERE KodePromo=@KodePromo AND TanggalAkhir<getdate()))
			SELECT 'Periode Promo ini sudah expired'
		ELSE IF (EXISTS(SELECT * FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota  WHERE KodePromo=@KodePromo AND Store=@KodeStore))
			SELECT 'Promo sudah Termasuk dalam Trade In Berkuota'
		ELSE
			SELECT ''
	END
	ELSE 
		SELECT 'Kode Promo tidak terdaftar'
END
GO

/****** Object:  StoredProcedure [dbo].[PR_PSaveTradeInBerkuota]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create Date	: 27.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PSaveTradeInBerkuota]
	@KodeStoreGP	varchar(50),
	@KodePromo		varchar(50),
	@NamaPromo		varchar(50),
	@CreatedBy		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @KodeStore		varchar(50)
	SELECT @KodeStore = KodeStore FROM MasterStore WHERE KodeStoreGP=@KodeStoreGP

	IF (NOT EXISTS(SELECT * FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota WHERE KodePromo=@KodePromo AND Store=@KodeStore))
		INSERT INTO [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota (
			[Store]
			,[KodePromo]
			,[NamaPromo]
			,[Status]
			,[CreatedBy]
			,[CraetedOn]
		) VALUES (
			@KodeStore,
			@KodePromo,
			@NamaPromo,
			1,
			@CreatedBy,
			getdate()
		)
END
GO

/****** Object:  StoredProcedure [dbo].[PR_PValidExcludePromoTradeIn]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create date	: 28.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PValidExcludePromoTradeIn]
	@KodePromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF (EXISTS(SELECT * FROM PR_MasterPromo WHERE KodePromo=@KodePromo))
	BEGIN
		IF (EXISTS(SELECT * FROM PR_MasterPromo WHERE KodePromo=@KodePromo AND TanggalAkhir<getdate()))
			SELECT 'Periode Promo ini sudah expired'
		ELSE IF (EXISTS(SELECT * FROM PR_MasterPromoExcludeTradeIn WHERE KodePromo=@KodePromo))
			SELECT 'Promo sudah Termasuk dalam Exclude Trade In'
		ELSE
			SELECT ''
	END
	ELSE 
		SELECT 'Kode Promo tidak terdaftar'
END
GO

/****** Object:  StoredProcedure [dbo].[PR_PSaveExcludePromoTradeIn]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create date	: 28.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PSaveExcludePromoTradeIn]
	@KodePromo		varchar(50),
	@NamaPromo		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF (NOT EXISTS(SELECT * FROM PR_MasterPromoExcludeTradeIn WHERE KodePromo=@KodePromo))
		INSERT INTO [dbo].[PR_MasterPromoExcludeTradeIn] (
			[KodePromo]
			,[NamaPromo]
		) VALUES (
			@KodePromo,
			@NamaPromo
		)

END
GO

/****** Object:  StoredProcedure [dbo].[PR_PDeleteExcludePromoTradeIn]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create Date	: 26.1.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PDeleteExcludePromoTradeIn]
	@KodePromo	varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[PR_MasterPromoExcludeTradeIn]
	WHERE KodePromo=@KodePromo

END
GO

/****** Object:  StoredProcedure [dbo].[PR_PGetExcludePromoTradeIn]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Created By	: Soni.Gunawan
-- Create Date	: 26.1.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[PR_PGetExcludePromoTradeIn]
	@KodePromo	varchar(50) = ''
AS
BEGIN
	SET NOCOUNT ON;

	IF (@KodePromo = '')
		SELECT 
			[KodePromo]
			,[NamaPromo]
		FROM [dbo].[PR_MasterPromoExcludeTradeIn]
	ELSE
		SELECT 
			[KodePromo]
			,[NamaPromo]
		FROM [dbo].[PR_MasterPromoExcludeTradeIn]
		WHERE KodePromo=@KodePromo

END
GO

/****** Object:  StoredProcedure [dbo].[TI_PCekKuotaPromo]    Script Date: 31/03/2023 09.24.53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Create By	: Soni.Gunawan
-- Create date	: 28.3.23
-- Description	: 
-- =============================================
CREATE PROCEDURE [dbo].[TI_PCekKuotaPromo]
	@KodePromo	varchar(50),
	@KodeStore	varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF (EXISTS(SELECT * FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota WHERE KodePromo=@KodePromo AND Store=@KodeStore AND Status=1))
	BEGIN
		DECLARE @QuotaTradeIn		int,
				@TotalTrxTradeIn	int
		SELECT @QuotaTradeIn = cast(Nilai AS INT) FROM MasterParameter WHERE Nama='KuotaPromoTradeIn'
		
		IF (@QuotaTradeIn > 0)
		BEGIN
			SELECT @TotalTrxTradeIn = Count(*) FROM PR_TrxFormTradeIn WHERE KodePromo IN (SELECT KodePromo FROM [192.168.9.27].Hartono.dbo.PR_MasterPromoTradeInBerkuota WHERE Status=1) AND StatusBatal is NULL
			IF (@TotalTrxTradeIn >= @QuotaTradeIn)
				SELECT 'Kuota Promo Trade IN ini sudah habis'
		END
		ELSE SELECT ''
	END
	ELSE SELECT ''
END
GO



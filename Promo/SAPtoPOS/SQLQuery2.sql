USE [Hartono]
GO

-- =============================================
-- Created By		: Soni Gunawan
-- Create date		: 19.4.22
-- Description		: Insert Promo SAP to POS
-- =============================================

Create PROCEDURE [dbo].[sap_PAddPromoInterfaceByBonusBuyNo]
	@BonusBuyNo		varchar(50)
as
BEGIN
	-- SAP_Promo
	declare 
		@PromotionDescription		varchar(40),
		@OnSaleFrom					datetime,
		@OnSaleTo					datetime,
		@LimitNumber				int,
		@BonusBuyProfile			varchar(4),
		@BonusBuyText				varchar(60),
		@PromotionNo				varchar(10),
		@Status						varchar(1),
		@CustType					varchar(4),
		@NDNR						varchar(1),
		@MemberOnly					varchar(1),
		@LimitByCustomer			int,
		@TicketValidityFrom			varchar(15),
		@TicketValidityTo			varchar(15),
		@LongDesc1					varchar(50),
		@LongDesc2					varchar(50),
		@LongDesc3					varchar(50),
		@LongDesc4					varchar(50),
		@LongDesc5					varchar(50),
		@SOType						varchar(4),
		@HappyHourFrom				varchar(6),
		@HappyHourTo				varchar(6),
		@Monday						varchar(1),
		@Tuesday					varchar(1),
		@Wednesday					varchar(1),
		@Thursday					varchar(1),
		@Friday						varchar(1),
		@Saturday					varchar(1),
		@Sunday						varchar(1),
		@TotalDiscountType			varchar(1),
		@TotalDiscountValue			decimal(18, 2),
		@TotalDiscountJenisNilai	varchar(5),
		@MinimumValue				decimal(18, 2),
		@MinimumJenisNilai			varchar(5),
		@CreatedOn					datetime,
		@ModifiedOn					datetime

	select 
		@BonusBuyNo = BonusBuyNo, 
		@PromotionDescription = PromotionDescription, 
		@OnSaleFrom = OnSaleFrom, 
		@OnSaleTo = OnSaleTo, 
		@LimitNumber = LimitNumber, 
		@BonusBuyProfile = BonusBuyProfile, 
		@BonusBuyText = BonusBuyText, 
		@PromotionNo = PromotionNo,
		@Status = Status, 
		@CustType = CustType, 
		@NDNR = NDNR, 
		@MemberOnly = MemberOnly, 
		@LimitByCustomer = LimitByCustomer, 
		@TicketValidityFrom = TicketValidityFrom, 
		@TicketValidityTo = TicketValidityTo, 
		@LongDesc1 = LongDesc1, 
		@LongDesc2 = LongDesc2, 
		@LongDesc3 = LongDesc3, 
		@LongDesc4 = LongDesc4, 
		@LongDesc5 = LongDesc5, 
		@SOType = SOType, 
		@HappyHourFrom = HappyHourFrom, 
		@HappyHourTo = HappyHourTo, 
		@Monday = Monday, 
		@Tuesday = Tuesday, 
		@Wednesday = Wednesday, 
		@Thursday = Thursday, 
		@Friday = Friday, 
		@Saturday = Saturday, 
		@Sunday = Sunday, 
		@TotalDiscountType = TotalDiscountType, 
		@TotalDiscountValue = TotalDiscountValue, 
		@TotalDiscountJenisNilai = TotalDiscountJenisNilai, 
		@MinimumValue = MinimumValue, 
		@MinimumJenisNilai = MinimumJenisNilai
	from SAP_Promo
	where 
		CheckInput = 'False'
		AND BonusBuyNo = @BonusBuyNo

	-- PR_MasterPromo
	if (@TicketValidityFrom like 'VP%')
	begin
		-- PR_MasterPromoVHP
		if not exists(select IDPromo from PR_MasterPromoVHP where IDPromo = @BonusBuyNo)
		begin
			insert into PR_MasterPromoVHP (
				IDPromo,
				KeteranganPromo,
				TanggalAwal,
				TanggalAkhir,
				UserIDInput,
				TanggalInput
			)
			values (
				@BonusBuyNo,
				@BonusBuyText,
				@OnSaleFrom,
				@OnSaleTo,
				'',
				'99990101'
			)
		end
		else
		begin
			update
				PR_MasterPromoVHP
			set
				KeteranganPromo = @BonusBuyText,
				TanggalAwal = @OnSaleFrom,
				TanggalAkhir = @OnSaleTo
			where
				IDPromo = @BonusBuyNo
		end

		-- PR_MasterPromoVHPDetailRedeem
		declare a1 cursor fast_forward for
		select distinct 
			g.ArticleGet, 
			isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = g.ArticleGet and a.Discntin_idc = 'False'), 
			(isnull((select top 1 a.mc from sap_configmerchandisecategory a where a.mc = g.ArticleGet), ''))) as Old_Mat_No 
		from SAP_PromoListGet g
		where g.BonusBuyNo = @BonusBuyNo and g.PromotionNo = @PromotionNo

		declare	
			@Article		varchar(50),
			@KodeBarang		varchar(50),
			@StatusBerhenti	bit
		if (@Status = '') set @StatusBerhenti = 'False'
		else set @StatusBerhenti = 'True'

		open a1
		fetch next from a1 into @Article, @KodeBarang
		while (@@fetch_status = 0)
		begin
			if (@KodeBarang <> '')
			begin
				if not exists(select KodeBarang from PR_MasterPromoVHPDetailRedeem where KodeBarang = @KodeBarang and IDPromo = @BonusBuyNo)
				begin
					insert into PR_MasterPromoVHPDetailRedeem (
						IDPromo,
						KodeBarang,
						TanggalInput,
						UserIDInput,
						StatusBerhenti,
						UserIDStatus,
						TanggalStatus
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						'99990101',
						'',
						@StatusBerhenti,
						'',
						'99990101'
					)
				end
				else
				begin
					update
						PR_MasterPromoVHPDetailRedeem
					set
						StatusBerhenti = @StatusBerhenti
					where
						IDPromo = @BonusBuyNo
						and KodeBarang = @KodeBarang
				end
			end
			update 
				SAP_PromoListGet 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo
				and ArticleGet = @Article
		fetch next from a1 into @Article, @KodeBarang
		end
		close a1
		deallocate a1
		
		-- PR_MasterPromoVHPDetailStore
		declare a2 cursor fast_forward for
		select s.KodeStore, p.Site
		from SAP_PromoListSite p, MasterStore s
		where p.Site = s.SALES_OFF and p.BonusBuyNo = @BonusBuyNo and p.PromotionNo = @PromotionNo and s.KodeStore <> '00'

		declare	
			@KodeStore	varchar(50),
			@SALES_OFF	varchar(10)

		open a2
		fetch next from a2 into @KodeStore, @SALES_OFF
		while (@@fetch_status = 0)
		begin
			if not exists(select KodeStore from PR_MasterPromoVHPDetailStore where IDPromo = @BonusBuyNo and KodeStore = @KodeStore)
			begin
				insert into PR_MasterPromoVHPDetailStore (
					IDPromo,
					KodeStore
				) VALUES (
					@BonusBuyNo,
					@KodeStore
				)
			end
			update 
				SAP_PromoListSite 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo
				and Site = @SALES_OFF
		fetch next from a2 into @KodeStore, @SALES_OFF
		end
		close a2
		deallocate a2

		-- PR_MasterPromoVHPDetailVoucher
		DECLARE 
			@intFlag int,
			@endFlag int
		SET @intFlag = (select cast(substring(@TicketValidityFrom, 3, len(@TicketValidityFrom)-2) as int))
		set @endFlag = (select cast(substring(@TicketValidityTo, 3, len(@TicketValidityTo)-2) as int))
		WHILE (@intFlag <= @endFlag)
		BEGIN
			if not exists(select NoVoucher from PR_MasterPromoVHPDetailVoucher where IDPromo = @BonusBuyNo and NoVoucher = 'VP' + right(replicate('0', 6) + cast(@intFlag as varchar(6)), 6))
			begin
				insert into PR_MasterPromoVHPDetailVoucher (
					IDPromo,
					NoVoucher,
					TanggalInput,
					UserIDInput
				)
				values (
					@BonusBuyNo,
					'VP' + right(replicate('0', 6) + cast(@intFlag as varchar(6)), 6),
					'99990101',
					''
				)
			end
			SET @intFlag = @intFlag + 1
			CONTINUE;
		END
	end
	
	else
	begin
		if not exists(select KodePromo from PR_MasterPromo where KodePromo = @BonusBuyNo and PromotionNo = @PromotionNo)
		begin
			declare @GabungCicilan	bit
			set @GabungCicilan = 'True'
			if (@Thursday = 'X') set @GabungCicilan = 'False'
			
			insert into PR_MasterPromo (
				KodePromo,
				NamaPromo,
				TanggalAwal,
				TanggalAkhir,
				JumlahPromo,
				JumlahPromoTerpakai,
				JenisPromo,
				KeteranganSO,
				UserID,
				KodeStore,
				StatusGabungCicilan,
				StatusGabungDVC,
				StatusGabungCB,
				PromotionNo,
				PromotionDescription,
				Status,
				CustType,
				NDNR,
				MemberOnly,
				LimitByCustomer,
				TicketValidityFrom,
				TicketValidityTo,
				LongDesc1,
				LongDesc2,
				LongDesc3,
				LongDesc4,
				LongDesc5,
				SOType,
				HappyHourFrom,
				HappyHourTo,
				Monday,
				Tuesday,
				Wednesday,
				Thursday,
				Friday,
				Saturday,
				Sunday,
				TotalDiscountType,
				TotalDiscountValue,
				TotalDiscountJenisNilai,
				MinimumValue,
				MinimumJenisNilai,
				CreatedOn,
				ModifiedOn
			) VALUES (
				@BonusBuyNo,
				@BonusBuyText,
				@OnSaleFrom,
				@OnSaleTo,
				@LimitNumber,
				0,
				@BonusBuyProfile,
				@LongDesc1 + ' ' + @LongDesc2 + ' ' + @LongDesc3 + ' ' + @LongDesc4 + ' ' + @LongDesc5,
				'',
				'',
				@GabungCicilan,
				'False',
				'False',
				@PromotionNo,
				@PromotionDescription,
				@Status,
				@CustType,
				@NDNR,
				@MemberOnly,
				@LimitByCustomer,
				replace(@TicketValidityFrom, '.', ''),
				replace(@TicketValidityTo, '.', ''),
				@LongDesc1,
				@LongDesc2,
				@LongDesc3,
				@LongDesc4,
				@LongDesc5,
				@SOType,
				@HappyHourFrom,
				@HappyHourTo,
				@Monday,
				@Tuesday,
				@Wednesday,
				@Thursday,
				@Friday,
				@Saturday,
				@Sunday,
				@TotalDiscountType,
				@TotalDiscountValue,
				@TotalDiscountJenisNilai,
				@MinimumValue,
				@MinimumJenisNilai,
				@CreatedOn,
				@ModifiedOn
			)
		end
		else
		begin
			update 
				PR_MasterPromo 
			set 
				TanggalAwal = @OnSaleFrom,
				TanggalAkhir = @OnSaleTo,
				JumlahPromo = @LimitNumber,
				KeteranganSO = @LongDesc1 + ' ' + @LongDesc2 + ' ' + @LongDesc3 + ' ' + @LongDesc4 + ' ' + @LongDesc5,
				PromotionDescription = @PromotionDescription,
				Status = @Status,
				LongDesc1 = @LongDesc1,
				LongDesc2 = @LongDesc2,
				LongDesc3 = @LongDesc3,
				LongDesc4 = @LongDesc4,
				LongDesc5 = @LongDesc5,
				HappyHourFrom = @HappyHourFrom,
				HappyHourTo = @HappyHourTo,
				Monday	= @Monday,
				Tuesday = @Tuesday,
				Wednesday = @Wednesday,
				Thursday = @Thursday,
				Friday = @Friday,
				Saturday = @Saturday,
				Sunday = @Sunday,
				ModifiedOn = @ModifiedOn
			where
				KodePromo = @BonusBuyNo
				and PromotionNo = @PromotionNo
		end

		-- add cicilan total detail barang
		if (@CustType = '0001')
		begin
			-- PR_MasterCicilanTotalDetailBarang
			declare a3 cursor fast_forward for
			select distinct b.ArticleBuy, a.Old_Mat_No
			from SAP_PromoListBuy b, SAP_Article a
			where b.BonusBuyNo = @BonusBuyNo and b.PromotionNo = @PromotionNo and b.ArticleBuy = a.material and a.Discntin_idc = 'False'

			open a3
			fetch next from a3 into @Article, @KodeBarang
			while (@@fetch_status = 0)
			begin
				if not exists(select KodeBarang from PR_MasterCicilanTotalDetailBarang where KodePromo = @BonusBuyNo and KodeBarang = @KodeBarang)
				begin
					insert into PR_MasterCicilanTotalDetailBarang (
						KodePromo,
						KodeBarang,
						TanggalAwal,
						TanggalAkhir,
						StatusPromo
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						@OnSaleFrom,
						@OnSaleTo,
						@Status
					)
				end
				else
				begin
					update
						PR_MasterCicilanTotalDetailBarang
					set
						TanggalAkhir = @OnSaleTo,
						StatusPromo = @Status
					where
						KodePromo = @BonusBuyNo
						and KodeBarang = @KodeBarang
				end
				update 
					SAP_PromoListBuy 
				set 
					CheckInput = 'True'
				where
					BonusBuyNo = @BonusBuyNo
					and PromotionNo = @PromotionNo
					and ArticleBuy = @Article

			fetch next from a3 into @Article, @KodeBarang
			end
			close a3
			deallocate a3

			update 
				SAP_PromoListGet 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo

			update 
				SAP_PromoListSite 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo
		end

		-- promo link tipe bayar
		if (@CustType = '0002')
		begin
			DECLARE 
				@intBBFlag bigint,
				@endBBFlag bigint
			SET @intBBFlag = (select cast(replace(@TicketValidityFrom, '-', '') as bigint))
			if (@TicketValidityTo = '')
				set @endBBFlag = @intBBFlag
			else
				set @endBBFlag = (select cast(replace(@TicketValidityTo, '-', '') as bigint))
			WHILE (@intBBFlag <= @endBBFlag)
			BEGIN
				-- PR_MasterPromoDetailJenisPembayaran
				declare a5 cursor fast_forward for
				select distinct ArticleGet
				from SAP_PromoListGet
				where BonusBuyNo = @BonusBuyNo and PromotionNo = @PromotionNo

				open a5
				fetch next from a5 into @Article
				while (@@fetch_status = 0)
				begin
					if (substring(@Article, 1, 3) = 'TT_')
					begin
						declare 
							@kodejenispembayaranbb	varchar(50)

						set @kodejenispembayaranbb = (select isnull((select KodeJenisPembayaran from CH_MasterJenisPembayaran where KodeJenisSAP = substring(@Article, 4, len(@Article))), '')) 
						if (@kodejenispembayaranbb <> '')
						begin
							if not exists(select KodeJenisPembayaran from PR_MasterPromoDetailJenisPembayaran where KodePromo1 = @BonusBuyNo and KodePromo2 = substring(cast(@intBBFlag as varchar(11)), 1, 9) + '-' + substring(cast(@intBBFlag as varchar(11)), 10, 2) and KodeJenisPembayaran = @kodejenispembayaranbb)
							begin
								insert into PR_MasterPromoDetailJenisPembayaran (
									KodePromo1,
									KodePromo2,
									KodeJenisPembayaran,
									TanggalAwal,
									TanggalAkhir
								)
								VALUES (
									@BonusBuyNo,
									substring(cast(@intBBFlag as varchar(11)), 1, 9) + '-' + substring(cast(@intBBFlag as varchar(11)), 10, 2),
									@kodejenispembayaranbb,
									@OnSaleFrom,
									@OnSaleTo
								)
							end
							else
							begin
								update
									PR_MasterPromoDetailJenisPembayaran
								set
									TanggalAkhir = @OnSaleTo
								where
									KodePromo1 = @BonusBuyNo 
									and KodePromo2 = substring(cast(@intBBFlag as varchar(11)), 1, 9) + '-' + substring(cast(@intBBFlag as varchar(11)), 10, 2) 
									and KodeJenisPembayaran = @kodejenispembayaranbb
							end
						end
					end

					update 
						SAP_PromoListGet 
					set 
						CheckInput = 'True'
					where
						BonusBuyNo = @BonusBuyNo
						and PromotionNo = @PromotionNo
						and ArticleGet = @Article

				fetch next from a5 into @Article
				end
				close a5
				deallocate a5

				SET @intBBFlag = @intBBFlag + 1
				CONTINUE;
			END

			update 
				SAP_PromoListBuy 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo

			update 
				SAP_PromoListSite 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo
		end

		-- add discount total value
		if (@BonusBuyProfile = 'Z012')
		begin
			-- PR_MasterPromoDetailBarangUtama 
			declare a4 cursor fast_forward for
			select g.ArticleGet, 
			isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = g.ArticleGet and a.Discntin_idc = 'False'), 
			(isnull((select top 1 a.mc from sap_configmerchandisecategory a where a.mc = g.ArticleGet), ''))) as Old_Mat_No, 
			g.QuantityGet, 
			g.SeveralArticle
			from SAP_PromoListGet g
			where g.CheckInput = 'False' and g.BonusBuyNo = @BonusBuyNo and g.PromotionNo = @PromotionNo

			declare
				@Qty			int,
				@Several		varchar(1)

			open a4
			fetch next from a4 into @Article, @KodeBarang, @Qty, @Several
			while (@@fetch_status = 0)
			begin
				if not exists(select KodePromo from PR_MasterPromoDetailBarangUtama where KodePromo = @BonusBuyNo and KodeBarang = @KodeBarang and PromotionNo = @PromotionNo)
				begin
					insert into PR_MasterPromoDetailBarangUtama (
						KodePromo,
						KodeBarang,
						Jumlah,
						StatusCheck,
						TanggalCheck,
						KeteranganCheck,
						StatusBerhenti,
						TanggalBerhenti,
						UserID,
						PromotionNo,
						SeveralArticle
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						@Qty,
						'True',
						'99990101',
						'CIP',
						'False',
						'99990101',
						'',
						@PromotionNo,
						@Several
					)
				end

				update 
					SAP_PromoListGet 
				set 
					CheckInput = 'True'
				where
					BonusBuyNo = @BonusBuyNo
					and PromotionNo = @PromotionNo
					and ArticleGet = @Article
			fetch next from a4 into @Article, @KodeBarang, @Qty, @Several
			end
			close a4
			deallocate a4
		end

		-- add so trade in
		if (@BonusBuyProfile = 'Z015')
		begin
			-- PR_MasterPromoDetailTradeIn
			declare a5 cursor fast_forward for
			select g.ArticleGet, isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = g.ArticleGet and a.Discntin_idc = 'False'), '') as Old_Mat_No, g.QuantityGet, g.DiscountValue
			from SAP_PromoListGet g
			where g.CheckInput = 'False' and g.BonusBuyNo = @BonusBuyNo and g.PromotionNo = @PromotionNo

			declare
				@Qty2			int,
				@Disc2			decimal(18, 2)

			open a5
			fetch next from a5 into @Article, @KodeBarang, @Qty2, @Disc2
			while (@@fetch_status = 0)
			begin
				if not exists(select KodePromo from PR_MasterPromoDetailTradeIn where KodePromo = @BonusBuyNo and KodeBarang = @KodeBarang and PromotionNo = @PromotionNo)
				begin
					insert into PR_MasterPromoDetailTradeIn (
						KodePromo,
						KodeBarang,
						Jumlah,
						NilaiTradeIn,
						PromotionNo
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						@Qty2,
						@Disc2,
						@PromotionNo
					)
				end

				update 
					SAP_PromoListGet 
				set 
					CheckInput = 'True'
				where
					BonusBuyNo = @BonusBuyNo
					and PromotionNo = @PromotionNo
					and ArticleGet = @Article
			fetch next from a5 into @Article, @KodeBarang, @Qty2, @Disc2
			end
			close a5
			deallocate a5
		end

		-- add promo trade in
		if (@BonusBuyProfile = 'Z016')
		begin
			-- PR_MasterPromoTradeInUtama
			declare a6 cursor fast_forward for
			select b.ArticleBuy, isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = b.ArticleBuy and a.Discntin_idc = 'False'), '') as Old_Mat_No, b.QuantityBuy
			from SAP_PromoListBuy b
			where b.CheckInput = 'False' and b.BonusBuyNo = @BonusBuyNo and b.PromotionNo = @PromotionNo

			declare
				@IsMC			bit

			open a6
			fetch next from a6 into @Article, @KodeBarang, @Qty2
			while (@@fetch_status = 0)
			begin
				set @IsMC = 'False'
				if exists(select MC from SAP_ConfigMerchandiseCategory where MC = @Article)
					set @IsMC = 'True'
				
				if (@KodeBarang = '')
					set @KodeBarang = @Article
					
				if not exists(select KodePromo from PR_MasterPromoTradeInUtama where KodePromo = @BonusBuyNo and KodeBarang = @KodeBarang)
				begin
					insert into PR_MasterPromoTradeInUtama (
						KodePromo,
						KodeBarang,
						IsMC,
						Jumlah
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						@IsMC,
						@Qty2
					)
				end

				update 
					SAP_PromoListBuy
				set 
					CheckInput = 'True'
				where
					BonusBuyNo = @BonusBuyNo
					and PromotionNo = @PromotionNo
					and ArticleBuy = @Article
			fetch next from a6 into @Article, @KodeBarang, @Qty2
			end
			close a6
			deallocate a6

			-- PR_MasterPromoTradeInBekas
			declare a7 cursor fast_forward for
			select g.ArticleGet, isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = g.ArticleGet and a.Discntin_idc = 'False'), '') as Old_Mat_No, g.QuantityGet, g.DiscountValue
			from SAP_PromoListGet g
			where g.CheckInput = 'False' and g.BonusBuyNo = @BonusBuyNo and g.PromotionNo = @PromotionNo

			open a7
			fetch next from a7 into @Article, @KodeBarang, @Qty2, @Disc2
			while (@@fetch_status = 0)
			begin
				if (@KodeBarang = '')
					set @KodeBarang = @Article

				if not exists(select KodePromo from PR_MasterPromoTradeInBekas where KodePromo = @BonusBuyNo and KodeBarang = @KodeBarang)
				begin
					insert into PR_MasterPromoTradeInBekas (
						KodePromo,
						KodeBarang,
						Jumlah,
						NilaiBarangBekas
					)
					VALUES (
						@BonusBuyNo,
						@KodeBarang,
						@Qty2,
						@Disc2
					)
				end

				update 
					SAP_PromoListGet 
				set 
					CheckInput = 'True'
				where
					BonusBuyNo = @BonusBuyNo
					and PromotionNo = @PromotionNo
					and ArticleGet = @Article
			fetch next from a7 into @Article, @KodeBarang, @Qty2, @Disc2
			end
			close a7
			deallocate a7
		end

		-- add promo leasing	
		if (@BonusBuyProfile = 'Z017')
		begin
			DECLARE 
				@KodePromoInduk	varchar(10),
				@intFlagPromo	int,
				@endFlagPromo	int,
				@NoMember		varchar(50)
			SET @KodePromoInduk = (select substring(@TicketValidityFrom, 1, 9))
			SET @intFlagPromo = (select cast(substring(@TicketValidityFrom, 11, len(@TicketValidityFrom)-10) as int))
			set @endFlagPromo = (select cast(substring(@TicketValidityTo, 11, len(@TicketValidityTo)-10) as int))

			WHILE (@intFlagPromo <= @endFlagPromo)
			BEGIN
				declare a8 cursor fast_forward for
				select distinct g.ArticleGet
				from SAP_PromoListGet g
				where g.BonusBuyNo = @BonusBuyNo and g.PromotionNo = @PromotionNo

				open a8
				fetch next from a8 into @NoMember
				while (@@fetch_status = 0)
				begin
					if not exists(select KodePromo from PR_MasterPromoDetailMember where KodePromo = @KodePromoInduk + '-' + right(replicate('0', 2) + cast(@intFlagPromo as varchar(2)), 2) and NoMember = @NoMember)
					begin
						insert into PR_MasterPromoDetailMember (
							KodePromo,
							NoMember
						)
						VALUES (
							@KodePromoInduk + '-' + right(replicate('0', 2) + cast(@intFlagPromo as varchar(2)), 2),
							@NoMember
						)
					end

				fetch next from a8 into @NoMember
				end
				close a8
				deallocate a8
				
				SET @intFlagPromo = @intFlagPromo + 1
				CONTINUE;
			END
			
			update 
				SAP_PromoListGet 
			set 
				CheckInput = 'True'
			where
				BonusBuyNo = @BonusBuyNo
				and PromotionNo = @PromotionNo
		end
	end
	update 
		SAP_Promo 
	set 
		CheckInput = 'True'
	where
		BonusBuyNo = @BonusBuyNo
		and PromotionNo = @PromotionNo


	-- SAP_PromoListGet 
	declare c cursor fast_forward for
	select 
		g.BonusBuyNo, 
		g.PromotionNo, 
		g.ArticleGet, 
		isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = g.ArticleGet and a.Discntin_idc = 'False'), 
		(isnull((select top 1 a.mc from sap_configmerchandisecategory a where a.mc = g.ArticleGet), ''))
		) as Old_Mat_No, 
		g.QuantityGet, 
		g.DiscountType, 
		g.CurrPerc, 
		g.DiscountValue, 
		g.SeveralArticle
	from SAP_PromoListGet g
	where g.CheckInput = 'False'

	declare 
		@ArticleBuy		varchar(18),
		@QuantityBuy	int,
		@SeveralArticle	varchar(1),
		@Old_Mat_No		varchar(50),
		@jenispot		varchar(50)

	declare 
		@ArticleGet		varchar(18),
		@QuantityGet	int,
		@DiscountType	varchar(1),
		@CurrPerc		varchar(5),
		@DiscountValue	decimal(18, 2)
	open c
	fetch next from c into @BonusBuyNo, @PromotionNo, @ArticleGet, @Old_Mat_No, @QuantityGet, @DiscountType, @CurrPerc, @DiscountValue, @SeveralArticle
	while (@@fetch_status = 0)
	begin		
		if (substring(@ArticleGet, 1, 3) = 'TT_')
		begin
			declare 
				@kodejenispembayaran	varchar(50),
				@Old_Mat_No_Buy			varchar(50)	

			set @kodejenispembayaran = (select isnull((select KodeJenisPembayaran from CH_MasterJenisPembayaran where KodeJenisSAP = substring(@ArticleGet, 4, len(@ArticleGet))), '')) 
			if exists(select KodeJenisPembayaranPromo from MKT_MasterJenisPembayaranPromo where KodeJenisPembayaranPromo = @kodejenispembayaran)
			begin
				declare x cursor fast_forward for
				select distinct b.ArticleBuy, a.Old_Mat_No, p.OnSaleFrom, p.OnSaleTo, p.Status
				from SAP_PromoListBuy b, SAP_Promo p, SAP_Article a
				where b.BonusBuyNo = p.BonusBuyNo and b.PromotionNo = p.PromotionNo and b.ArticleBuy = a.Material and b.BonusBuyNo = @BonusBuyNo and b.PromotionNo = @PromotionNo and a.Discntin_idc = 'False'

				open x
				fetch next from x into @ArticleBuy, @Old_Mat_No_Buy, @OnSaleFrom, @OnSaleTo, @Status
				while (@@fetch_status = 0)
				begin
					if (@Status = '')
					begin
						if not exists(select KodeBarang from MKT_MasterBarangCicilanReguler where KodeBarang = @Old_Mat_No_Buy and TanggalAwal = @OnSaleFrom and KodeJenisPembayaranPromo = @kodejenispembayaran) -- 30.04.20201
						begin
							insert into MKT_MasterBarangCicilanReguler (
								KodeBarang,
								TanggalAwal,
								TanggalAkhir,
								KodeJenisPembayaranPromo,
								UserIDInputted,
								DateInputted,
								UserIDModified,
								DateModified
							)
							VALUES (
								@Old_Mat_No_Buy,
								@OnSaleFrom,
								@OnSaleTo,
								@kodejenispembayaran,
								'',
								'99990101',
								'',
								'99990101'
							)
						end
						else
						begin
							update 
								MKT_MasterBarangCicilanReguler
							set
								TanggalAkhir = @OnSaleTo,
								DateModified = getdate()
							where
								KodeBarang = @Old_Mat_No_Buy 
								and TanggalAwal = @OnSaleFrom 
								and KodeJenisPembayaranPromo = @kodejenispembayaran
						end
					end
					else if (@Status = '2')
					begin
						if exists(select KodeBarang from MKT_MasterBarangCicilanReguler where KodeBarang = @Old_Mat_No_Buy and TanggalAwal = @OnSaleFrom and KodeJenisPembayaranPromo = @kodejenispembayaran) -- open tanggal awal 30.04.2021 discuss with Kristo
						begin
							update 
								MKT_MasterBarangCicilanReguler
							set
								TanggalAkhir = cast(convert(varchar, getdate(), 111) as datetime),
								DateModified = getdate()
							where
								KodeBarang = @Old_Mat_No_Buy 
								and TanggalAwal = @OnSaleFrom
								and KodeJenisPembayaranPromo = @kodejenispembayaran
						end
					end
					update 
						SAP_PromoListBuy 
					set 
						CheckInput = 'True'
					where
						BonusBuyNo = @BonusBuyNo
						and PromotionNo = @PromotionNo
						and ArticleBuy = @ArticleBuy
				fetch next from x into @ArticleBuy, @Old_Mat_No_Buy, @OnSaleFrom, @OnSaleTo, @Status
				end
				close x
				deallocate x
			end
			else if exists(select KodeJenisPembayaran from MB_MasterJenisPembayaranMember where KodeJenisPembayaran = @kodejenispembayaran)
			begin
				declare y cursor fast_forward for
				select distinct b.ArticleBuy, a.Old_Mat_No, p.OnSaleFrom, p.OnSaleTo, p.Status
				from SAP_PromoListBuy b, SAP_Promo p, SAP_Article a
				where b.BonusBuyNo = p.BonusBuyNo and b.PromotionNo = p.PromotionNo and b.ArticleBuy = a.Material and b.BonusBuyNo = @BonusBuyNo and b.PromotionNo = @PromotionNo and a.Discntin_idc = 'False'

				open y
				fetch next from y into @ArticleBuy, @Old_Mat_No_Buy, @OnSaleFrom, @OnSaleTo, @Status
				while (@@fetch_status = 0)
				begin
					if (@Status = '')
					begin
						if not exists(select KodeBarang from MB_MasterBarangCicilanMember where KodeBarang = @Old_Mat_No_Buy and KodeJenisPembayaran = @kodejenispembayaran and TanggalAwal = @OnSaleFrom) -- 30.04.2021
						begin
							insert into MB_MasterBarangCicilanMember (
								KodeBarang,
								TanggalAwal,
								TanggalAkhir,
								KodeJenisPembayaran
							)
							VALUES (
								@Old_Mat_No_Buy,
								@OnSaleFrom,
								@OnSaleTo,
								@kodejenispembayaran
							)
						end
						else
						begin
							update
								MB_MasterBarangCicilanMember
							set
								TanggalAkhir = @OnSaleTo
							where 
								KodeBarang = @Old_Mat_No_Buy
								and KodeJenisPembayaran = @kodejenispembayaran
								and TanggalAwal = @OnSaleFrom
						end
					end
					else if (@Status = '2')
					begin
						if exists(select KodeBarang from MB_MasterBarangCicilanMember where KodeBarang = @Old_Mat_No_Buy and TanggalAwal = @OnSaleFrom and KodeJenisPembayaran = @kodejenispembayaran)
						begin
							update 
								MB_MasterBarangCicilanMember
							set
								TanggalAkhir = cast(convert(varchar, getdate(), 111) as datetime)
							where
								KodeBarang = @Old_Mat_No_Buy 
								and TanggalAwal = @OnSaleFrom 
								and KodeJenisPembayaran = @kodejenispembayaran
						end
					end
					update 
						SAP_PromoListBuy 
					set 
						CheckInput = 'True'
					where
						BonusBuyNo = @BonusBuyNo
						and PromotionNo = @PromotionNo
						and ArticleBuy = @ArticleBuy
				fetch next from y into @ArticleBuy, @Old_Mat_No_Buy, @OnSaleFrom, @OnSaleTo, @Status
				end
				close y
				deallocate y
			end
		end
		else
		begin
			declare @countbuy int
			set @countbuy = (select count(*) from SAP_PromoListBuy where BonusBuyNo = @BonusBuyNo and PromotionNo = @PromotionNo)
			if (@countbuy = 0)
			begin
				-- PR_MasterPromoDetailBarangUtama
				if not exists(select KodePromo from PR_MasterPromoDetailBarangUtama where KodePromo = @BonusBuyNo and KodeBarang = @Old_Mat_No and PromotionNo = @PromotionNo)
				begin
					insert into PR_MasterPromoDetailBarangUtama (
						KodePromo,
						KodeBarang,
						Jumlah,
						StatusCheck,
						TanggalCheck,
						KeteranganCheck,
						StatusBerhenti,
						TanggalBerhenti,
						UserID,
						PromotionNo,
						SeveralArticle
					)
					VALUES (
						@BonusBuyNo,
						@Old_Mat_No,
						@QuantityGet,
						'True',
						'99990101',
						'CIP',
						'False',
						'99990101',
						'',
						@PromotionNo,
						@SeveralArticle
					)
				end

				-- PR_MasterPromoDetailPotonganHarga
				set @jenispot = (select isnull(SOType, '') from SAP_Promo where BonusBuyNo = @BonusBuyNo and PromotionNo = @PromotionNo)
				if (@jenispot in ('ZC04', 'ZC05')) set @jenispot = 'TDCT'
				else 
				begin
					declare 
						@Ticket	varchar(50),
						@SO		varchar(50)
					set @Ticket = (select TicketValidityFrom from SAP_Promo where BonusBuyNo = @BonusBuyNo and PromotionNo = @PromotionNo)
					if (len(@Ticket) >= 12 and @Ticket not like 'VP%') set @Ticket = (select substring(@Ticket, 1, 12))
					set @SO = (select isnull((select top 1 SOType from SAP_Promo where BonusBuyNo = @Ticket), ''))
					if (@SO in ('ZC04', 'ZC05')) set @jenispot = 'TDCT'
					else set @jenispot = 'TDC'
				end
				if not exists(select KodePromo from PR_MasterPromoDetailPotonganHarga where KodePromo = @BonusBuyNo and JenisPotonganHarga = @jenispot and PromotionNo = @PromotionNo)
				begin
					insert into PR_MasterPromoDetailPotonganHarga (
						KodePromo,
						JenisPotonganHarga,
						Jumlah,
						KodeBarangTradeIn,
						KodeSupplierTradeIn,
						JenisNilai,
						PromotionNo
					)
					VALUES (
						@BonusBuyNo,
						@jenispot,
						@DiscountValue,
						'',
						'',
						@CurrPerc,
						@PromotionNo
					)
				end
			end
			else
			begin
				if (@DiscountType = '%' or @DiscountType = 'R')
				begin
					if not exists(select KodePromo from PR_MasterPromoDetailBarangFree where KodePromo = @BonusBuyNo and KodeBarangFree = @Old_Mat_No and PromotionNo = @PromotionNo)
					begin
						insert into PR_MasterPromoDetailBarangFree (
							KodePromo,
							KodeBarangFree,
							JumlahBarangFree,
							PotonganVPR,
							PotonganVPRB,
							JenisNilai,
							PromotionNo,
							SeveralArticle
						)
						VALUES (
							@BonusBuyNo,
							@Old_Mat_No,
							@QuantityGet,
							@DiscountValue,
							0,
							@CurrPerc,
							@PromotionNo,
							@SeveralArticle
						)
					end
				end
			end
		end
		update 
			SAP_PromoListGet 
		set 
			CheckInput = 'True'
		where
			BonusBuyNo = @BonusBuyNo
			and PromotionNo = @PromotionNo
			and ArticleGet = @ArticleGet
	fetch next from c into @BonusBuyNo, @PromotionNo, @ArticleGet, @Old_Mat_No, @QuantityGet, @DiscountType, @CurrPerc, @DiscountValue, @SeveralArticle
	end
	close c
	deallocate c


	-- SAP_PromoListBuy -- add MC 26/12/2018
	declare b cursor fast_forward for
	select distinct 
		b.BonusBuyNo, 
		b.PromotionNo, 
		b.ArticleBuy, 
		isnull((select top 1 a.Old_Mat_No from SAP_Article a where a.Material = b.ArticleBuy and a.Discntin_idc = 'False'), 
		(isnull((select top 1 a.mc from sap_configmerchandisecategory a where a.mc = b.ArticleBuy), ''))
		) as Old_Mat_No,
		b.QuantityBuy, 
		b.DiscountType, 
		b.CurrPerc, 
		b.DiscountValue, 
		b.SeveralArticle
	from SAP_PromoListBuy b
	where b.CheckInput = 'False'

	open b
	fetch next from b into @BonusBuyNo, @PromotionNo, @ArticleBuy, @Old_Mat_No, @QuantityBuy, @DiscountType, @CurrPerc, @DiscountValue, @SeveralArticle
	while (@@fetch_status = 0)
	begin
	-- PR_MasterPromoDetailBarangUtama
		if (@Old_Mat_No <> '')
		begin
			if not exists(select KodePromo from PR_MasterPromoDetailBarangUtama where KodePromo = @BonusBuyNo and KodeBarang = @Old_Mat_No and PromotionNo = @PromotionNo)
			begin
				insert into PR_MasterPromoDetailBarangUtama (
					KodePromo,
					KodeBarang,
					Jumlah,
					StatusCheck,
					TanggalCheck,
					KeteranganCheck,
					StatusBerhenti,
					TanggalBerhenti,
					UserID,
					PromotionNo,
					SeveralArticle
				)
				VALUES (
					@BonusBuyNo,
					@Old_Mat_No,
					@QuantityBuy,
					'True',
					'99990101',
					'CIP',
					'False',
					'99990101',
					'',
					@PromotionNo,
					@SeveralArticle
				)
			end
		end
	
		if (@DiscountType = '%' or @DiscountType = 'R')
		begin
			-- PR_MasterPromoDetailPotonganHarga
			set @jenispot = (select isnull(SOType, '') from SAP_Promo where BonusBuyNo = @BonusBuyNo and PromotionNo = @PromotionNo)
			if (@jenispot in ('Z014', 'Z015')) set @jenispot = 'TDCT'
			else set @jenispot = 'TDC'
			if not exists(select KodePromo from PR_MasterPromoDetailPotonganHarga where KodePromo = @BonusBuyNo and JenisPotonganHarga = @jenispot and PromotionNo = @PromotionNo)
			begin
				insert into PR_MasterPromoDetailPotonganHarga (
					KodePromo,
					JenisPotonganHarga,
					Jumlah,
					KodeBarangTradeIn,
					KodeSupplierTradeIn,
					JenisNilai,
					PromotionNo
				)
				VALUES (
					@BonusBuyNo,
					@jenispot,
					@DiscountValue,
					'',
					'',
					@CurrPerc,
					@PromotionNo
				)
			end
		end
	
		update 
			SAP_PromoListBuy 
		set 
			CheckInput = 'True'
		where
			BonusBuyNo = @BonusBuyNo
			and PromotionNo = @PromotionNo
			and ArticleBuy = @ArticleBuy
	fetch next from b into @BonusBuyNo, @PromotionNo, @ArticleBuy, @Old_Mat_No, @QuantityBuy, @DiscountType, @CurrPerc, @DiscountValue, @SeveralArticle
	end
	close b
	deallocate b


	-- SAP_PromoListSite
	declare d cursor fast_forward for
	select p.BonusBuyNo, p.PromotionNo, p.Site, s.KodeStore
	from SAP_PromoListSite p, MasterStore s
	where p.Site = s.SALES_OFF and p.CheckInput = 'False' and s.KodeStore <> '00'

	declare
		@Store	varchar(50), 
		@Site	varchar(10)
	open d
	fetch next from d into @BonusBuyNo, @PromotionNo, @Site, @Store
	while (@@fetch_status = 0)
	begin
	-- PH_MasterPromoDetailStore
		if not exists(select KodePromo from PH_MasterPromoDetailStore where KodePromo = @BonusBuyNo and KodeStore = @Store and PromotionNo = @PromotionNo)
		begin
			insert into PH_MasterPromoDetailStore (
				KodePromo,
				KodeStore,
				PromotionNo
			)
			VALUES (
				@BonusBuyNo,
				@Store,
				@PromotionNo
			)
		end
		update 
			SAP_PromoListSite 
		set 
			CheckInput = 'True'
		where
			BonusBuyNo = @BonusBuyNo
			and PromotionNo = @PromotionNo
			and Site = @Site
	fetch next from d into @BonusBuyNo, @PromotionNo, @Site, @Store
	end
	close d
	deallocate d


	select distinct bonusbuyno 
	into #bbtt
	from sap_promolistget 
	where articleget like 'TT_%' and len(articleget) = 7 and CHARINDEX('TT_',articleget) > 0

	insert into pr_masterpromodetailbarangutama_temp
	select p.*, getdate() from pr_masterpromodetailbarangutama p, #bbtt t
	where p.kodepromo = t.kodepromo

	delete p
	from pr_masterpromodetailbarangutama p, #bbtt t
	where p.kodepromo = t.kodepromo

	select 
END
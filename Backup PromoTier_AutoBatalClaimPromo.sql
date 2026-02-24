USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[PromoTier_AutoBatalClaimPromo]    Script Date: 16/01/2023 10.50.46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 10/09/2021
-- Description:	AutoBatalClaimPromo
-- =============================================

ALTER PROCEDURE [dbo].[PromoTier_AutoBatalClaimPromo]
AS
BEGIN

SELECT  A.NoVoucher, NoFaktur, NoMember, A.Tier
INTO #tempVoucher
from s_PromoTierDetailVoucher A join t_PromoTierVoucherHistory B on A.NoVoucher=B.NoVoucher 
where StatusTerpakai='0' and StatusKlaim='1' and Status='0'
--and (DATEDIFF(second, TanggalKlaim, getdate()) / 3600.0) >= 2
and (DATEDIFF(second, TanggalKlaim, getdate()) / 3600.0) >= 9999 -- sementara dimatikan karena MyH error

Update s_PromoTierDetailVoucher set StatusKlaim='0' where NoVoucher in (SELECT NoVoucher FROM #tempVoucher)
Update t_PromoTierVoucherHistory set Status='2' where NoVoucher in (SELECT NoVoucher FROM #tempVoucher) and Status=0

-- Reset Tier Promo Merdeka
Update s_PromoTierDetailVoucher set Tier='Tier', Nominal = '0' where PromoID='PR7' AND StatusKlaim='0' AND StatusTerpakai='0' AND NoVoucher in (SELECT NoVoucher FROM #tempVoucher)

SELECT NoVoucher,NoFaktur,NoMember,Tier from #tempVoucher
drop table #tempVoucher

END
GO


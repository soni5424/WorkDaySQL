USE [Hartono]
GO
/****** Object:  StoredProcedure [dbo].[PromoVDCVDB_AutoBatalClaimPromo]    Script Date: 14/10/2022 06:34:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		David C.H
-- Create date: 24/02/2021
-- Description:	AutoBatalClaimPromo
-- =============================================

ALTER PROCEDURE [dbo].[PromoVDCVDB_AutoBatalClaimPromo]
AS
BEGIN

select A.NoVoucher 
INTO #tempVoucher
from SD_MasterVoucher A join SD_DetailPakaiVoucher B on A.NoVoucher=B.NoVoucher
where Terpakai=0 and NoSO is null and StatusKlaim='1' and Status=0
and (DATEDIFF(second, TanggalKlaim, getdate()) / 3600.0) >= 5
AND A.JenisPromo NOT IN (
'HM-CNM0622',
'HM-MDR0622',
'HM-MDR0722',
'HM-MDRVV22',
'CPAOPEN2',
'HM-DBSM0422',
'HM-HSM0922',
'HM-HSM1022',
'HM-OCBM0922',
'HM-OCBM1022',
'HM-OCBM1122',
'HM-OCBM1222',
'HM-UOBM0922',
'HM-UOBM1022',
'HM-UOBM1122',
'HM-UOBM1222',
'HM-MDRM0922',
'HM-MDRM1022')

Update SD_MasterVoucher set StatusKlaim='0' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucher)
Update SD_DetailPakaiVoucher set Status='2' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucher) and Status=0

-- Promo Bank HM 2022 Only Update by Anton 10/03/2022
Update SD_DetailPakaiKK set Status='2' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucher) and Status=0

drop table #tempVoucher

-- Promo SHA 2022 Only Update by Anton 21/01/2022
/*
select A.NoVoucher 
INTO #tempVoucherSHA
from SD_MasterVoucher A join SD_DetailPakaiVoucher B on A.NoVoucher=B.NoVoucher
where Terpakai=0 and NoSO is null and StatusKlaim='1' and Status=0 and A.JenisPromo = 'PRSHA'
AND CONVERT(VARCHAR(10), a.ValidTo, 23) < CONVERT(VARCHAR(10), GETDATE(), 23)

Update SD_MasterVoucher set StatusKlaim='0', ValidTo = '2022-04-30' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucherSHA)
Update SD_DetailPakaiVoucher set Status='2' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucherSHA) and Status=0
Update SD_DetailKlaimVoucherFakturUtama set Status='2' where NoVoucher  in (SELECT NoVoucher FROM #tempVoucherSHA) and Status=1

drop table #tempVoucherSHA
*/

END




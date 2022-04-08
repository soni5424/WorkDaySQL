--=== RUN di 9.14\SQLGEHM ===---
--=== JALANKAN TABLE TEMP ini dulu ===---

SELECT distinct workstation INTO #TWS28 FROM [192.168.9.28].hartono.dbo.SAP_User

select * INTO #TSO from [192.168.9.14\sqladira].hartono.dbo.TrxSO
where Tanggal > '20220329'
	AND NoSO not in (SELECT NoSO FROM TrxSO)
	AND KodeWorkStation in  (SELECT workstation FROM #TWS28)

select * INTO #TFK from [192.168.9.14\sqladira].hartono.dbo.TrxFaktur
where Tanggal > '20220329'
	AND NoFaktur not in (SELECT NoFaktur FROM TrxFaktur)
	AND KodeWorkStation in (SELECT workstation FROM #TWS28)

--=== JANGAN lupa di buka INSERT INTO nya ===---


-- insert into TrxSO
select * from #TSO
-- insert into TrxSODetail
select * from [192.168.9.14\sqladira].hartono.dbo.TrxSODetail
where NoSO IN (SELECT NoSO FROM #TSO)
-- insert into PR_TrxSODetailWithPromo
select * from [192.168.9.14\sqladira].hartono.dbo.PR_TrxSODetailWithPromo
where NoSO IN (SELECT NoSO FROM #TSO)


-- insert into TrxFaktur
select * from #TFK
-- insert into TrxFakturDetail
select * from [192.168.9.14\sqladira].hartono.dbo.TrxFakturDetail
where NoFaktur in (select NoFaktur from #TFK)
-- insert into TrxFakturBayar
select * from [192.168.9.14\sqladira].hartono.dbo.TrxFakturBayar
where NoFaktur in (select NoFaktur from #TFK)
-- insert into TrxFakturBayarVPR
select * from [192.168.9.14\sqladira].hartono.dbo.TrxFakturBayarVPR
where NoFaktur in (select NoFaktur from #TFK)
-- insert into AD_TrxFakturProsesInsurance
select * from [192.168.9.14\sqladira].hartono.dbo.AD_TrxFakturProsesInsurance
where NoFakturIns IN (select NoFaktur from #TFK)
-- insert into AD_TrxFakturProsesInsuranceDetail
select * from [192.168.9.14\sqladira].hartono.dbo.AD_TrxFakturProsesInsuranceDetail
where NoFakturIns IN (select NoFaktur from #TFK)
-- insert into MB_TrxFakturBayarMember
select * from [192.168.9.14\sqladira].hartono.dbo.MB_TrxFakturBayarMember
where NoFaktur IN (select NoFaktur from #TFK)



select * INTO #TLPH from [192.168.9.14\sqladira].hartono.dbo.TrxLPH
where NoLPH not in (SELECT NoLPH FROM TrxLPH)
	AND KodeWorkStation IN (SELECT workstation FROM #TWS28)
-- insert into TrxLPH
select * FROM #TLPH
-- insert into TrxLPHDetail
select * from [192.168.9.14\sqladira].hartono.dbo.TrxLPHDetail
where NoLPH01 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH02 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH03 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH04 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH05 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH06 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH07 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH08 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH09 in (select NoLPH FROM #TLPH)
	--OR 	NoLPH10 in (select NoLPH FROM #TLPH)


-- insert into TrxRekas
select * from [192.168.9.14\sqladira].hartono.dbo.TrxRekas
where Tanggal > '20220329'
	AND KodeWS in (SELECT workstation FROM #TWS28)
	AND NoRekas not in (SELECT NoRekas FROM TrxRekas)


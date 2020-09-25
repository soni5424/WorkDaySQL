USE [Hartono]
GO

/****** Object:  StoredProcedure [dbo].[VP_PGetListOutstandingKF]    Script Date: 09/06/2020 08.22.03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Edit:			|David C.H|
-- Create date:		|22/10/2019|
-- Description:		|Tambah Pengecekan OutstandingAmount>0|
-- Project:			||

-- Modified By:		|Peter|
-- Modified date:	|23/12/2019|
-- Description:		|Ubah ambil data untuk FK Seragam|
-- Project:			||

-- Modified By:		|David|
-- Modified date:	|11/05/2020|
-- Description:		|DocAmount tabel FI_AmountPOTPO * 100|
-- Project:			||
-- =============================================

ALTER PROCEDURE [dbo].[VP_PGetListOutstandingKF] 
	@VendorID	varchar(20)
AS
BEGIN

SELECT * FROM(


select *,'1' Urutan from 
(
select DocNo,DocDate,
CASE WHEN DocStatus ='K1' THEN 'Accrued'
WHEN  DocStatus ='K2' THEN 'Settled'
END AS DocStatus
,AgrNo,AgrDesc,
DOCAmount+
ISNULL((select SUM(DocAmount)*100 from fi_amountpotpo B where B.Assignment =A.Assignment),0)
- ISNULL((select SUM(DocAmount) from fi_amountpotlain C where C.Assignment =A.Assignment and C.DocNo not like '51%'),0)
OutstandingAmount
 from fi_amountkf A where A.VendorID=@VendorID
 ) A
 where OutstandingAmount>0

 union 

/*
select C.NoFaktur DocNo,C.Tanggal DocDate,'FK Seragam' DocStatus, C.NoFaktur AgrNo,C.KeteranganSO AgrDesc,C.TotalFaktur-ISNULL(C.TotalBayar,0)-ISNULL(C.TotalPelunasan,0) OutstandingAmount,'2' Urutan from fi_mappingvendorcustpos A
join TrxFaktur B on B.NoMember=A.NoMember
and NoFaktur not in (select NoFaktur from trxreturpenjualan)
join fi_fkseragam C on C.NoFaktur=B.NoFaktur
where vendor_ac_numb=@VendorID
*/

select C.NoFaktur DocNo,C.Tanggal DocDate,'FK Seragam' DocStatus, C.NoFaktur AgrNo,C.KeteranganSO AgrDesc,C.TotalFaktur-ISNULL(C.TotalBayar,0)-ISNULL(C.TotalPelunasan,0) OutstandingAmount,'2' Urutan 
from fi_mappingvendorcustpos A, fi_fkseragam C 
where A.NoMember=C.NoMember
and (C.TotalFaktur-ISNULL(C.TotalBayar,0)-ISNULL(C.TotalPelunasan,0))>0
and A.vendor_ac_numb=@VendorID
union

/*select A.ContractNo DocNo,A.ContractDate DocDate,'SO Contract' DocStatus,A.ContractNo AgrNo,C.Description AgrDesc,C.Amount OutstandingAmount,'3' Urutan from fi_SOContract A join SAP_Vendor B on A.Partner=B.Customer_Num
join fi_SOContractDetail C on C.ContractNo = A.ContractNo
where Vendor_AC_Numb=@VendorID
and(
A.ContractNo not in(select precedingdoc from fi_socontractflow)
or
A.ContractNo in(select precedingdoc from fi_socontractflow where followondoc in(select precedingdoc from fi_socontractflow where FollowOnDoc not like '39%'))
)*/


select A.ContractNo DocNo,A.ContractDate DocDate,'SO Contract' DocStatus,A.ContractNo AgrNo,C.Description AgrDesc,C.Amount OutstandingAmount,'3' Urutan from fi_SOContract A join SAP_Vendor B on A.Partner=B.Customer_Num
join fi_SOContractDetail C on C.ContractNo = A.ContractNo
where Vendor_AC_Numb=@VendorID
and(
A.ContractNo not in(select precedingdoc from fi_socontractflow)
or
A.ContractNo in(select precedingdoc from fi_socontractflow D where D.precedingdoc not in
(

select top 1 precedingdoc1 from(
select 
a.precedingdoc precedingdoc1,
a.precedingitem precedingitem1,
a.followondoc followondoc1,
a.followonitem followonitem1,
b.precedingdoc precedingdoc2,
b.precedingitem precedingitem2,
b.followondoc followondoc2,
b.followonitem followonitem2,
case when b.precedingitem is not null and a.precedingitem <> b.precedingitem then '1'
end as 'cek'
from dbo.FI_SOContractFlow a left join dbo.FI_SOContractFlow b 
on a.followondoc = b.precedingdoc
where a.precedingdoc = D.precedingdoc 
and a.followondoc not like '39%'
) A
where cek is null
and precedingdoc2 is null
group by precedingdoc1,precedingitem1
)
))



union

select BillingNo DocNo,PostingDate DocDate,'Billing Contract' DocStatus, A.ContractNo AgrNo,ContractDesc AgrDesc,Amount-(SELECT ISNULL(SUM(B.Amount),0)FROM fi_potbillingcontract B where B.Assignment=A.Assignment) OutstandingAmount,'4' Urutan from fi_billingcontract A
join FI_SOContract B on A.ContractNo=B.ContractNo where B.Partner=(select Customer_Num from sap_vendor where Vendor_AC_Numb=@VendorID)

)AllData 
where OutstandingAmount>0
order by Urutan,DocDate ASC,docstatus desc
END
GO


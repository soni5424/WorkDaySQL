select top 10 
	created_on as RegistrationTime,
	approve_date_cso as ApprovalDateTime,
	employee_id_cso_approve as ApproverByNo,
	usrcso.NamaUser as ApproverByName,
	approve_date_manager as VerificationDateTime,
	employee_id_manager_approve as VerificationBy,
	usrmng.NamaUser as VerificationByName,
	* 
from ApprovalNewMemberHPC aprv 
	LEFT JOIN MasterUser usrcso on usrcso.KodeBarcode = aprv.employee_id_cso_approve
	LEFT JOIN MasterUser usrmng on usrmng.KodeBarcode = aprv.employee_id_manager_approve
order by created_on desc


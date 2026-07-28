select top 10 * from work_location_tbl 

select * 
from [dbo].[emp_work_location_tbl] 
where valid_from > '20250101' and work_location='KTI'
	and employee_id in (select employee_id from [dbo].[emp_work_location_tbl] where valid_from <= '20260119' and work_location='BDB')

select * from emp_work_location_tbl where employee_id='52600121' -- ini baru bulan depan / bulan 7
select * from emp_work_location_tbl where employee_id='22600213' -- bulan awal nggak di hitung jadi nggak kelihatan
select * from emp_work_location_tbl where employee_id='52500066' order by valid_from -- ini sampai akhir bulan,
select * from emp_work_location_tbl where employee_id='52600047' order by valid_from -- ini sampai akhir bulan,
select * from emp_work_location_tbl where employee_id='52500269' order by valid_from -- ini sampai akhir bulan,
select * from emp_work_location_tbl where employee_id='52500213' order by valid_from
select * from emp_work_location_tbl where employee_id='22400240' order by valid_from
select * from emp_work_location_tbl where employee_id='32600004' order by valid_from
select * from emp_work_location_tbl where employee_id='52600007' order by valid_from
select * from emp_work_location_tbl where employee_id='22500027' order by valid_from
select * from emp_work_location_tbl where employee_id='52400209' order by valid_from


select employee_id from VBWEmpWorkPeriodForTarget where working_date='20260501' order by employee_id

select * from emp_area_vendor_tbl where employee_id='52500008'
select * from area_tbl where area_no in ('699', '703')

select * from employee_position_tbl where employee_id='12500077'



SELECT 
    baru.employee_id,
    baru.company_id,
    lama.work_location AS lokasi_lama,
    baru.work_location AS lokasi_baru,
    lama.valid_from AS tanggal_lama_mulai,
    baru.valid_from AS tanggal_pindah_efektif,
    baru.valid_to AS tanggal_baru_selesai
FROM [dbo].[emp_work_location_tbl] baru
INNER JOIN [dbo].[emp_work_location_tbl] lama 
    ON baru.employee_id = lama.employee_id
WHERE 
    -- 1. Kondisi perpindahan spesifik dari BDB ke KTI
    lama.work_location = 'BDB' 
    AND baru.work_location = 'KTI'
    and baru.valid_from > '20251001'
    and baru.employee_id not in ('52600121', '22600213', '52500066', '52600047', '52500269','52500213')
    -- 3. Filter agar TANGGAL EFEKT'52500066'IF BARU bukan tanggal 1, 30, atau 31
    AND DAY(baru.valid_from) NOT IN (1, 30, 31)

ORDER BY baru.employee_id;


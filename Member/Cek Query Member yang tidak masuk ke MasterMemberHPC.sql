select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC
select distinct len(no_member_hrm) from [10.50.5.59].Hartono.dbo.MasterMemberHPC
select count(*) from [10.50.5.59].Hartono.dbo.MasterMemberHPC
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHPC where no_member_hpc like 'HPC-00-000-010423-10%' order by no_member_hpc


WITH ExtractedData AS (
    SELECT 
        no_member_hpc,
        LEN(no_member_hpc) AS total_len,
        -- Ambil prefix sebelum strip terakhir (contoh: 'HPC-00-000-010114' atau 'HPC-010102')
        LEFT(no_member_hpc, LEN(no_member_hpc) - CHARINDEX('-', REVERSE(no_member_hpc))) AS prefix,
        -- Ambil angka urutan di paling belakang dan diubah ke INT
        CAST(RIGHT(no_member_hpc, CHARINDEX('-', REVERSE(no_member_hpc)) - 1) AS INT) AS seq_num
    FROM [10.50.5.59].Hartono.dbo.MasterMemberHPC
    WHERE LEN(no_member_hpc) IN (14, 21)
      AND ISNUMERIC(RIGHT(no_member_hpc, CHARINDEX('-', REVERSE(no_member_hpc)) - 1)) = 1
),
Bounds AS (
    SELECT 
        prefix,
        total_len,
        MIN(seq_num) AS min_seq,
        MAX(seq_num) AS max_seq
    FROM ExtractedData
    GROUP BY prefix, total_len
),
Numbers AS (
    SELECT 
        b.prefix,
        b.total_len,
        b.min_seq AS seq_num,
        b.max_seq
    FROM Bounds b
    
    UNION ALL
    
    SELECT 
        n.prefix,
        n.total_len,
        n.seq_num + 1,
        n.max_seq
    FROM Numbers n
    WHERE n.seq_num < n.max_seq
)
SELECT 
    -- Menggunakan RIGHT('000' + ..., 3) agar format angka di akhir selalu 3 digit (misal: 016, 074)
    n.prefix + '-' + RIGHT('000' + CAST(n.seq_num AS VARCHAR(10)), 3) AS missing_no_member_hpc
FROM Numbers n
LEFT JOIN ExtractedData e 
    ON n.prefix = e.prefix 
   AND n.seq_num = e.seq_num
WHERE e.seq_num IS NULL
    --and n.prefix + '-' + RIGHT('000' + CAST(n.seq_num AS VARCHAR(10)), 3) in ('HPC-100102-439','HPC-160801-229')
ORDER BY n.prefix, n.seq_num
OPTION (MAXRECURSION 0);
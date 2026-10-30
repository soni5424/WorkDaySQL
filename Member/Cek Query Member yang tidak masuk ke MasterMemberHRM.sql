select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHRM
select distinct len(no_member_hrm) from [10.50.5.59].Hartono.dbo.MasterMemberHRM
select count(*) from [10.50.5.59].Hartono.dbo.MasterMemberHRM
select top 10 * from [10.50.5.59].Hartono.dbo.MasterMemberHRM where no_member_hrm like 'HRM-02-M63-100126-00%' order by no_member_hrm

WITH ExtractedData AS (
    SELECT 
        no_member_hrm,
        LEN(no_member_hrm) AS total_len,
        -- Ambil prefix sebelum strip terakhir (contoh: 'HRM-07-001-100824')
        LEFT(no_member_hrm, LEN(no_member_hrm) - CHARINDEX('-', REVERSE(no_member_hrm))) AS prefix,
        -- Ambil angka urutan di paling belakang dan diubah ke INT
        CAST(RIGHT(no_member_hrm, CHARINDEX('-', REVERSE(no_member_hrm)) - 1) AS INT) AS seq_num
    FROM [10.50.5.59].Hartono.dbo.MasterMemberHRM
    WHERE LEN(no_member_hrm) = 21
      AND ISNUMERIC(RIGHT(no_member_hrm, CHARINDEX('-', REVERSE(no_member_hrm)) - 1)) = 1
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
    -- Menghasilkan format no_member_hrm dengan 3 digit urutan di akhir (contoh: 281, 003)
    n.prefix + '-' + RIGHT('000' + CAST(n.seq_num AS VARCHAR(10)), 3) AS missing_no_member_hrm
FROM Numbers n
LEFT JOIN ExtractedData e 
    ON n.prefix = e.prefix 
   AND n.seq_num = e.seq_num
WHERE e.seq_num IS NULL
ORDER BY n.prefix, n.seq_num
OPTION (MAXRECURSION 0);
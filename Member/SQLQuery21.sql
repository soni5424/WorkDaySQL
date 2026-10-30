WITH ExtractedData AS (
    SELECT 
        no_member_hpc,
        LEN(no_member_hpc) AS total_len,
        -- Ambil prefix sebelum strip terakhir
        LEFT(no_member_hpc, LEN(no_member_hpc) - CHARINDEX('-', REVERSE(no_member_hpc))) AS prefix,
        -- Ambil angka paling belakang dan diubah ke INT
        CAST(RIGHT(no_member_hpc, CHARINDEX('-', REVERSE(no_member_hpc)) - 1) AS INT) AS seq_num
    FROM [10.50.5.59].Hartono.dbo.MasterMemberHPC
    -- Menyarikan hanya yang berpanjang 14 atau 21 karakter dan memiliki format valid (mengandung angka di akhir)
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
-- Generasi urutan angka secara otomatis berdasarkan rentang MIN & MAX per kelompok prefix
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
    n.prefix + '-' + CAST(n.seq_num AS VARCHAR(10)) AS missing_no_member_hpc
FROM Numbers n
LEFT JOIN ExtractedData e 
    ON n.prefix = e.prefix 
   AND n.seq_num = e.seq_num
WHERE e.seq_num IS NULL
    --and n.prefix + '-' + CAST(n.seq_num AS VARCHAR(10)) in ('HPC-100102-439','HPC-160801-229')
ORDER BY missing_no_member_hpc
OPTION (MAXRECURSION 0);
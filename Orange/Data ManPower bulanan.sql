/*****************************************************************************************
Tujuan Query
------------------------------------------------------------------------------------------
Membentuk data manpower bulanan berdasarkan:
1. Tanggal Join Karyawan (join_date)
2. Tanggal Resign Karyawan (resign_date)

Sumber Data:
------------------------------------------------------------------------------------------
Menggunakan view:

    VBWEmpJoinResignDate

Field yang digunakan:

    person_id
    join_date
    resign_date

View ini sudah menyediakan join date dan resign date sehingga tidak lagi
menggunakan employee_tbl maupun VBWEmpResignDate.

Output:
------------------------------------------------------------------------------------------
- 1 baris per Employee per Bulan
- Data dimulai dari bulan Join
- Data berakhir pada bulan Resign
- Jika belum resign (99990101), data akan dibentuk sampai bulan Desember
  pada tahun saat query dijalankan.

Rule Tambahan:
------------------------------------------------------------------------------------------
- Jika Join Date jatuh pada tanggal 1, maka bulan join ikut dihitung.

  Contoh:
  Join Date  : 2026-01-01
  Resign Date: 2026-03-30

  Hasil:
  20260101
  20260201
  20260301

- Jika Join Date bukan tanggal 1, maka bulan join TIDAK dihitung.
  Perhitungan dimulai dari bulan berikutnya.

  Contoh:
  Join Date  : 2026-01-02
  Resign Date: 2026-03-30

  Hasil:
  20260201
  20260301
*****************************************************************************************/


/*****************************************************************************************
Menentukan bulan maksimum yang akan dibentuk.

GETDATE() = tanggal saat query dijalankan.

Contoh:
Jika dijalankan tahun 2026
@MaxMonth = 2026-12-01

Jika dijalankan tahun 2027
@MaxMonth = 2027-12-01
*****************************************************************************************/
DECLARE @MaxMonth DATE = DATEFROMPARTS(YEAR(GETDATE()),12,1);

-- Untuk testing dapat diubah manual:
-- DECLARE @MaxMonth DATE = DATEFROMPARTS(YEAR('20271201'),12,1);


/*****************************************************************************************
Recursive CTE untuk membentuk data bulanan per employee
*****************************************************************************************/
WITH EmployeeMonth AS (

    /*************************************************************************************
    Data awal (Anchor Member)

    Mengambil data langsung dari view VBWEmpJoinResignDate.

    join_date dan resign_date pada view bertipe VARCHAR(10)
    dengan format YYYYMMDD sehingga perlu dikonversi ke DATE.

    Rule:
    -------------------------------------------------------------------------------
    Jika Join Date = tanggal 1
        -> bulan join dihitung

    Jika Join Date <> tanggal 1
        -> bulan join tidak dihitung
        -> mulai dari bulan berikutnya

    Contoh:
    Join Date = 2026-04-01
    MonthDate = 2026-04-01

    Join Date = 2026-04-06
    MonthDate = 2026-05-01
    *************************************************************************************/
    SELECT
        E.person_id,

        CONVERT(DATE,E.join_date) AS JoinDate,

        CASE
            WHEN DAY(CONVERT(DATE,E.join_date)) = 1
                THEN DATEFROMPARTS(
                        YEAR(CONVERT(DATE,E.join_date)),
                        MONTH(CONVERT(DATE,E.join_date)),
                        1
                     )

            ELSE DATEADD(
                    MONTH,
                    1,
                    DATEFROMPARTS(
                        YEAR(CONVERT(DATE,E.join_date)),
                        MONTH(CONVERT(DATE,E.join_date)),
                        1
                    )
                 )
        END AS MonthDate,

        E.resign_date

    FROM VBWEmpJoinResignDate E

    UNION ALL

    /*************************************************************************************
    Recursive Member

    Menambahkan 1 bulan terus menerus sampai mencapai:
    - Bulan resign, atau
    - Bulan Desember tahun berjalan (@MaxMonth) jika belum resign.

    Contoh:
    20260501
    20260601
    20260701
    dst...
    *************************************************************************************/
    SELECT
        person_id,
        JoinDate,
        DATEADD(MONTH,1,MonthDate),
        resign_date
    FROM EmployeeMonth
    WHERE DATEADD(MONTH,1,MonthDate) <=
          CASE

              /***********************************************************************
              Employee masih aktif

              resign_date = 99990101

              Data dibentuk sampai Desember tahun saat query dijalankan.
              ***********************************************************************/
              WHEN resign_date = '99990101'
                   THEN @MaxMonth

              /***********************************************************************
              Employee sudah resign

              Ambil bulan resign.

              Contoh:
              Resign Date = 2026-03-30

              Maka bulan terakhir yang dibentuk:
              2026-03-01
              ***********************************************************************/
              ELSE DATEFROMPARTS(
                        YEAR(CONVERT(DATE,resign_date)),
                        MONTH(CONVERT(DATE,resign_date)),
                        1
                   )

          END
)

/*****************************************************************************************
Menampilkan hasil akhir
*****************************************************************************************/
SELECT 
    person_id,
    CONVERT(VARCHAR(8), MonthDate, 112) AS working_date
into #employeemonth
FROM EmployeeMonth
/*****************************************************************************************
Safety Filter

Memastikan tidak ada data yang melewati bulan maksimum
(Desember tahun saat query dijalankan)
*****************************************************************************************/
WHERE MonthDate <= @MaxMonth
--ORDER BY
--    person_id,
--    MonthDate

/*****************************************************************************************
MAXRECURSION 0

Default SQL Server hanya mengizinkan 100 recursive loop.

Karena employee lama dapat memiliki:
2010-09 s/d 2026-12 = 196 bulan

Maka batas 100 tidak cukup.

MAXRECURSION 0 berarti:
- Tidak ada batas jumlah recursive
- Recursive berhenti sesuai kondisi WHERE pada CTE
*****************************************************************************************/
OPTION (MAXRECURSION 0);





select * from VBWEmpJoinResignDate where person_id='41000028'


SELECT *
FROM #employeemonth where person_id='41000028'

SELECT *
FROM dbo.VBWEmpWorkPeriodForTarget
where person_id='41000028'


select * from VBWEmpJoinResignDate where person_id in (
    SELECT person_id		
    FROM #employeemonth				
    EXCEPT		
    SELECT person_id
FROM dbo.VBWEmpWorkPeriodForTarget
) and substring(join_date, 0, 7) != substring(resign_date, 0, 7)


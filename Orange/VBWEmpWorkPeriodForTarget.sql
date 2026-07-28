--select count(*) from  VBWEmpWorkPeriodForTarget

select * from VBWEmpWorkPeriodForTarget where person_id='21900253' order by working_date asc
select * from VBWEmpWorkPeriodForTarget where person_id='11000080' order by working_date asc

select * from [dbo].[VBWEmpJoinResignDate] where right(join_date, 2)


--create view VBWEmpWorkPeriodForTarget
WITH N AS
(
    SELECT TOP (1000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
),
Emp AS
(
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
        END AS StartMonth,

        CASE
            WHEN E.resign_date = '99990101'
                THEN DATEFROMPARTS(YEAR(GETDATE()),12,1)

            ELSE DATEFROMPARTS(
                    YEAR(CONVERT(DATE,E.resign_date)),
                    MONTH(CONVERT(DATE,E.resign_date)),
                    1
                 )
        END AS EndMonth

    FROM dbo.VBWEmpJoinResignDate E
)

SELECT
    E.person_id,
    CONVERT(
        VARCHAR(8),
        DATEADD(MONTH,N.n,E.StartMonth),
        112
    ) AS working_date
FROM Emp E
INNER JOIN N
    ON N.n <= DATEDIFF(
                    MONTH,
                    E.StartMonth,
                    E.EndMonth
                )
WHERE DATEADD(MONTH,N.n,E.StartMonth)
      <= DATEFROMPARTS(YEAR(GETDATE()),12,1)
      and e.person_id='32600028'


select * from VBWEmpJoinResignDate where person_id='32600028'
select * from employee_tbl where employee_id='32600028'      
select * from person_tbl where person_id='32600028'      
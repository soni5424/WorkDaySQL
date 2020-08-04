--update masterparameter set nilai=convert(varchar, getdate(), 103) where nama='tanggalupdatesales'

-- BACK TO DEFAULT
update masterparameter set nilai='14/02/2019' where nama='tanggalupdatesales'
update masterparameter set nilai='02/01/2019' where nama='tanggalupdatecashier'


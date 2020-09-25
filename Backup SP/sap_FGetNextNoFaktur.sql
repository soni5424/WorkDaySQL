USE [Hartono]
GO

/****** Object:  UserDefinedFunction [dbo].[sap_FGetNextNoFaktur]    Script Date: 17/09/2020 08.44.42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER   function [dbo].[sap_FGetNextNoFaktur] (
	@KodeStore char(2),
	@KodeWorkstation char(3),
	@JenisFaktur char(2)
)
returns char(18)
as
begin
declare @KodeJenisDokumen char(2)
select @KodeJenisDokumen = KodeJenisDok
from MasterJenisDokumen
where NamaJenisDok = 'Faktur'
declare @cLastFakturNumber char(5), @cNextFakturNumber char(5)
declare @iLastFakturNumber int, @iNextFakturNumber int
declare @hasil char(18)
select top 1 @cLastFakturNumber = left(right(NoFaktur,8),5)
from TrxFaktur
where 
	KodeStore = @KodeStore
	AND KodeWorkstation = @KodeWorkStation
	--AND JenisFaktur = @JenisFaktur
order by left(right(NoFaktur,8),5) desc
if @cLastFakturNumber IS NULL
	set @cNextFakturNumber = '00001'
else
begin
	set @iLastFakturNumber = cast(@cLastFakturNumber as int)
	set @iNextFakturNumber = @iLastFakturNumber + 1
	set @cNextFakturNumber = right('00000' + cast(@iNextFakturNumber as varchar), 5)
end
--set @hasil = @KodeJenisDokumen + '-' + @KodeStore + '-' + @KodeWorkStation + '-' + @cNextFakturNumber + '-' + @JenisFaktur
set @hasil = @KodeJenisDokumen + '-' + @KodeStore + '-' + @KodeWorkStation + '-' + @cNextFakturNumber
return @hasil
end





GO


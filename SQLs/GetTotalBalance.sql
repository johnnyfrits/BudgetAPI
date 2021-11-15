DECLARE @Account INT = 2
DECLARE @AccountBF INT = 3
DECLARE @Reference VARCHAR(6) = '202103'

select T.*, SUM(T.Total) OVER() AS TotalGeral
from(

select 'Johnny' AS Account,
	   --dbo.GetPreviousBalance(@Account, @Reference) AS SaldoAnterior, 
	   --dbo.GetCurrentBalance(@Account, @Reference) AS SaldoAtual,
	   dbo.GetTotalBalance(@Account, @Reference) AS Total

union all 

select 'Bella Fashion' AS Account,
	   --dbo.GetPreviousBalance(@AccountBF, @Reference) AS SaldoAnterior, 
	   --dbo.GetCurrentBalance(@AccountBF, @Reference) AS SaldoAtual,
	   dbo.GetTotalBalance(@AccountBF, @Reference) AS Total

) T
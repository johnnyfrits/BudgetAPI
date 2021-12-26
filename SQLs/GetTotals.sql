DECLARE @AccountId INT = 2
DECLARE @Reference INT = '202112'

SELECT a.*,
	   dbo.GetTotalBalance(@AccountId, @Reference) AS TotalBalance,
	   dbo.GetPreviousBalance(@AccountId, @Reference) AS PreviousBalance,
	   dbo.GetTotalYields(@AccountId, @Reference) AS TotalYields
FROM dbo.Accounts a
WHERE a.Id = @AccountId

select * from dbo.GetAccountTotals(@AccountId, @Reference)
DECLARE @AccountId INT = 2
DECLARE @Reference INT = '202110'

SELECT dbo.GetTotalBalance(@AccountId, @Reference) AS TotalBalance,
	   dbo.GetPreviousBalance(@AccountId, @Reference) AS PreviousBalance,
	   dbo.GetTotalYields(@AccountId, @Reference) AS TotalYields
namespace BudgetAPI.Models
{
	public class AccountsSummaryTotals
	{
		public decimal ForecastBalance { get; set; }
		public decimal AvailableBalance { get; set; }
		public decimal ForecastSpared { get; set; }
		public decimal AvailableSpared { get; set; }
		public decimal DrawnBalance { get; set; }
		public decimal WithoutDrawnBalance { get; set; }
	}

}
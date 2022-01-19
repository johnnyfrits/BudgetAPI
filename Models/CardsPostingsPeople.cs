namespace BudgetAPI.Models
{
	public class CardsPostingsPeople
	{
		public string Person { get; set; }
		public decimal ToReceive { get; set; }
		public decimal Received { get; set; }
		public decimal Remaining { get; set; }
	}
}

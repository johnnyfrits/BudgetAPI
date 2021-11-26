namespace BudgetAPI.Models
{
	public class Yields
	{
		public int Id { get; set; }
		public int AccountId { get; set; }
		public DateTime Date { get; set; }
		public string Reference { get; set; }
		public decimal Amount { get; set; }
	}
}

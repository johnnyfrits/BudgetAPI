namespace BudgetAPI.Models
{
	public class AccountsPostings
	{
		public int Id { get; set; }
		public int AccountId { get; set; }
		public DateTime Date { get; set; }
		public string Reference { get; set; }
		public string Description { get; set; }
		public decimal Amount { get; set; }
		public string? Note { get; set; }
	}
}

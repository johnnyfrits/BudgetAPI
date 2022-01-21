namespace BudgetAPI.Models
{
	public class CardsReceipts
	{
		public int Id { get; set; }
		public DateTime Date { get; set; }
		public string Reference { get; set; }
		public int CardId { get; set; }
		public string PeopleId { get; set; }
		public int AccountId { get; set; }
		public decimal Amount { get; set; }
		public string? Note { get; set; }
	}
}

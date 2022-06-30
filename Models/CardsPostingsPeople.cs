namespace BudgetAPI.Models
{
	public class CardsPostingsPeople
	{
		public string Reference { get; set; }
		public int CardId { get; set; }
		public string? Person { get; set; }
		public decimal ToReceive { get; set; }
		public decimal Received { get; set; }
		public decimal Remaining { get; set; }
		public IEnumerable<CardsPostings>? CardsPostings { get; set; }
		public IEnumerable<Incomes>? Incomes { get; set; }
		public IEnumerable<AccountsPostings>? CardsReceipts { get; set; }
		public IEnumerable<AccountsPostings>? AccountsPostings { get; set; }
	}
}

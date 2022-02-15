namespace BudgetAPI.Models
{
	public class ExpensesByCategories
	{
		public int? Id { get; set; }
		public string? Reference { get; set; }
		public int? CardId { get; set; }
		public string? Category { get; set; }
		
		public decimal? Amount { get; set; }
		public decimal? Perc { get; set; }
		public IEnumerable<Expenses>? Expenses { get; set; }
		public IEnumerable<CardsPostings>? CardsPostings { get; set; }
	}
}

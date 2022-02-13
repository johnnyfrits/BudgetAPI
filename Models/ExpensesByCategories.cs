namespace BudgetAPI.Models
{
	public class ExpensesByCategories
	{
		public int Id { get; set; }
		public string Category { get; set; }
		
		public decimal Amount { get; set; }
		public decimal Perc { get; set; }
	}
}

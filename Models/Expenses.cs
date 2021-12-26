namespace BudgetAPI.Models
{
	public class Expenses
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public short? Position { get; set; }
		public string Reference { get; set; }
		public string Description { get; set; }
		public decimal ToPay{ get; set; }
		public decimal Paid { get; set; }
		public string? Note { get; set; }
	}
}

namespace BudgetAPI.Models
{
	public class Accounts
	{
		public int Id { get; set; }
		public Users UserId { get; set; }
		public string Name { get; set; }
		public string? Color { get; set; }
	}
}

namespace BudgetAPI.Models
{
	public class Cards
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Name { get; set; }
		public string? Color { get; set; }
		public Users User { get; set; }

	}
}

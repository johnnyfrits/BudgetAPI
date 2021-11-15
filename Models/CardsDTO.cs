namespace BudgetAPI.Models
{
	public class CardsDTO
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Name { get; set; }
		public string? Color { get; set; }
		public UsersDTO User { get; set; }

	}
}

using System.ComponentModel.DataAnnotations.Schema;

namespace BudgetAPI.Models
{
	public class Accounts
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Name { get; set; }
		public string? Color { get; set; }
	}
}

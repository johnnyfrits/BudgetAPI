using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace BudgetAPI.Models
{
	public class Accounts
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		[NotNull]
		public string Name { get; set; }
		public string? Color { get; set; }
	}
}

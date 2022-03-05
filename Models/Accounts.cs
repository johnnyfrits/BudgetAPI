using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace BudgetAPI.Models
{
	public class Accounts
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Name { get; set; }
		public string? Color { get; set; }
		public string? Background { get; set; }
		public bool? CalcInGeneral { get; set; }
		public bool? Disabled { get; set; }
	}
}

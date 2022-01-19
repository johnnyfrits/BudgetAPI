using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace BudgetAPI.Models
{
	public class AccountsSummary
	{
		public int Position { get; set; }
		public string Description { get; set; }
		public decimal ForecastBalance { get; set; }
		public decimal AvailableBalance { get; set; }
	}

}
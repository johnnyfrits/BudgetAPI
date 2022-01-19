using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace BudgetAPI.Models
{
	public class AccountsSummaryTotals
	{
		public decimal ForecastBalance { get; set; }
		public decimal AvailableBalance { get; set; }
		public decimal ForecastSpared { get; set; }
		public decimal AvailableSpared { get; set; }
	}

}
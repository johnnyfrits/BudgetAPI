using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace BudgetAPI.Models
{
    public class AccountsDTO
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Name { get; set; }
        public string? Color { get; set; }
        public string? Background { get; set; }
        public bool? CalcInGeneral { get; set; }
        public bool? Disabled { get; set; }
        public decimal GrandTotalBalance { get; set; }
        public decimal TotalBalance { get; set; }
        public decimal PreviousBalance { get; set; }
        public decimal TotalYields { get; set; }
        public decimal GrandTotalYields { get; set; }
    }
}

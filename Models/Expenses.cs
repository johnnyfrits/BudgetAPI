namespace BudgetAPI.Models
{
	public class Expenses
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Reference { get; set; }
		public short? Position { get; set; }
		public string Description { get; set; }
		public decimal ToPay{ get; set; }
		public decimal Paid { get; set; }
		public string? Note { get; set; }
		public int? CardId { get; set; }
		public int? AccountId { get; set; }
		public DateTime? DueDate { get; set; }
		public int? ParcelNumber { get; set; }
		public int? Parcels { get; set; }
		public decimal TotalToPay { get; set; }
		public int? CategoryId { get; set; }
	}
}

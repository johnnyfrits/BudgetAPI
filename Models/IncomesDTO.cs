namespace BudgetAPI.Models
{
	public class IncomesDTO
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Reference { get; set; }
		public short? Position { get; set; }
		public string Description { get; set; }
		public decimal ToReceive{ get; set; }
		public decimal Received{ get; set; }
		public decimal Remaining { get; set; }
		public string? Note { get; set; }
		public int? CardId { get; set; }
		public int? AccountId { get; set; }
	}
}

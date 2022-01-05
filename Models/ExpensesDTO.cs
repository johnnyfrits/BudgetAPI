﻿namespace BudgetAPI.Models
{
	public class ExpensesDTO
	{
		public int Id { get; set; }
		public int UserId { get; set; }
		public string Reference { get; set; }
		public short? Position { get; set; }
		public string Description { get; set; }
		public decimal ToPay{ get; set; }
		public decimal Paid { get; set; }
		public decimal Remaining { get; set; }
		public string? Note { get; set; }
	}
}
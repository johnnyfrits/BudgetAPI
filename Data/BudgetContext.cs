using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Data
{
	public class BudgetContext : DbContext
	{
		public BudgetContext(DbContextOptions<BudgetContext> options) : base(options)
		{
		}

		public DbSet<Accounts> Accounts { get; set; }
		public DbSet<Cards> Cards { get; set; }
		public DbSet<Users> Users { get; set; }
		public DbSet<BudgetAPI.Models.Yields> Yields { get; set; }
		public DbSet<BudgetAPI.Models.AccountsPostings> AccountsPostings { get; set; }
		public DbSet<BudgetAPI.Models.CardsPostings> CardsPostings { get; set; }

	}
}

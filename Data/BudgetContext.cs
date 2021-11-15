using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Data
{
	public class BudgetContext : DbContext
	{
		public BudgetContext(DbContextOptions<BudgetContext> options) : base(options)
		{
		}

		public DbSet<Users> Users { get; set; }
		public DbSet<Cards> Cards { get; set; }

	}
}

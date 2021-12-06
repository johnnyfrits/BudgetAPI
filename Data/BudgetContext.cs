using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Data
{
	public class BudgetContext : DbContext
	{
		public BudgetContext(DbContextOptions<BudgetContext> options) : base(options)
		{

		}

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			base.OnModelCreating(modelBuilder);

			modelBuilder.Entity<AccountsDTO>().ToTable("AccountsDTO").HasNoKey();

			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetAccountTotals), new[] { typeof(int), typeof(string) }));
		}

		public IQueryable<AccountsDTO> GetAccountTotals(int accountId, string reference) => FromExpression(() => GetAccountTotals(accountId, reference));

		public DbSet<Accounts> Accounts { get; set; }
		public DbSet<Cards> Cards { get; set; }
		public DbSet<Users> Users { get; set; }
		public DbSet<Yields> Yields { get; set; }
		public DbSet<AccountsPostings> AccountsPostings { get; set; }
		public DbSet<CardsPostings> CardsPostings { get; set; }

	}
}

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
			modelBuilder.Entity<AccountsSummary>().ToTable("AccountsSummary").HasNoKey();
			modelBuilder.Entity<AccountsSummaryTotals>().ToTable("AccountsSummaryTotals").HasNoKey();
			modelBuilder.Entity<CardsPostingsPeople>().ToTable("CardsPostingsPeople").HasNoKey();
			modelBuilder.Entity<BudgetTotals>().ToTable("GetBudgetTotals").HasNoKey();
			modelBuilder.Entity<ExpensesByCategories>().ToTable("GetExpensesByCategories").HasNoKey();

			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetAccountTotals), new[] { typeof(int), typeof(string) }));
			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetAccountsSummary), new[] { typeof(string) }));
			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetTotalsAccountsSummary), new[] { typeof(string) }));
			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetCardsPostingsPeople), new[] { typeof(int), typeof(string) }));
			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetBudgetTotals), new[] { typeof(string) }));
			modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetExpensesByCategories), new[] { typeof(string), typeof(int) }));
		}

		public IQueryable<AccountsDTO> GetAccountTotals(int accountId, string reference) => FromExpression(() => GetAccountTotals(accountId, reference));
		public IQueryable<AccountsSummary> GetAccountsSummary(string reference) => FromExpression(() => GetAccountsSummary(reference));
		public IQueryable<AccountsSummaryTotals> GetTotalsAccountsSummary(string reference) => FromExpression(() => GetTotalsAccountsSummary(reference));
		public IQueryable<CardsPostingsPeople> GetCardsPostingsPeople(int cardId, string reference) => FromExpression(() => GetCardsPostingsPeople(cardId, reference));
		public IQueryable<BudgetTotals> GetBudgetTotals(string reference) => FromExpression(() => GetBudgetTotals(reference));
		public IQueryable<ExpensesByCategories> GetExpensesByCategories(string reference, int cardId) => FromExpression(() => GetExpensesByCategories(reference, cardId));

		public DbSet<Accounts> Accounts { get; set; }
		public DbSet<Cards> Cards { get; set; }
		public DbSet<Users> Users { get; set; }
		public DbSet<AccountsPostings> AccountsPostings { get; set; }
		public DbSet<CardsPostings> CardsPostings { get; set; }
		public DbSet<Expenses> Expenses { get; set; }
		public DbSet<Incomes> Incomes { get; set; }
		public DbSet<People> People { get; set; }
		public DbSet<BudgetAPI.Models.CardsReceipts> CardsReceipts { get; set; }
		public DbSet<BudgetAPI.Models.Categories> Categories { get; set; }

	}
}

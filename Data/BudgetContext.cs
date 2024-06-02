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
            modelBuilder.Entity<ExpensesDTO>().ToTable("GetMyExpenses").HasNoKey();

            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetAccountTotals), new[] { typeof(int), typeof(string), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetAccountsSummary), new[] { typeof(string), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetTotalsAccountsSummary), new[] { typeof(string), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetCardsPostingsPeople), new[] { typeof(int), typeof(string), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetBudgetTotals), new[] { typeof(string), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetExpensesByCategories), new[] { typeof(string), typeof(int), typeof(int) }));
            modelBuilder.HasDbFunction(typeof(BudgetContext).GetMethod(nameof(GetMyExpenses), new[] { typeof(string), typeof(int) }));
        }

        public IQueryable<AccountsDTO> GetAccountTotals(int accountId, string reference, int userId) => FromExpression(() => GetAccountTotals(accountId, reference, userId));
        public IQueryable<AccountsSummary> GetAccountsSummary(string reference, int userId) => FromExpression(() => GetAccountsSummary(reference, userId));
        public IQueryable<AccountsSummaryTotals> GetTotalsAccountsSummary(string reference, int userId) => FromExpression(() => GetTotalsAccountsSummary(reference, userId));
        public IQueryable<CardsPostingsPeople> GetCardsPostingsPeople(int cardId, string reference, int userId) => FromExpression(() => GetCardsPostingsPeople(cardId, reference, userId));
        public IQueryable<BudgetTotals> GetBudgetTotals(string reference, int userId) => FromExpression(() => GetBudgetTotals(reference, userId));
        public IQueryable<ExpensesByCategories> GetExpensesByCategories(string reference, int cardId, int userId) => FromExpression(() => GetExpensesByCategories(reference, cardId, userId));
        public IQueryable<ExpensesDTO> GetMyExpenses(string reference, int userId) => FromExpression(() => GetMyExpenses(reference, userId));

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
        public DbSet<CardsInvoiceDate> CardsInvoiceDate { get; set; }

    }
}

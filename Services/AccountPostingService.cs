using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface IAccountPostingService
	{
		IQueryable<AccountsPostings> GetAccountsPostings();
		IQueryable<AccountsPostings> GetAccountsPostings(int id);
		IQueryable<AccountsPostings> GetAccountsPostings(int accountId, string reference);
		Task<int> PutAccountsPostings(AccountsPostings accountPosting);
		Task<int> PostAccountsPostings(AccountsPostings accountsPostings);
		Task<int> DeleteAccountsPostings(AccountsPostings accountsPostings);
		Task<int> SetPositions(List<AccountsPostings> accountsPostings);
		bool ValidarUsuario(int accountPostingId);
		bool AccountsPostingsExists(int id);
		bool ValidateAccountAndUser(int accountId);

	}
	public class AccountPostingService : IAccountPostingService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public AccountPostingService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<AccountsPostings> GetAccountsPostings()
		{
			return _context.AccountsPostings.Include(a => a.Account)
											.Where(a => a.Account!.UserId == _user.Id)
											.OrderBy(a => a.Position);
		}

		public IQueryable<AccountsPostings> GetAccountsPostings(int id)
		{
			IQueryable<AccountsPostings>? accountsPostings = _context.AccountsPostings.Include(a => a.Account)
																					  .Where(a => a.Id == id && a.Account!.UserId == _user.Id);

			return accountsPostings;
		}

		public IQueryable<AccountsPostings> GetAccountsPostings(int accountId, string reference)
		{
			IOrderedQueryable<AccountsPostings>? accountsPostings = _context.AccountsPostings.Include(a => a.Account)
																							 .Where(a => a.AccountId == accountId && a.Reference == reference && a.Account!.UserId == _user.Id)
																							 .OrderBy(a => a.Position); ;

			return accountsPostings;
		}

		public Task<int> PutAccountsPostings(AccountsPostings accountsPostings)
		{
			_context.Entry(accountsPostings).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public Task<int> PostAccountsPostings(AccountsPostings accountsPostings)
		{
			accountsPostings.Position = (short)((_context.AccountsPostings.Where(o => o.Reference == accountsPostings.Reference).Max(o => o.Position) ?? 0) + 1);

			_context.AccountsPostings.Add(accountsPostings);

			if (accountsPostings.ExpenseId != null && accountsPostings.Type == "P")
			{
				var expense = _context.Expenses.Find(accountsPostings.ExpenseId);

				if (expense != null)
				{
					expense.Scheduled = false;
				}
			}

			return _context.SaveChangesAsync();
		}

		public Task<int> DeleteAccountsPostings(AccountsPostings accountsPostings)
		{
			_context.AccountsPostings.Remove(accountsPostings);

			return _context.SaveChangesAsync();
		}

		public Task<int> SetPositions(List<AccountsPostings> accountsPostings)
		{
			foreach (AccountsPostings accountPosting in accountsPostings)
			{
				_context.Entry(accountPosting).State = EntityState.Modified;
			}

			return _context.SaveChangesAsync();
		}

		public bool ValidarUsuario(int accountPostingId)
		{
			return GetAccountsPostings(accountPostingId).Any();
		}

		public bool AccountsPostingsExists(int id)
		{
			return GetAccountsPostings(id).Any();
		}

		public bool ValidateAccountAndUser(int accountId)
		{
			return _context.Accounts.Where(a => a.Id == accountId && a.UserId == _user.Id).Any();
		}
	}
}

using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface IAccountService
	{
		IQueryable<Accounts> GetAccount();
		IQueryable<Accounts> GetAccount(int id);
		IQueryable<AccountsDTO> GetAccountTotals(int account, string reference);
		IQueryable<AccountsSummary> GetAccountsSummary(string reference);
		IQueryable<AccountsSummaryTotals> GetAccountsSummaryTotals(string reference);
		Task<int> PutAccount(int id, Accounts account);
		Task<int> PostAccount(Accounts account);
		Task<int> DeleteAccount(Accounts account);
		bool AccountExists(int id);
		bool ValidarUsuario(int id);
	}

	public class AccountService : IAccountService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public AccountService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<Accounts> GetAccount()
		{
			IQueryable<Accounts> query = _context.Accounts.Where(a => a.UserId == _user.Id);

			return query;
		}

		public IQueryable<AccountsDTO> GetAccountTotals(int accountId, string reference)
		{
			IQueryable<AccountsDTO> accountDto = Enumerable.Empty<AccountsDTO>().AsQueryable();

			try
			{
				accountDto = _context.GetAccountTotals(accountId, reference, _user.Id);
			}
			catch { /**/ }

			return accountDto;
		}

		public IQueryable<AccountsSummary> GetAccountsSummary(string reference)
		{
			IQueryable<AccountsSummary> query = Enumerable.Empty<AccountsSummary>().AsQueryable();

			try
			{
				query = _context.GetAccountsSummary(reference, _user.Id);
			}
			catch {/**/}

			return query;
		}

		public IQueryable<AccountsSummaryTotals> GetAccountsSummaryTotals(string reference)
		{
			IQueryable<AccountsSummaryTotals> accountsSummaryTotals = Enumerable.Empty<AccountsSummaryTotals>().AsQueryable();

			try
			{
				accountsSummaryTotals = _context.GetTotalsAccountsSummary(reference, _user.Id);
			}
			catch { /**/ }

			return accountsSummaryTotals;
		}

		public IQueryable<Accounts> GetAccount(int id)
		{
			var accounts = _context.Accounts.Where(a => a.UserId == _user!.Id && a.Id == id);

			return accounts;
		}

		public Task<int> PutAccount(int id, Accounts account)
		{
			_context.Entry(account).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public async Task<int> PostAccount(Accounts account)
		{
			account.UserId = _user.Id;

			_context.Accounts.Add(account);

			return await _context.SaveChangesAsync();
		}

		public async Task<int> DeleteAccount(Accounts account)
		{
			_context.Accounts.Remove(account);

			return await _context.SaveChangesAsync();
		}

		public bool AccountExists(int id)
		{
			return _context.Accounts.Any(e => e.Id == id);
		}

		public bool ValidarUsuario(int id)
		{
			return id == _user.Id;
		}
	}
}

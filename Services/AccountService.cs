using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
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
	}
}

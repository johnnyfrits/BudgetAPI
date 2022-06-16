using BudgetAPI.Data;
using BudgetAPI.Models;

namespace BudgetAPI.Services
{
	public interface IBudgetService
	{
		IQueryable<BudgetTotals> GetAccountsSummary(string reference);
	}
	public class BudgetService : IBudgetService
	{
		private readonly BudgetContext _context;
		private readonly Users _user;

		public BudgetService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();

		}

		public IQueryable<BudgetTotals> GetAccountsSummary(string reference)
		{
			IQueryable<BudgetTotals> query = _context.GetBudgetTotals(reference, _user.Id);

			return query;
		}
	}
}

using BudgetAPI.Authorization;
using BudgetAPI.Models;
using BudgetAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Authorize]
	[Route("api/[controller]")]
	[ApiController]
	public class BudgetController : ControllerBase
	{
		private readonly IBudgetService _budgetService;

		public BudgetController(IBudgetService budgetService)
		{
			_budgetService = budgetService;
		}

		[HttpGet("Totals")]
		public async Task<ActionResult<BudgetTotals?>> GetAccountsSummary(string reference)
		{
			return await _budgetService.GetAccountsSummary(reference).FirstOrDefaultAsync();
		}
	}
}

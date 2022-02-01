using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class BudgetController : ControllerBase
	{
		private readonly BudgetContext _context;

		public BudgetController(BudgetContext context)
		{
			_context = context;
		}

		[HttpGet("Totals")]
		public async Task<ActionResult<BudgetTotals?>> GetAccountsSummary(string reference)
		{
			return await _context.GetBudgetTotals(reference).FirstOrDefaultAsync();
		}
	}
}

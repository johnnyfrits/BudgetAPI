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
	public class ExpensesController : ControllerBase
	{
		private readonly IExpenseService _expenseService;

		public ExpensesController(IExpenseService expenseService)
		{
			_expenseService = expenseService;
		}

		// GET: api/Expenses
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Expenses>>> GetExpenses()
		{
			return await _expenseService.GetExpenses().ToListAsync();
		}

		// GET: api/Expenses/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Expenses>> GetExpenses(int id)
		{
			Expenses? expenses = await _expenseService.GetExpenses(id).FirstOrDefaultAsync();

			if (expenses == null)
			{
				return NotFound();
			}

			return expenses;
		}

		[HttpGet("reference/{reference}")]
		public async Task<ActionResult<IEnumerable<ExpensesDTO>>> GetExpensesByReference(string reference)
		{
			List<ExpensesDTO>? expenses = await _expenseService.GetExpensesByReference(reference).ToListAsync();

			return expenses;
		}

		[HttpGet("combolist/{reference}")]
		public async Task<ActionResult<IEnumerable<ExpensesDTO2>>> GetExpensesComboList(string reference)
		{
			List<ExpensesDTO2>? expenses = await _expenseService.GetExpensesComboList(reference).ToListAsync();

			return expenses;
		}

		[HttpGet("Categories")]
		public async Task<ActionResult<IEnumerable<ExpensesByCategories>>> GetExpensesByCategories(string reference, int cardId)
		{
			List<ExpensesByCategories>? expensesByCategories = await _expenseService.GetExpensesByCategories(reference, cardId).ToListAsync();

			return expensesByCategories;
		}

		[HttpGet("CategoriesById")]
		//public ActionResult<ExpensesByCategories?> GetExpensesByCategoryId([FromQuery] ExpensesByCategories expensesByCategory)
		public async Task<ActionResult<ExpensesByCategories?>> GetExpensesAndCardPostingsByCategoryId(int? id, string reference, int cardId)
		{
			ExpensesByCategories? expensesByCategory = await Task.Run(() =>
			{
				return _expenseService.GetExpensesAndCardPostingsByCategoryId(id, reference, cardId);
			});


			return expensesByCategory;
		}

		// PUT: api/Expenses/5
		[HttpPut("{id}")]
		public async Task<IActionResult> PutExpenses(int id, Expenses expense)
		{
			if (id != expense.Id || !_expenseService.ValidarUsuario(id))
			{
				return BadRequest();
			}

			try
			{
				await _expenseService.PutExpenses(expense);
			}
			catch (DbUpdateConcurrencyException dex)
			{
				if (!_expenseService.ExpensesExists(id))
				{
					return NotFound();
				}

				return Problem(dex.Message);
			}
			catch (Exception ex)
			{
				return Problem(ex.Message);
			}

			return Ok();
		}

		[HttpPut("AllParcels/{id}")]
		public async Task<ActionResult<Expenses>> PutExpensesWithParcels(int id, Expenses expenses, bool repeat, int qtyMonths)
		{
			try
			{
				if (id != expenses.Id || !_expenseService.ValidarUsuario(id))
				{
					return BadRequest();
				}

				await Task.Run(() =>
				{
					_expenseService.PutExpensesWithParcels(expenses, repeat, qtyMonths);
				});

				return Ok();
			}
			catch (Exception ex)
			{
				return Problem(ex.Message);
			}
		}

		[HttpPut("SetPositions")]
		public async Task<ActionResult<Expenses>> SetPositions(List<Expenses> expenses)
		{
			await _expenseService.SetPositions(expenses);

			return Ok();
		}

		[HttpPut("AddValue/{id}")]
		public async Task<ActionResult<Expenses>> AddValue(int id, decimal value)
		{
			var expense = await _expenseService.GetExpenses(id).FirstOrDefaultAsync();

			if (expense == null)
			{
				return NotFound();
			}

			await _expenseService.AddValue(expense, value);

			return Ok();
		}

		// POST: api/Expenses
		[HttpPost]
		public async Task<ActionResult<Expenses>> PostExpenses(Expenses expense)
		{
			try
			{
				await _expenseService.PostExpenses(expense);

				return await GetExpenses(expense.Id);
			}
			catch (Exception ex)
			{
				return Problem(ex.ToString() + "\n\n" + ex.InnerException?.Message);
			}
		}

		[HttpPost("AllParcels")]
		public async Task<ActionResult<Expenses>> PostExpensesWithParcels(Expenses expense, bool repeat, int qtyMonths)
		{
			try
			{
				await Task.Run(() =>
				{
					_expenseService.PostExpensesWithParcels(expense, repeat, qtyMonths);
				});

				return await GetExpenses(expense.Id);
			}
			catch (Exception ex)
			{
				return Problem(ex.ToString() + "\n\n" + ex.InnerException?.Message);
			}
		}

		// DELETE: api/Expenses/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteExpenses(int id)
		{
			Expenses? expense = await _expenseService.GetExpenses(id).FirstOrDefaultAsync();

			if (expense == null)
			{
				return NotFound();
			}

			if (!_expenseService.ValidarUsuario(id))
			{
				return BadRequest();
			}

			await _expenseService.DeleteExpenses(expense);

			return Ok();
		}
	}
}

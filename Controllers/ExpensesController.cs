using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class ExpensesController : ControllerBase
	{
		private readonly BudgetContext _context;

		public ExpensesController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/Expenses
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Expenses>>> GetExpenses()
		{
			return await _context.Expenses.OrderBy(e => e.Position).ToListAsync();
		}

		// GET: api/Expenses/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Expenses>> GetExpenses(int id)
		{
			var expenses = await _context.Expenses.FindAsync(id);

			if (expenses == null)
			{
				return NotFound();
			}

			return expenses;
		}

		[HttpGet("reference/{reference}")]
		public async Task<ActionResult<IEnumerable<ExpensesDTO>>> GetExpensesByReference(string reference)
		{
			var expenses = await _context.Expenses.Where(o => o.Reference == reference)
												  .OrderBy(o => o.Position)
												  .Select(o => ExpensesToDTO(o))
												  .ToListAsync();

			return expenses;
		}

		// PUT: api/Expenses/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutExpenses(int id, Expenses expenses)
		{
			if (id != expenses.Id)
			{
				return BadRequest();
			}

			_context.Entry(expenses).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!ExpensesExists(id))
				{
					return NotFound();
				}
				else
				{
					throw;
				}
			}

			return NoContent();
		}


		// POST: api/Expenses
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<Expenses>> PostExpenses(Expenses expenses)
		{
			_context.Expenses.Add(expenses);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetExpenses", new { id = expenses.Id }, expenses);
		}

		// DELETE: api/Expenses/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteExpenses(int id)
		{
			var expenses = await _context.Expenses.FindAsync(id);
			if (expenses == null)
			{
				return NotFound();
			}

			_context.Expenses.Remove(expenses);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool ExpensesExists(int id)
		{
			return _context.Expenses.Any(e => e.Id == id);
		}

		private static ExpensesDTO ExpensesToDTO(Expenses expense) =>
			new ExpensesDTO
			{
				Id = expense.Id,
				UserId = expense.UserId,
				Reference = expense.Reference,
				Position = expense.Position,
				Description = expense.Description,
				ToPay = expense.ToPay,
				Paid = expense.Paid,
				Remaining = expense.ToPay - expense.Paid,
				Note = expense.Note,
				CardId = expense.CardId,
				AccountId = expense.AccountId
			};
	}
}

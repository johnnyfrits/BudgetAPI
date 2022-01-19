using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class IncomesController : ControllerBase
	{
		private readonly BudgetContext _context;

		public IncomesController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/Incomes
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Incomes>>> GetIncomes()
		{
			return await _context.Incomes.OrderBy(o => o.Position).ToListAsync();
		}

		// GET: api/Incomes/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Incomes>> GetIncomes(int id)
		{
			var incomes = await _context.Incomes.FindAsync(id);

			if (incomes == null)
			{
				return NotFound();
			}

			return incomes;
		}

		[HttpGet("reference/{reference}")]
		public async Task<ActionResult<IEnumerable<IncomesDTO>>> GetIncomes(string reference)
		{
			var incomes = await _context.Incomes.Where(o => o.Reference == reference)
												.OrderBy(o => o.Position)
												.Select(o => IncomesToDTO(o))
												.ToListAsync();

			return incomes;
		}

		// PUT: api/Incomes/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutIncomes(int id, Incomes incomes)
		{
			if (id != incomes.Id)
			{
				return BadRequest();
			}

			_context.Entry(incomes).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!IncomesExists(id))
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

		[HttpPut("SetPositions")]
		public async Task<ActionResult<Incomes>> SetPositions(List<Incomes> incomes)
		{
			foreach (Incomes income in incomes)
			{
				_context.Entry(income).State = EntityState.Modified;
			}

			await _context.SaveChangesAsync();

			return Ok();
		}

		// POST: api/Incomes
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<Incomes>> PostIncomes(Incomes incomes)
		{
			_context.Incomes.Add(incomes);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetIncomes", new { id = incomes.Id }, incomes);
		}

		// DELETE: api/Incomes/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteIncomes(int id)
		{
			var incomes = await _context.Incomes.FindAsync(id);
			if (incomes == null)
			{
				return NotFound();
			}

			_context.Incomes.Remove(incomes);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool IncomesExists(int id)
		{
			return _context.Incomes.Any(e => e.Id == id);
		}

		private static IncomesDTO IncomesToDTO(Incomes income) =>
			new IncomesDTO
			{
				Id          = income.Id,
				UserId      = income.UserId,
				Reference   = income.Reference,
				Position    = income.Position,
				Description = income.Description,
				ToReceive   = income.ToReceive,
				Received    = income.Received,
				Remaining   = income.ToReceive - income.Received,
				Note        = income.Note,
				CardId      = income.CardId,
				AccountId   = income.AccountId
			};
	}
}

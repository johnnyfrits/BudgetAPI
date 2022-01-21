using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class CardsReceiptsController : ControllerBase
	{
		private readonly BudgetContext _context;

		public CardsReceiptsController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/CardsReceipts
		[HttpGet]
		public async Task<ActionResult<IEnumerable<CardsReceipts>>> GetCardsReceipts()
		{
			return await _context.CardsReceipts.ToListAsync();
		}

		// GET: api/CardsReceipts/5
		[HttpGet("{id}")]
		public async Task<ActionResult<CardsReceipts>> GetCardsReceipts(int id)
		{
			var cardsReceipts = await _context.CardsReceipts.FindAsync(id);

			if (cardsReceipts == null)
			{
				return NotFound();
			}

			return cardsReceipts;
		}

		// PUT: api/CardsReceipts/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutCardsReceipts(int id, CardsReceipts cardsReceipts)
		{
			if (id != cardsReceipts.Id)
			{
				return BadRequest();
			}

			_context.Entry(cardsReceipts).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!CardsReceiptsExists(id))
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

		// POST: api/CardsReceipts
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<CardsReceipts>> PostCardsReceipts(CardsReceipts cardsReceipts)
		{
			_context.CardsReceipts.Add(cardsReceipts);

			await _context.SaveChangesAsync();

			return CreatedAtAction("GetCardsReceipts", new { id = cardsReceipts.Id }, cardsReceipts);
		}

		// DELETE: api/CardsReceipts/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteCardsReceipts(int id)
		{
			var cardsReceipts = await _context.CardsReceipts.FindAsync(id);
			if (cardsReceipts == null)
			{
				return NotFound();
			}

			_context.CardsReceipts.Remove(cardsReceipts);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool CardsReceiptsExists(int id)
		{
			return _context.CardsReceipts.Any(e => e.Id == id);
		}
	}
}

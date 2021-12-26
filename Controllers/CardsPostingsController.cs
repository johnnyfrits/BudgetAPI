using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class CardsPostingsController : ControllerBase
	{
		private readonly BudgetContext _context;

		public CardsPostingsController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/CardsPostings
		[HttpGet]
		public async Task<ActionResult<IEnumerable<CardsPostings>>> GetCardsPostings()
		{
			return await _context.CardsPostings.ToListAsync();
		}

		// GET: api/CardsPostings/5
		[HttpGet("{id}")]
		public async Task<ActionResult<CardsPostings>> GetCardsPostings(int id)
		{
			var cardsPostings = await _context.CardsPostings.FindAsync(id);

			if (cardsPostings == null)
			{
				return NotFound();
			}

			return cardsPostings;
		}

		[HttpGet("{cardId}/{reference}")]
		public async Task<ActionResult<IEnumerable<CardsPostings>>> GetCardsPostings(int cardId, string reference)
		{
			var cardsPostings = await _context.CardsPostings.Include(o => o.People)
															.Where(o => o.CardId == cardId && o.Reference == reference)
															.ToListAsync();

			return cardsPostings;
		}

		// PUT: api/CardsPostings/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutCardsPostings(int id, CardsPostings cardsPostings)
		{
			if (id != cardsPostings.Id)
			{
				return BadRequest();
			}

			_context.Entry(cardsPostings).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!CardsPostingsExists(id))
				{
					return NotFound();
				}
				else
				{
					throw;
				}
			}

			return Ok();
		}

		// POST: api/CardsPostings
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<CardsPostings>> PostCardsPostings(CardsPostings cardsPostings)
		{
			_context.CardsPostings.Add(cardsPostings);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetCardsPostings", new { id = cardsPostings.Id }, cardsPostings);
		}

		// DELETE: api/CardsPostings/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteCardsPostings(int id)
		{
			var cardsPostings = await _context.CardsPostings.FindAsync(id);
			if (cardsPostings == null)
			{
				return NotFound();
			}

			_context.CardsPostings.Remove(cardsPostings);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool CardsPostingsExists(int id)
		{
			return _context.CardsPostings.Any(e => e.Id == id);
		}
	}
}

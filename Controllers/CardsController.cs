using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class CardsController : ControllerBase
	{
		private readonly BudgetContext _context;

		public CardsController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/Card
		[HttpGet]
		public async Task<ActionResult<IEnumerable<CardsDTO>>> GetCard()
		{
			return await _context.Cards.Include(u => u.User)
									   .Select(c => CardToDTO(c))
									   .ToListAsync();
		}

		// GET: api/Card/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Cards>> GetCard(int id)
		{
			var card = await _context.Cards.FindAsync(id);

			if (card == null)
			{
				return NotFound();
			}

			return card;
		}

		// PUT: api/Card/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutCard(int id, Cards card)
		{
			if (id != card.Id)
			{
				return BadRequest();
			}

			_context.Entry(card).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!CardExists(id))
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

		// POST: api/Card
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<Cards>> PostCard(Cards card)
		{
			_context.Cards.Add(card);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetCard", new { id = card.Id }, card);
		}

		// DELETE: api/Card/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteCard(int id)
		{
			var card = await _context.Cards.FindAsync(id);
			if (card == null)
			{
				return NotFound();
			}

			_context.Cards.Remove(card);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool CardExists(int id)
		{
			return _context.Cards.Any(e => e.Id == id);
		}

		private static CardsDTO CardToDTO(Cards card) => 
			new CardsDTO {
				Id         = card.Id,
				UserId     = card.UserId,
				Name       = card.Name,
				Color      = card.Color,
				Background = card.Background,
				//User       = UsersControllerOld.UserToDTO(card.User),
				Disabled   = card.Disabled
			};
	}
}

using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class PeopleController : ControllerBase
	{
		private readonly BudgetContext _context;

		public PeopleController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/People
		[HttpGet]
		public async Task<ActionResult<IEnumerable<People>>> GetPeople()
		{
			return await _context.People.ToListAsync();
		}

		// GET: api/People/5
		[HttpGet("{id}")]
		public async Task<ActionResult<People>> GetPeople(string id)
		{
			var people = await _context.People.FindAsync(id);

			if (people == null)
			{
				return NotFound();
			}

			return people;
		}

		// PUT: api/People/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutPeople(string id, People people)
		{
			if (id != people.Id)
			{
				return BadRequest();
			}

			_context.Entry(people).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!PeopleExists(id))
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

		// POST: api/People
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<People>> PostPeople(People people)
		{
			_context.People.Add(people);
			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateException)
			{
				if (PeopleExists(people.Id))
				{
					return Conflict();
				}
				else
				{
					throw;
				}
			}

			return CreatedAtAction("GetPeople", new { id = people.Id }, people);
		}

		// DELETE: api/People/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeletePeople(string id)
		{
			var people = await _context.People.FindAsync(id);
			if (people == null)
			{
				return NotFound();
			}

			_context.People.Remove(people);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool PeopleExists(string id)
		{
			return _context.People.Any(e => e.Id == id);
		}
	}
}

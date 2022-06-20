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
	public class PeopleController : ControllerBase
	{
		private readonly IPeopleService _peopleService;

		public PeopleController(IPeopleService peopleService)
		{
			_peopleService = peopleService;
		}

		// GET: api/People
		[HttpGet]
		public async Task<ActionResult<IEnumerable<People>>> GetPeople()
		{
			return await _peopleService.GetPeople().ToListAsync();
		}

		// GET: api/People/5
		[HttpGet("{id}")]
		public async Task<ActionResult<People>> GetPeople(string id)
		{
			People? people = await _peopleService.GetPeople(id).FirstOrDefaultAsync();

			if (people == null)
			{
				return NotFound();
			}

			return people;
		}

		// PUT: api/People/5
		[HttpPut("{id}")]
		public async Task<IActionResult> PutPeople(string id, People people)
		{
			if (!_peopleService.ValidarUsuario(people.UserId))
			{
				return BadRequest();
			}

			try
			{
				await _peopleService.PutPeople(id, people);
			}
			catch (DbUpdateConcurrencyException dex)
			{
				if (!_peopleService.PeopleExists(id))
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

		// POST: api/People
		[HttpPost]
		public async Task<ActionResult<People>> PostPeople(People people)
		{
			await _peopleService.PostPeople(people);

			return CreatedAtAction("GetPeople", new { id = people.Id }, people);
		}

		// DELETE: api/People/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeletePeople(string id)
		{
			People? people = await _peopleService.GetPeople(id).FirstOrDefaultAsync();

			if (people == null)
			{
				return NotFound();
			}

			if (!_peopleService.ValidarUsuario(people.UserId))
			{
				return BadRequest();
			}

			await _peopleService.DeletePeople(people);

			return Ok();
		}
	}
}

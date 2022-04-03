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

		[HttpPut("Repeat/{id}")]
		public async Task<ActionResult<Incomes>> PutIncomesWithParcels(int id, Incomes incomes, int qtyMonths)
		{
			//using (var transaction = _context.Database.BeginTransaction())
			{
				try
				{
					if (id != incomes.Id)
					{
						return BadRequest();
					}

					_context.Entry(incomes).State = EntityState.Modified;

					var incomesList = RepeatIncomes(incomes, qtyMonths);

					foreach (Incomes cp in incomesList.Skip(1))
					{
						_context.Incomes.Add(cp);

						await _context.SaveChangesAsync();
					}

					//transaction.Commit();

					return Ok();
				}
				catch (Exception ex)
				{
					//transaction.Rollback();

					return Problem(ex.Message);
				}
			}
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

		[HttpPost("Repeat")]
		public async Task<ActionResult<Incomes>> PostIncomesWithParcels(Incomes incomes, int qtyMonths)
		{
			//using (var transaction = _context.Database.BeginTransaction())
			{
				try
				{
					var incomesList = RepeatIncomes(incomes, qtyMonths);

					var i = 1;

					foreach (Incomes cp in incomesList)
					{
						_context.Incomes.Add(cp);

						await _context.SaveChangesAsync();

						if (i++ == 1)
						{
							incomes.Id = cp.Id;
						}
					}

					//transaction.Commit();

					return await GetIncomes(incomes.Id);

				}
				catch (Exception ex)
				{
					//transaction.Rollback();

					return Problem(ex.Message);
				}
			}
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
				AccountId   = income.AccountId,
				Type        = income.Type,
				PeopleId    = income.PeopleId
			};

		private static string GetNewReference(string reference)
		{
			var year  = int.Parse(reference.Substring(0, 4));
			var month = int.Parse(reference.Substring(4, 2));

			var date = new DateTime(year, month, 1).AddMonths(1);

			var newReference = date.ToString("yyyyMM");

			return newReference;
		}

		private short GetNewPosition(string reference)
		{
			var newPosition = _context.Incomes.Where(e => e.Reference == reference).Max(e => e.Position) ?? 0;

			return ++newPosition;
		}

		private List<Incomes> RepeatIncomes(Incomes income, int qtyMonths)
		{
			var incomesList = new List<Incomes>();

			var reference = income.Reference;

			for (int i = 1; i <= (qtyMonths + 1); i++)
			{
				var e = new Incomes
				{
					UserId       = income.UserId,
					Reference    = reference,
					Position     = income.Id > 0 && i == 1 ? income.Position : GetNewPosition(reference),
					Description  = income.Description,
					ToReceive    = income.ToReceive,
					Received     = income.Received,
					Note         = income.Note,
					CardId       = income.CardId,
					AccountId    = income.AccountId,
					Type         = income.Type,
					PeopleId     = income.PeopleId
				};

				incomesList.Add(e);

				reference = GetNewReference(reference);
			}

			return incomesList;
		}
	}
}

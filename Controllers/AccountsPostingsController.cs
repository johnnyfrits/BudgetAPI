using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AccountsPostingsController : ControllerBase
	{
		private readonly BudgetContext _context;

		public AccountsPostingsController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/AccountsPostings
		[HttpGet]
		public async Task<ActionResult<IEnumerable<AccountsPostings>>> GetAccountsPostings()
		{
			return await _context.AccountsPostings.OrderBy(o => o.Position).ToListAsync();
		}

		// GET: api/AccountsPostings/5
		[HttpGet("{id}")]
		public async Task<ActionResult<AccountsPostings>> GetAccountsPostings(int id)
		{
			var accountsPostings = await _context.AccountsPostings.FindAsync(id);

			if (accountsPostings == null)
			{
				return NotFound();
			}

			return accountsPostings;
		}

		[HttpGet("{accountId}/{reference}")]
		public async Task<ActionResult<IEnumerable<AccountsPostings>>> GetAccountsPostings(int accountId, string reference)
		{
			var accountsPostings = await _context.AccountsPostings.Where(o => o.AccountId == accountId && o.Reference == reference)
																  .OrderBy(o => o.Position)
																  .ToListAsync();

			return accountsPostings;
		}

		// PUT: api/AccountsPostings/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutAccountsPostings(int id, AccountsPostings accountsPostings)
		{
			if (id != accountsPostings.Id)
			{
				return BadRequest();
			}

			_context.Entry(accountsPostings).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!AccountsPostingsExists(id))
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

		// POST: api/AccountsPostings
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<AccountsPostings>> PostAccountsPostings(AccountsPostings accountsPostings)
		{
			accountsPostings.Position = (short)((_context.AccountsPostings.Max( o => o.Position) ?? 0) + 1);

			_context.AccountsPostings.Add(accountsPostings);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetAccountsPostings", new { id = accountsPostings.Id }, accountsPostings);
		}

		[HttpPut("SetPositions")]
		public async Task<ActionResult<AccountsPostings>> SetPositions(List<AccountsPostings> accountsPostings)
		{
			foreach (AccountsPostings accountPosting in accountsPostings)
			{
				_context.Entry(accountPosting).State = EntityState.Modified;
			}

			await _context.SaveChangesAsync();

			return Ok();
		}


		// DELETE: api/AccountsPostings/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteAccountsPostings(int id)
		{
			var accountsPostings = await _context.AccountsPostings.FindAsync(id);
			if (accountsPostings == null)
			{
				return NotFound();
			}

			_context.AccountsPostings.Remove(accountsPostings);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool AccountsPostingsExists(int id)
		{
			return _context.AccountsPostings.Any(e => e.Id == id);
		}
	}
}

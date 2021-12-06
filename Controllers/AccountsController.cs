using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BudgetAPI.Data;
using BudgetAPI.Models;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AccountsController : ControllerBase
	{
		private readonly BudgetContext _context;

		public AccountsController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/Accounts
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Accounts>>> GetAccount()
		{
			return await _context.Accounts.ToListAsync();
		}

		// GET: api/Accounts/Totals
		//[HttpGet("{account}/{reference}")]
		[HttpGet("Totals")]
		public async Task<ActionResult<AccountsDTO>> GetAccountTotals(int account, string reference)
		{
			var accountDto = new AccountsDTO();

			try
			{
				accountDto = await _context.GetAccountTotals(account, reference).FirstAsync();
			}
			catch { /**/ }

			return accountDto;
		}
		//public string GetAccountTotals(int account, string reference)
		//{
		//    return $"Conta:{account} | Referencia: {reference}";
		//}

		// GET: api/Accounts/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Accounts>> GetAccount(int id)
		{
			var accounts = await _context.Accounts.FindAsync(id);

			if (accounts == null)
			{
				return NotFound();
			}

			return accounts;
		}

		// PUT: api/Accounts/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutAccount(int id, Accounts accounts)
		{
			if (id != accounts.Id)
			{
				return BadRequest();
			}

			_context.Entry(accounts).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!AccountExists(id))
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

		// POST: api/Accounts
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<Accounts>> PostAccount(Accounts accounts)
		{
			_context.Accounts.Add(accounts);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetAccount", new { id = accounts.Id }, accounts);
		}

		// DELETE: api/Accounts/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteAccount(int id)
		{
			var accounts = await _context.Accounts.FindAsync(id);
			if (accounts == null)
			{
				return NotFound();
			}

			_context.Accounts.Remove(accounts);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool AccountExists(int id)
		{
			return _context.Accounts.Any(e => e.Id == id);
		}


	}
}

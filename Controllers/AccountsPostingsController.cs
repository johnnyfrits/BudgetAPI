using BudgetAPI.Authorization;
using BudgetAPI.Data;
using BudgetAPI.Models;
using BudgetAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Authorize]
	[Route("api/[controller]")]
	[ApiController]
	public class AccountsPostingsController : ControllerBase
	{
		private readonly IAccountPostingService _accountPostingService;

		public AccountsPostingsController(IAccountPostingService accountPostingService)
		{
			_accountPostingService = accountPostingService;
		}

		// GET: api/AccountsPostings
		[HttpGet]
		public async Task<ActionResult<IEnumerable<AccountsPostings>>> GetAccountsPostings()
		{
			return await _accountPostingService.GetAccountsPostings().ToListAsync();
		}

		// GET: api/AccountsPostings/5
		[HttpGet("{id}")]
		public async Task<ActionResult<AccountsPostings>> GetAccountsPostings(int id)
		{
			AccountsPostings? accountsPostings = await _accountPostingService.GetAccountsPostings(id).FirstOrDefaultAsync();

			if (accountsPostings == null)
			{
				return NotFound();
			}

			return accountsPostings;
		}

		[HttpGet("{accountId}/{reference}")]
		public async Task<ActionResult<IEnumerable<AccountsPostings>>> GetAccountsPostings(int accountId, string reference)
		{
			var accountsPostings = await _accountPostingService.GetAccountsPostings(accountId, reference).ToListAsync();

			return accountsPostings;
		}

		// PUT: api/AccountsPostings/5
		[HttpPut("{id}")]
		public async Task<IActionResult> PutAccountsPostings(int id, AccountsPostings accountsPostings)
		{
			if (id != accountsPostings.Id || !_accountPostingService.ValidarUsuario(id))
			{
				return BadRequest();
			}

			try
			{
				await _accountPostingService.PutAccountsPostings(id, accountsPostings);
			}
			catch (DbUpdateConcurrencyException e)
			{
				if (!_accountPostingService.AccountsPostingsExists(id))
				{
					return NotFound();
				}
				else
				{
					throw e;
				}
			}

			return NoContent();
		}

		// POST: api/AccountsPostings
		[HttpPost]
		public async Task<ActionResult<AccountsPostings>> PostAccountsPostings(AccountsPostings accountsPostings)
		{
			if (!_accountPostingService.ValidateAccountAndUser(accountsPostings.AccountId))
			{
				return BadRequest();
			}

			await _accountPostingService.PostAccountsPostings(accountsPostings);

			return CreatedAtAction("GetAccountsPostings", new { id = accountsPostings.Id }, accountsPostings);
		}

		// DELETE: api/AccountsPostings/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteAccountsPostings(int id)
		{
			AccountsPostings? accountsPostings = await _accountPostingService.GetAccountsPostings(id).FirstOrDefaultAsync();
			
			if (accountsPostings == null)
			{
				return NotFound();
			}

			await _accountPostingService.DeleteAccountsPostings(accountsPostings);

			return NoContent();
		}

		[HttpPut("SetPositions")]
		public async Task<ActionResult<AccountsPostings>> SetPositions(List<AccountsPostings> accountsPostings)
		{
			await _accountPostingService.SetPositions(accountsPostings);

			return Ok();
		}
	}
}

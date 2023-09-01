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
    public class AccountsController : ControllerBase
    {
        private readonly IAccountService _accountService;

        public AccountsController(IAccountService accountService)
        {
            _accountService = accountService;
        }

        [HttpGet("Totals")]
        public async Task<ActionResult<AccountsDTO>> GetAccountTotals(int account, string reference)
        {
            return await _accountService.GetAccountTotals(account, reference).FirstOrDefaultAsync() ?? new AccountsDTO();
        }

        [HttpGet("AccountsSummary")]
        public async Task<ActionResult<IEnumerable<AccountsSummary>>> GetAccountsSummary(string reference)
        {
            return await _accountService.GetAccountsSummary(reference).ToListAsync();
        }

        [HttpGet("SummaryTotals")]
        public async Task<ActionResult<AccountsSummaryTotals>> GetAccountsSummaryTotals(string reference)
        {
            return await _accountService.GetAccountsSummaryTotals(reference).FirstOrDefaultAsync() ?? new AccountsSummaryTotals();
        }

        // GET: api/Accounts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Accounts>>> GetAccount()
        {
            return await _accountService.GetAccount().ToListAsync();
        }

        // GET: api/Accounts/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Accounts>> GetAccount(int id)
        {
            Accounts? accounts = await _accountService.GetAccount(id).FirstOrDefaultAsync();

            if (accounts == null)
            {
                return NotFound();
            }

            return accounts;
        }

        // PUT: api/Accounts/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAccount(int id, Accounts account)
        {
            if (id != account.Id || !_accountService.ValidarUsuario(account.UserId))
            {
                return BadRequest();
            }

            try
            {
                await _accountService.PutAccount(account);
            }
            catch (DbUpdateConcurrencyException dex)
            {
                if (!_accountService.AccountExists(id))
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

        // POST: api/Accounts
        [HttpPost]
        public async Task<ActionResult<Accounts>> PostAccount(Accounts account)
        {
            await _accountService.PostAccount(account);

            return CreatedAtAction("GetAccount", new { id = account.Id }, account);
        }

        // DELETE: api/Accounts/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAccount(int id)
        {
            Accounts? account = await _accountService.GetAccount(id).FirstOrDefaultAsync();

            if (account == null)
            {
                return NotFound();
            }

            if (!_accountService.ValidarUsuario(account.UserId))
            {
                return BadRequest();
            }

            await _accountService.DeleteAccount(account);

            return Ok();
        }

        [HttpPut("SetPositions")]
        public async Task<ActionResult<Accounts>> SetPositions(List<Accounts> accounts)
        {
            await _accountService.SetPositions(accounts);

            return Ok();
        }
    }
}

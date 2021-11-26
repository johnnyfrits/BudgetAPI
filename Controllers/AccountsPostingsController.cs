﻿using System;
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
            return await _context.AccountsPostings.ToListAsync();
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
            _context.AccountsPostings.Add(accountsPostings);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAccountsPostings", new { id = accountsPostings.Id }, accountsPostings);
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
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
    public class YieldsController : ControllerBase
    {
        private readonly BudgetContext _context;

        public YieldsController(BudgetContext context)
        {
            _context = context;
        }

        // GET: api/Yields
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Yields>>> GetYields()
        {
            return await _context.Yields.ToListAsync();
        }

        // GET: api/Yields/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Yields>> GetYields(int id)
        {
            var yields = await _context.Yields.FindAsync(id);

            if (yields == null)
            {
                return NotFound();
            }

            return yields;
        }

        // PUT: api/Yields/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutYields(int id, Yields yields)
        {
            if (id != yields.Id)
            {
                return BadRequest();
            }

            _context.Entry(yields).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!YieldsExists(id))
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

        // POST: api/Yields
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Yields>> PostYields(Yields yields)
        {
            _context.Yields.Add(yields);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetYields", new { id = yields.Id }, yields);
        }

        // DELETE: api/Yields/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteYields(int id)
        {
            var yields = await _context.Yields.FindAsync(id);
            if (yields == null)
            {
                return NotFound();
            }

            _context.Yields.Remove(yields);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool YieldsExists(int id)
        {
            return _context.Yields.Any(e => e.Id == id);
        }
    }
}

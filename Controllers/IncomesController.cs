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
	public class IncomesController : ControllerBase
	{
		private readonly IIncomeService _incomeService;

		public IncomesController(IIncomeService incomeService)
		{
			_incomeService = incomeService;
		}

		// GET: api/Incomes
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Incomes>>> GetIncomes()
		{
			return await _incomeService.GetIncomes().ToListAsync();
		}

		// GET: api/Incomes/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Incomes>> GetIncomes(int id)
		{
			Incomes? incomes = await _incomeService.GetIncomes(id).FirstOrDefaultAsync();

			if (incomes == null)
			{
				return NotFound();
			}

			return incomes;
		}

		[HttpGet("reference/{reference}")]
		public async Task<ActionResult<IEnumerable<IncomesDTO>>> GetIncomes(string reference)
		{
			List<IncomesDTO>? incomes = await _incomeService.GetIncomes(reference).ToListAsync();

			return incomes;
		}

		[HttpGet("combolist/{reference}")]
		public async Task<ActionResult<IEnumerable<IncomesDTO2>>> GetIncomesComboList(string reference)
		{
			List<IncomesDTO2>? incomes = await _incomeService.GetIncomesComboList(reference).ToListAsync();

			return incomes;
		}

		// PUT: api/Incomes/5
		[HttpPut("{id}")]
		public async Task<IActionResult> PutIncomes(int id, Incomes income)
		{
			if (id != income.Id || !_incomeService.ValidarUsuario(id))
			{
				return BadRequest();
			}

			try
			{
				await _incomeService.PutIncomes(income);
			}
			catch (DbUpdateConcurrencyException dex)
			{
				if (!_incomeService.IncomesExists(id))
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

		[HttpPut("Repeat/{id}")]
		public async Task<ActionResult<Incomes>> PutIncomesWithParcels(int id, Incomes income, int qtyMonths)
		{
			try
			{
				if (id != income.Id || !_incomeService.ValidarUsuario(id))
				{
					return BadRequest();
				}

				await Task.Run(() =>
				{
					_incomeService.PutIncomesWithParcels(income, qtyMonths);
				});

				return Ok();
			}
			catch (Exception ex)
			{
				return Problem(ex.Message);
			}
		}


		[HttpPut("AddValue/{id}")]
		public async Task<ActionResult<Incomes>> AddValue(int id, decimal value)
		{
			var income = await _incomeService.GetIncomes(id).FirstOrDefaultAsync();

			if (income == null)
			{
				return NotFound();
			}

			await _incomeService.AddValue(income, value);

			return Ok();
		}

		[HttpPut("SetPositions")]
		public async Task<ActionResult<Incomes>> SetPositions(List<Incomes> incomes)
		{
			await _incomeService.SetPositions(incomes);

			return Ok();
		}

		// POST: api/Incomes
		[HttpPost]
		public async Task<ActionResult<Incomes>> PostIncomes(Incomes income)
		{
			try
			{
				await _incomeService.PostIncomes(income);

				return await GetIncomes(income.Id);
			}
			catch (Exception ex)
			{
				return Problem(ex.ToString() + "\n\n" + ex.InnerException?.Message);
			}
		}

		[HttpPost("Repeat")]
		public async Task<ActionResult<Incomes>> PostIncomesWithParcels(Incomes income, int qtyMonths)
		{
			try
			{
				await Task.Run(() =>
				{
					_incomeService.PostIncomesWithParcels(income, qtyMonths);
				});

				return await GetIncomes(income.Id);
			}
			catch (Exception ex)
			{
				return Problem(ex.ToString() + "\n\n" + ex.InnerException?.Message);
			}
		}

		// DELETE: api/Incomes/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteIncomes(int id)
		{
			Incomes? income = await _incomeService.GetIncomes(id).FirstOrDefaultAsync();

			if (income == null)
			{
				return NotFound();
			}

			if (!_incomeService.ValidarUsuario(id))
			{
				return BadRequest();
			}

			await _incomeService.DeleteIncomes(income);

			return Ok();
		}
	}
}

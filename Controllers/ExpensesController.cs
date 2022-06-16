using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class ExpensesController : ControllerBase
	{
		private readonly BudgetContext _context;

		public ExpensesController(BudgetContext context)
		{
			_context = context;
		}

		// GET: api/Expenses
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Expenses>>> GetExpenses()
		{
			return await _context.Expenses.OrderBy(e => e.Position).ToListAsync();
		}

		// GET: api/Expenses/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Expenses>> GetExpenses(int id)
		{
			var expenses = await _context.Expenses.FindAsync(id);

			if (expenses == null)
			{
				return NotFound();
			}

			return expenses;
		}

		[HttpGet("reference/{reference}")]
		public async Task<ActionResult<IEnumerable<ExpensesDTO>>> GetExpensesByReference(string reference)
		{
			var expenses = await _context.Expenses.Where(o => o.Reference == reference)
												  .OrderBy(o => o.Position)
												  .Select(o => ExpensesToDTO(o))
												  .ToListAsync();

			return expenses;
		}

		[HttpGet("combolist/{reference}")]
		public async Task<ActionResult<IEnumerable<ExpensesDTO2>>> GetExpensesComboList(string reference)
		{
			var expenses = await _context.Expenses.Where(o => o.Reference == reference)
												  .OrderBy(o => o.Position)
												  .Select(o => ExpensesToComboList(o))
												  .ToListAsync();

			return expenses;
		}

		[HttpGet("Categories")]
		public async Task<ActionResult<IEnumerable<ExpensesByCategories>>> GetExpensesByCategories(string reference, int cardId)
		{
			var expensesByCategories = await _context.GetExpensesByCategories(reference, cardId, 1).ToListAsync();

			//foreach(ExpensesByCategories ec in expensesByCategories)
			//{
			//	ec.Expenses = _context.Expenses.Where(e => e.CategoryId == ec.Id &&
			//											   e.Reference == reference);

			//	ec.CardsPostings = _context.CardsPostings.Include(o => o.Card)
			//											 .Where(cp => cp.CategoryId == ec.Id &&
			//														  cp.Reference == reference &&
			//														  (cardId == 0 || cp.CardId == cardId));

			//}

			return expensesByCategories;
		}

		[HttpGet("CategoriesById")]
		//public ActionResult<ExpensesByCategories?> GetExpensesByCategoryId([FromQuery] ExpensesByCategories expensesByCategory)
		public ActionResult<ExpensesByCategories?> GetExpensesAndCardPostingsByCategoryId(int? id, string reference, int cardId)
		{
			var expensesByCategory = new ExpensesByCategories
			{
				Id = id,
				Reference = reference,
				CardId = cardId
			};

			id = id == 0 ? null : id;

			expensesByCategory.Expenses = _context.Expenses.Where(e => e.CategoryId == id &&
																	   e.Reference == reference &&
																	   e.CardId == null).OrderBy(o => o.Position);

			expensesByCategory.CardsPostings = _context.CardsPostings.Include(o => o.Card)
																	 .Where(cp => cp.CategoryId == id &&
																				  cp.Reference == reference &&
																				  (cardId == 0 || cp.CardId == cardId) &&
																				  !cp.Others)
																	 .OrderBy(o => o.Date).ThenBy(o => o.Position);


			return expensesByCategory;
		}


		// PUT: api/Expenses/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
		public async Task<IActionResult> PutExpenses(int id, Expenses expenses)
		{
			if (id != expenses.Id)
			{
				return BadRequest();
			}

			_context.Entry(expenses).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!ExpensesExists(id))
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

		[HttpPut("AllParcels/{id}")]
		public async Task<ActionResult<Expenses>> PutExpensesWithParcels(int id, Expenses expenses, bool repeat, int qtyMonths)
		{
			//using (var transaction = _context.Database.BeginTransaction())
			{
				try
				{
					if (id != expenses.Id)
					{
						return BadRequest();
					}

					_context.Entry(expenses).State = EntityState.Modified;

					var expensesList = repeat ?
									   RepeatExpenses(expenses, qtyMonths) :
									   GenerateExpenses(expenses);

					foreach (Expenses cp in expensesList.Skip(1))
					{
						_context.Expenses.Add(cp);

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
		public async Task<ActionResult<Expenses>> SetPositions(List<Expenses> expenses)
		{
			foreach (Expenses expense in expenses)
			{
				_context.Entry(expense).State = EntityState.Modified;
			}

			await _context.SaveChangesAsync();

			return Ok();
		}

		[HttpPut("AddValue/{id}")]
		public async Task<ActionResult<Expenses>> AddValue(int id, decimal value)
		{
			var expenses = await _context.Expenses.FindAsync(id);

			if (expenses == null)
			{
				return NotFound();
			}

			expenses.ToPay      += value;
			expenses.TotalToPay += value;

			await _context.SaveChangesAsync();

			return Ok();
		}

		// POST: api/Expenses
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<Expenses>> PostExpenses(Expenses expenses)
		{
			_context.Expenses.Add(expenses);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetExpenses", new { id = expenses.Id }, expenses);
		}

		[HttpPost("AllParcels")]
		public async Task<ActionResult<Expenses>> PostExpensesWithParcels(Expenses expenses, bool repeat, int qtyMonths)
		{
			//using (var transaction = _context.Database.BeginTransaction())
			{
				try
				{
					var expensesList = repeat ?
									   RepeatExpenses(expenses, qtyMonths) :
									   GenerateExpenses(expenses);

					var i = 1;

					foreach (Expenses cp in expensesList)
					{
						_context.Expenses.Add(cp);

						await _context.SaveChangesAsync();

						if (i++ == 1)
						{
							expenses.Id    = cp.Id;
							expenses.ToPay = cp.ToPay;
						}
					}

					//transaction.Commit();

					return await GetExpenses(expenses.Id);

				}
				catch (Exception ex)
				{
					//transaction.Rollback();

					return Problem(ex.Message);
				}
			}
		}

		// DELETE: api/Expenses/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteExpenses(int id)
		{
			var expenses = await _context.Expenses.FindAsync(id);
			if (expenses == null)
			{
				return NotFound();
			}

			_context.Expenses.Remove(expenses);
			await _context.SaveChangesAsync();

			return NoContent();
		}

		private bool ExpensesExists(int id)
		{
			return _context.Expenses.Any(e => e.Id == id);
		}

		private static ExpensesDTO ExpensesToDTO(Expenses expense) =>
			new ExpensesDTO
			{
				Id           = expense.Id,
				UserId       = expense.UserId,
				Reference    = expense.Reference,
				Position     = expense.Position,
				Description  = expense.Description,
				ToPay        = expense.ToPay,
				Paid         = expense.Paid,
				Remaining    = expense.ToPay - Math.Abs(expense.Paid),
				Note         = expense.Note,
				CardId       = expense.CardId,
				AccountId    = expense.AccountId,
				DueDate      = expense.DueDate,
				ParcelNumber = expense.ParcelNumber,
				Parcels      = expense.Parcels,
				TotalToPay   = expense.TotalToPay,
				CategoryId   = expense.CategoryId,
				Scheduled    = expense.Scheduled,
				PeopleId     = expense.PeopleId
			};



		private static ExpensesDTO2 ExpensesToComboList(Expenses expense) =>
		new ExpensesDTO2
		{
			Id          = expense.Id,
			Position    = expense.Position,
			Description = expense.Description
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
			var newPosition = _context.Expenses.Where(e => e.Reference == reference).Max(e => e.Position) ?? 0;

			return ++newPosition;
		}

		private List<Expenses> GenerateExpenses(Expenses expense)
		{
			var expensesList = new List<Expenses>();

			var reference  = expense.Reference;
			var dueDate    = expense.DueDate;
			var totalToPay = expense.TotalToPay;
			var parcels    = expense.Parcels ?? 1;
			var toPay      = Math.Round(totalToPay / parcels, 2, MidpointRounding.AwayFromZero);
			toPay         += (totalToPay - (toPay * parcels));

			for (int? i = 1; i <= expense.Parcels; i++)
			{
				if (i >= expense.ParcelNumber)
				{
					var e = new Expenses
					{
						UserId       = expense.UserId,
						Reference    = reference,
						Position     = expense.Id > 0 && i == expense.ParcelNumber ? expense.Position : GetNewPosition(reference),
						Description  = expense.Description,
						ToPay        = toPay,
						Paid         = expense.Paid,
						Note         = expense.Note,
						CardId       = expense.CardId,
						AccountId    = expense.AccountId,
						DueDate      = dueDate,
						ParcelNumber = i,
						Parcels      = expense.Parcels,
						TotalToPay   = expense.TotalToPay,
						CategoryId   = expense.CategoryId,
						Scheduled    = expense.Scheduled,
						PeopleId     = expense.PeopleId
					};

					expensesList.Add(e);

					reference = GetNewReference(reference);
					dueDate   = dueDate?.AddMonths(1);
				}

				parcels -= parcels > 1 ? 1 : 0;

				totalToPay = totalToPay > toPay ? totalToPay - toPay : totalToPay;
				toPay      = Math.Round(totalToPay / parcels, 2, MidpointRounding.AwayFromZero);
				toPay     += (totalToPay - (toPay * parcels));
			}

			return expensesList;
		}

		private List<Expenses> RepeatExpenses(Expenses expense, int qtyMonths)
		{
			var expensesList = new List<Expenses>();

			var reference = expense.Reference;
			var dueDate   = expense.DueDate;

			for (int i = 1; i <= (qtyMonths + 1); i++)
			{
				if (i >= expense.ParcelNumber)
				{
					var e = new Expenses
					{
						UserId       = expense.UserId,
						Reference    = reference,
						Position     = expense.Id > 0 && i == expense.ParcelNumber ? expense.Position : GetNewPosition(reference),
						Description  = expense.Description,
						ToPay        = expense.ToPay,
						Paid         = expense.Paid,
						Note         = expense.Note,
						CardId       = expense.CardId,
						AccountId    = expense.AccountId,
						DueDate      = dueDate,
						ParcelNumber = expense.ParcelNumber,
						Parcels      = expense.Parcels,
						TotalToPay   = expense.TotalToPay,
						CategoryId   = expense.CategoryId,
						Scheduled    = expense.Scheduled,
						PeopleId     = expense.PeopleId
					};

					expensesList.Add(e);

					reference = GetNewReference(reference);
					dueDate   = dueDate?.AddMonths(1);
				}
			}

			return expensesList;
		}
	}
}

using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface IExpenseService
	{
		IQueryable<Expenses> GetExpenses();
		IQueryable<Expenses> GetExpenses(int id);
		IQueryable<ExpensesDTO> GetExpensesByReference(string reference);
		IQueryable<ExpensesDTO2> GetExpensesComboList(string reference);
		IQueryable<ExpensesByCategories> GetExpensesByCategories(string reference, int cardId);
		ExpensesByCategories GetExpensesAndCardPostingsByCategoryId(int? id, string reference, int cardId);
		Task<int> PutExpenses(Expenses expenses);
		void PutExpensesWithParcels(Expenses expenses, bool repeat, int qtyMonths);
		Task<int> SetPositions(List<Expenses> expenses);
		Task<int> AddValue(Expenses expense, decimal value);
		Task<int> PostExpenses(Expenses expense);
		void PostExpensesWithParcels(Expenses expenses, bool repeat, int qtyMonths);
		Task<int> DeleteExpenses(Expenses expense);
		bool ExpensesExists(int id);
		bool ValidarUsuario(int expenseId);
	}

	public class ExpenseService : IExpenseService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public ExpenseService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<Expenses> GetExpenses()
		{
			return _context.Expenses.OrderBy(e => e.Position);
		}

		public IQueryable<Expenses> GetExpenses(int id)
		{
			IQueryable<Expenses>? expenses = _context.Expenses.Where(e => e.Id == id && e.UserId == _user.Id);

			return expenses;
		}

		public IQueryable<ExpensesDTO> GetExpensesByReference(string reference)
		{
			IQueryable<ExpensesDTO>? expenses = _context.Expenses.Where(e => e.Reference == reference && e.UserId == _user.Id)
																 .OrderBy(e => e.Position)
																 .Select(e => ExpensesToDTO(e));

			return expenses;
		}

		public IQueryable<ExpensesDTO2> GetExpensesComboList(string reference)
		{
			IQueryable<ExpensesDTO2>? expenses = _context.Expenses.Where(e => e.Reference == reference && e.UserId == _user.Id)
																  .OrderBy(e => e.Position)
																  .Select(e => ExpensesToComboList(e));

			return expenses;
		}

		public IQueryable<ExpensesByCategories> GetExpensesByCategories(string reference, int cardId)
		{
			IQueryable<ExpensesByCategories>? expensesByCategories = _context.GetExpensesByCategories(reference, cardId, _user.Id);

			return expensesByCategories;
		}

		public ExpensesByCategories GetExpensesAndCardPostingsByCategoryId(int? id, string reference, int cardId)
		{
			ExpensesByCategories expensesByCategory = new()
			{
				Id        = id,
				Reference = reference,
				CardId    = cardId
			};

			id = id == 0 ? null : id;

			expensesByCategory.Expenses = _context.Expenses.Where(e => e.CategoryId == id &&
																	   e.Reference == reference &&
																	   e.UserId == _user.Id &&
																	   e.CardId == null).OrderBy(o => o.Position);

			expensesByCategory.CardsPostings = _context.CardsPostings.Include(o => o.Card)
																	 .Where(cp => cp.CategoryId == id &&
																				  cp.Reference == reference &&
																				  cp.Card!.UserId == _user.Id &&
																				  (cardId == 0 || cp.CardId == cardId) &&
																				  !cp.Others)
																	 .OrderBy(o => o.Date).ThenBy(o => o.Position);


			return expensesByCategory;
		}

		public Task<int> PutExpenses(Expenses expense)
		{
			_context.Entry(expense).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public void PutExpensesWithParcels(Expenses expenses, bool repeat, int qtyMonths)
		{
			_context.Entry(expenses).State = EntityState.Modified;

			List<Expenses>? expensesList = repeat ?
										   RepeatExpenses(expenses, qtyMonths) :
										   GenerateExpenses(expenses);

			foreach (Expenses cp in expensesList.Skip(1))
			{
				_context.Expenses.Add(cp);

				_context.SaveChanges();
			}
		}

		public Task<int> SetPositions(List<Expenses> expenses)
		{
			foreach (Expenses expense in expenses)
			{
				_context.Entry(expense).State = EntityState.Modified;
			}

			return _context.SaveChangesAsync();
		}

		public Task<int> AddValue(Expenses expense, decimal value)
		{
			expense.ToPay      += value;
			expense.TotalToPay += value;

			_context.Entry(expense).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public Task<int> PostExpenses(Expenses expense)
		{
			expense.UserId = _user.Id;

			_context.Expenses.Add(expense);

			return _context.SaveChangesAsync();
		}

		public void PostExpensesWithParcels(Expenses expenses, bool repeat, int qtyMonths)
		{
			List<Expenses>? expensesList = repeat ?
										   RepeatExpenses(expenses, qtyMonths) :
										   GenerateExpenses(expenses);

			var i = 1;

			foreach (Expenses cp in expensesList)
			{
				cp.UserId = _user.Id;

				_context.Expenses.Add(cp);

				_context.SaveChanges();

				if (i++ == 1)
				{
					expenses.Id    = cp.Id;
					expenses.ToPay = cp.ToPay;
				}
			}
		}

		public Task<int> DeleteExpenses(Expenses expense)
		{
			_context.Expenses.Remove(expense);

			return _context.SaveChangesAsync();
		}

		public bool ExpensesExists(int id)
		{
			return _context.Expenses.Any(e => e.Id == id && e.UserId == _user.Id);
		}

		public bool ValidarUsuario(int expenseId)
		{
			return GetExpenses(expenseId).Any();
		}

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

		private static ExpensesDTO ExpensesToDTO(Expenses expense) =>
			new()
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
		new()
		{
			Id          = expense.Id,
			Position    = expense.Position,
			Description = expense.Description
		};
	}
}

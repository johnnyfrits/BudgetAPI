using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface ICardReceiptService
	{
		public IQueryable<CardsReceipts> GetCardReceipts();
		public IQueryable<CardsReceipts> GetCardReceipts(int id);
		Task<int> PutCardReceipt(CardsReceipts card);
		Task<int> PostCardReceipt(CardsReceipts card);
		Task<int> DeleteCardReceipt(CardsReceipts card);
		bool CardReceiptExists(int id);
		bool ValidarUsuario(int cardReceiptId);
		bool ValidateAccountAndUser(int cardId);
	}
	public class CardReceiptService : ICardReceiptService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public CardReceiptService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<CardsReceipts> GetCardReceipts()
		{
			return _context.CardsReceipts.Include(c => c.Card)
										 .Where(c => c.Card!.UserId == _user.Id);
		}

		public IQueryable<CardsReceipts> GetCardReceipts(int id)
		{
			IQueryable<CardsReceipts> card = _context.CardsReceipts.Include(c => c.Card)
																   .Where(c => c.Id == id && c.Card!.UserId == _user.Id);

			return card;
		}

		public Task<int> PutCardReceipt(CardsReceipts cardReceipt)
		{
			_context.Entry(cardReceipt).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public Task<int> PostCardReceipt(CardsReceipts cardReceipt)
		{
			_context.CardsReceipts.Add(cardReceipt);

			return _context.SaveChangesAsync();
		}

		public Task<int> DeleteCardReceipt(CardsReceipts cardReceipt)
		{
			_context.CardsReceipts.Remove(cardReceipt);

			return _context.SaveChangesAsync();
		}

		public bool CardReceiptExists(int id)
		{
			return _context.CardsReceipts.Any(e => e.Id == id);
		}

		public bool ValidarUsuario(int cardReceiptId)
		{
			return GetCardReceipts(cardReceiptId).Any();
		}

		public bool ValidateAccountAndUser(int cardId)
		{
			return _context.Cards.Where(c => c.Id == cardId && c.UserId == _user.Id).Any();
		}
	}
}

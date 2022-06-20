using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface ICardPostingService
	{
		IQueryable<CardsPostings> GetCardsPostings();
		IQueryable<CardsPostings> GetCardsPostings(int id);
		IQueryable<CardsPostings> GetCardsPostings(int cardId, string reference);
		IQueryable<CardsPostings> GetCardsPostings(string peopleId, string reference);
		IQueryable<CardsPostingsPeople> GetCardsPostingsPeople(int cardId, string reference);
		CardsPostingsPeople GetCardsPostingsByPeopleId(string? peopleId, string reference, int cardId);
		Task<int> PutCardsPostings(CardsPostings cardPosting);
		void PutCardsPostingsWithParcels(CardsPostings cardsPostings);
		Task<int> PostCardsPostings(CardsPostings cardPosting);
		void PostCardsPostingsWithParcels(CardsPostings cardsPostings);
		Task<int> DeleteCardsPostings(CardsPostings cardPosting);
		Task<int> SetPositions(List<CardsPostings> cardsPostings);
		bool ValidarUsuario(int cardPostingId);
		bool CardsPostingsExists(int id);

		bool ValidateCardAndUser(int cardId);
	}
	public class CardPostingService : ICardPostingService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public CardPostingService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<CardsPostings> GetCardsPostings()
		{
			return _context.CardsPostings.Include(c => c.Card)
										 .Where(c => c.Card!.UserId == _user.Id)
										 .OrderBy(c => c.Position);
		}

		public IQueryable<CardsPostings> GetCardsPostings(int id)
		{
			IQueryable<CardsPostings>? cardsPostings = _context.CardsPostings.Include(c => c.Card)
																			 .Include(c => c.People)
																			 .Where(c => c.Id == id && c.Card!.UserId == _user.Id);

			return cardsPostings;
		}

		public IQueryable<CardsPostings> GetCardsPostings(int cardId, string reference)
		{
			IOrderedQueryable<CardsPostings>? cardsPostings = _context.CardsPostings.Include(c => c.Card)
																					.Where(c => c.CardId == cardId && c.Reference == reference && c.Card!.UserId == _user.Id)
																					.OrderBy(c => c.Position); ;

			return cardsPostings;
		}

		public IQueryable<CardsPostings> GetCardsPostings(string peopleId, string reference)
		{
			IOrderedQueryable<CardsPostings>? cardsPostings = _context.CardsPostings.Include(c => c.Card)
																					.Where(c => c.PeopleId == peopleId && c.Reference == reference && c.Card!.UserId == _user.Id)
																					.OrderBy(c => c.Position); ;

			return cardsPostings;
		}

		public IQueryable<CardsPostingsPeople> GetCardsPostingsPeople(int cardId, string reference)
		{
			IQueryable<CardsPostingsPeople>? cardsPostingsPeople = _context.GetCardsPostingsPeople(cardId, reference, _user.Id);

			return cardsPostingsPeople;
		}

		public CardsPostingsPeople GetCardsPostingsByPeopleId(string? peopleId, string reference, int cardId)
		{
			var cardsPostingPeople = new CardsPostingsPeople
			{
				Reference = reference,
				CardId    = cardId,
				Person    = peopleId
			};


			cardsPostingPeople.CardsPostings = _context.CardsPostings.Include(c => c.Card)
																	 .Where(c => (peopleId == null || c.PeopleId == peopleId) &&
																					 c.Reference == reference &&
																					 c.Card!.UserId == _user.Id &&
																					 (cardId == 0 || c.CardId == cardId))
																	 .OrderBy(c => c.Date).ThenBy(c => c.Position);

			cardsPostingPeople.Incomes = _context.Incomes.Where(i => i.PeopleId == peopleId &&
																	 i.Reference == reference &&
																	 i.UserId == _user.Id);

			return cardsPostingPeople;
		}

		public Task<int> PutCardsPostings(CardsPostings cardPosting)
		{
			_context.Entry(cardPosting).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public void PutCardsPostingsWithParcels(CardsPostings cardsPostings)
		{
			_context.Entry(cardsPostings).State = EntityState.Modified;

			var cardsPostingsList = GenerateCardsPostings(cardsPostings);

			foreach (CardsPostings cp in cardsPostingsList.Skip(1))
			{
				_context.CardsPostings.Add(cp);

				_context.SaveChanges();
			}
		}

		public Task<int> PostCardsPostings(CardsPostings cardPosting)
		{
			// Se a pessoa já existe...
			if (_context.People.FirstOrDefault(p => p.Id == cardPosting.PeopleId && p.UserId == _user.Id) != null)
			{
				cardPosting.People = null; //...então remove para não tentar inserir
			}

			cardPosting.Position = (short)((_context.CardsPostings.Include(c => c.Card)
																  .Where(c => c.Reference == cardPosting.Reference && c.CardId == cardPosting.CardId && c.Card!.UserId == _user.Id).Max(c => c.Position) ?? 0) + 1);

			_context.CardsPostings.Add(cardPosting);

			return _context.SaveChangesAsync();
		}

		public void PostCardsPostingsWithParcels(CardsPostings cardsPostings)
		{
			List<CardsPostings>? cardsPostingsList = GenerateCardsPostings(cardsPostings);

			var i = 1;

			foreach (CardsPostings cp in cardsPostingsList)
			{
				_context.CardsPostings.Add(cp);

				_context.SaveChanges();

				if (i++ == 1)
				{
					cardsPostings.Id     = cp.Id;
					cardsPostings.Amount = cp.Amount;
				}
			}
		}

		public Task<int> DeleteCardsPostings(CardsPostings cardPosting)
		{
			_context.CardsPostings.Remove(cardPosting);

			return _context.SaveChangesAsync();
		}

		public Task<int> SetPositions(List<CardsPostings> cardsPostings)
		{
			foreach (CardsPostings cardPosting in cardsPostings)
			{
				_context.Entry(cardPosting).State = EntityState.Modified;
			}

			return _context.SaveChangesAsync();
		}

		public bool CardsPostingsExists(int id)
		{
			return GetCardsPostings(id).Any();
		}

		private static string GetNewReference(string reference)
		{
			var year  = int.Parse(reference.Substring(0, 4));
			var month = int.Parse(reference.Substring(4, 2));

			var date = new DateTime(year, month, 1).AddMonths(1);

			var newReference = date.ToString("yyyyMM");

			return newReference;
		}

		private short GetNewPosition(string reference, int cardId)
		{
			var newPosition = _context.CardsPostings.Include(c => c.Card)
														 .Where(e => e.Reference == reference && e.CardId == cardId && e.Card!.UserId == _user.Id).Max(e => e.Position) ?? 0;

			return ++newPosition;
		}

		private List<CardsPostings> GenerateCardsPostings(CardsPostings cardPosting)
		{
			var cardsPostingsList = new List<CardsPostings>();

			var reference    = cardPosting.Reference;
			var totalAmount  = cardPosting.TotalAmount ?? 0;
			var parcels      = cardPosting.Parcels ?? 1;
			var amountParcel = Math.Round(totalAmount / parcels, 2, MidpointRounding.AwayFromZero);
			amountParcel    += (totalAmount - (amountParcel * parcels));

			for (int? i = 1; i <= cardPosting.Parcels; i++)
			{
				if (i >= cardPosting.ParcelNumber)
				{
					var cp = new CardsPostings
					{
						CardId       = cardPosting.CardId,
						Date         = cardPosting.Date,
						Reference    = reference,
						PeopleId     = cardPosting.PeopleId,
						Position     = cardPosting.Id > 0 && i == 1 ? cardPosting.Position : GetNewPosition(reference, cardPosting.CardId),
						Description  = cardPosting.Description,
						ParcelNumber = i,
						Parcels      = cardPosting.Parcels,
						Amount       = amountParcel,
						TotalAmount  = cardPosting.TotalAmount,
						Others       = cardPosting.Others,
						Note         = cardPosting.Note,
						CategoryId   = cardPosting.CategoryId
					};

					cardsPostingsList.Add(cp);

					reference = GetNewReference(reference);
				}

				parcels -= parcels > 1 ? 1 : 0;

				totalAmount   = totalAmount > amountParcel ? totalAmount - amountParcel : totalAmount;
				amountParcel  = Math.Round(totalAmount / parcels, 2, MidpointRounding.AwayFromZero);
				amountParcel += (totalAmount - (amountParcel * parcels));
			}

			return cardsPostingsList;
		}
		
		public bool ValidarUsuario(int cardPostingId)
		{
			return GetCardsPostings(cardPostingId).Any();
		}

		public bool ValidateCardAndUser(int cardId)
		{
			return _context.Cards.Where(c => c.Id == cardId && c.UserId == _user.Id).Any();
		}
	}
}

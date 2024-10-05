using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
    public interface ICardPostingService
    {
        IQueryable<CardsPostings> GetCardsPostings();
        IQueryable<CardsPostings> GetCardsPostings(int id);
        IQueryable<CardsPostingsDTO> GetCardsPostings(int cardId, string reference);
        IQueryable<CardsPostings> GetCardsPostingsByDescription(string description);
        IQueryable<CardsPostings> GetCardsPostings(string peopleId, string reference);
        IQueryable<CardsPostingsPeople> GetCardsPostingsPeople(int cardId, string reference);
        CardsPostingsPeople GetCardsPostingsByPeopleId(string? peopleId, string reference, int cardId);
        Task<int> PutCardsPostings(CardsPostings cardPosting);
        void PutCardsPostingsWithParcels(CardsPostings cardsPostings, bool repeat, int qtyMonths);
        Task<int> PostCardsPostings(CardsPostings cardPosting);
        void PostCardsPostingsWithParcels(CardsPostings cardsPostings, bool repeat, int qtyMonths);
        Task<int> DeleteCardsPostings(CardsPostings cardPosting);
        Task<int> SetPositions(List<CardsPostings> cardsPostings);
        bool ValidarUsuario(int cardPostingId);
        bool CardsPostingsExists(int id);

        bool ValidateCardAndUser(int cardId);
        int? GetCategory(string description);
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

        public IQueryable<CardsPostings> GetCardsPostingsByDescription(string description)
        {
            IQueryable<CardsPostings>? cardsPostings = _context.CardsPostings.Where(cp => cp.Card!.UserId == _user.Id &&
                                                                            cp.CategoryId != null &&
                                                                            cp.Description.ToLower() == description.ToLower())
                                                                             .OrderByDescending(o => o.Id);

            return cardsPostings;
        }

        public IQueryable<CardsPostingsDTO> GetCardsPostings(int cardId, string reference)
        {
            CardsInvoiceDate? invoiceDates = _context.CardsInvoiceDate.FirstOrDefault(cid => cid.CardId == cardId && cid.Reference == reference && cid.UserId == _user.Id);

            IQueryable<CardsPostingsDTO>? cardsPostings = _context.CardsPostings.Include(c => c.Card)
                                                                                .Where(c => c.CardId == cardId && c.Reference == reference && c.Card!.UserId == _user.Id)
                                                                                .OrderBy(c => c.Position)
                                                                                .Select(c => CardPostingToDTO(c, invoiceDates));

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

            cardsPostingPeople.AccountsPostings = _context.AccountsPostings.Include(ap => ap.Account)
                                                                           .Include(ap => ap.Income)
                                                                           .Include(ap => ap.CardReceipt)
                                                                           .ThenInclude(cr => cr!.Card)
                                                                           .Where(ap => ap.Account!.UserId == _user.Id &&
                                                                                        (ap.Income!.PeopleId == peopleId ||
                                                                                         ap.CardReceipt!.PeopleId == peopleId) &&
                                                                                        ap.Reference == reference
                                                                                 );

            return cardsPostingPeople;
        }

        public Task<int> PutCardsPostings(CardsPostings cardPosting)
        {
            _context.Entry(cardPosting).State = EntityState.Modified;

            return _context.SaveChangesAsync();
        }

        public void PutCardsPostingsWithParcels(CardsPostings cardsPostings, bool repeat, int qtyMonths)
        {
            _context.Entry(cardsPostings).State = EntityState.Modified;

            List<CardsPostings>? cardsPostingsList = repeat ?
                                                     RepeatCardsPostings(cardsPostings, qtyMonths) :
                                                     GenerateCardsPostings(cardsPostings);

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

        public void PostCardsPostingsWithParcels(CardsPostings cardsPostings, bool repeat, int qtyMonths)
        {
            List<CardsPostings>? cardsPostingsList = repeat ?
                                                     RepeatCardsPostings(cardsPostings, qtyMonths) :
                                                     GenerateCardsPostings(cardsPostings);

            CardsPostings? firstCardsPostings = null;

            foreach (CardsPostings cp in cardsPostingsList)
            {
                _context.CardsPostings.Add(cp);

                _context.SaveChanges();

                if (firstCardsPostings == null)
                {
                    firstCardsPostings = cp;

                    // Update the input object with the details of the first CardsPostings
                    cardsPostings.Id     = firstCardsPostings.Id;
                    cardsPostings.Amount = firstCardsPostings.Amount;
                }
                else
                {
                    cp.RelatedId = firstCardsPostings.Id;
                    _context.SaveChanges();
                }
            }
        }


        public async Task<int> DeleteCardsPostings(CardsPostings cardPosting)
        {
            // Find all the CardsPostings with the RelatedId equal to the Id of the cardPosting to be deleted
            var relatedCardsPostings = _context.CardsPostings.Where(cp => cp.RelatedId == cardPosting.Id);

            // Remove all found CardsPostings
            _context.CardsPostings.RemoveRange(relatedCardsPostings);

            // Remove the original cardPosting
            _context.CardsPostings.Remove(cardPosting);

            // Save changes and return the number of affected entries
            return await _context.SaveChangesAsync();
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

            string? reference    = cardPosting.Reference;
            decimal totalAmount  = cardPosting.TotalAmount ?? 0;
            int parcels          = cardPosting.Parcels ?? 1;
            decimal amountParcel = Math.Round(totalAmount / parcels, 2, MidpointRounding.AwayFromZero);

            for (int? i = 1; i <= cardPosting.Parcels; i++)
            {
                // Calculate the difference between total amount and the sum of parcels
                decimal difference = totalAmount - (amountParcel * parcels);

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

                // Add the difference to the first parcel
                if (i == cardPosting.ParcelNumber && difference > 0)
                {
                    cp.Amount += difference;
                }

                cardsPostingsList.Add(cp);

                reference = GetNewReference(reference);

                // Substract the current amount from the total
                totalAmount -= cp.Amount;

                parcels -= parcels > 1 ? 1 : 0;

                // Recalculate the amount of each parcel
                amountParcel = parcels > 1 ? Math.Round(totalAmount / parcels, 2, MidpointRounding.AwayFromZero) : totalAmount;
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

        private static CardsPostingsDTO CardPostingToDTO(CardsPostings cardPosting, CardsInvoiceDate? invoiceDates)
        {
            CardsPostingsDTO cardPostingDTO = new()
            {
                Id           = cardPosting.Id,
                CardId       = cardPosting.CardId,
                Date         = cardPosting.Date,
                Reference    = cardPosting.Reference,
                PeopleId     = cardPosting.PeopleId,
                Position     = cardPosting.Position,
                Description  = cardPosting.Description,
                ParcelNumber = cardPosting.ParcelNumber,
                Parcels      = cardPosting.Parcels,
                Amount       = cardPosting.Amount,
                TotalAmount  = cardPosting.TotalAmount,
                Others       = cardPosting.Others,
                Note         = cardPosting.Note,
                CategoryId   = cardPosting.CategoryId,
                People       = cardPosting.People,
                Card         = cardPosting.Card,
                InTheCycle   = invoiceDates != null && cardPosting.Date >= invoiceDates.InvoiceStart && cardPosting.Date <= invoiceDates.InvoiceEnd,
                RelatedId    = cardPosting.RelatedId
            };

            return cardPostingDTO;
        }

        private List<CardsPostings> RepeatCardsPostings(CardsPostings cardPosting, int qtyMonths)
        {
            var cardPostingsList = new List<CardsPostings>();

            string reference = cardPosting.Reference;

            for (int i = 1; i <= (qtyMonths + 1); i++)
            {
                if (i >= cardPosting.ParcelNumber)
                {
                    var e = new CardsPostings
                    {
                        CardId       = cardPosting.CardId,
                        Date         = i == 1 ? cardPosting.Date : cardPosting.Date.AddMonths(i - 1),
                        Reference    = reference,
                        PeopleId     = cardPosting.PeopleId,
                        Position     = cardPosting.Id > 0 && i == 1 ? cardPosting.Position : GetNewPosition(reference, cardPosting.CardId),
                        Description  = cardPosting.Description,
                        ParcelNumber = 1,
                        Parcels      = cardPosting.Parcels,
                        Amount       = cardPosting.Amount,
                        TotalAmount  = cardPosting.TotalAmount,
                        Others       = cardPosting.Others,
                        Note         = cardPosting.Note,
                        CategoryId   = cardPosting.CategoryId
                    };

                    cardPostingsList.Add(e);

                    reference = GetNewReference(reference);
                }
            }

            return cardPostingsList;
        }

        public int? GetCategory(string description)
        {
            CardsPostings? cardPosting = _context.CardsPostings.Where(cp => cp.Card!.UserId == _user.Id &&
                                                                            cp.CategoryId != null &&
                                                                            cp.Description.ToLower() == description.ToLower())
                                                               .FirstOrDefault();


            return cardPosting != null ? cardPosting.CategoryId : null;
        }
    }
}

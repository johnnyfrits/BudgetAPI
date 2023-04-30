using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;

namespace BudgetAPI.Services
{
    public interface ICardService
    {
        public IQueryable<CardsDTO> GetCards();
        public IQueryable<CardsDTO> GetCardsWithCardsInvoiceDate(string reference);
        public IQueryable<Cards> GetCards(int id);
        Task<int> PutCard(int id, Cards card);
        Task<int> PostCard(Cards card);
        Task<int> DeleteCard(Cards card);
        bool CardExists(int id);
        bool ValidarUsuario(int id);
    }
    public class CardService : ICardService
    {
        private readonly BudgetContext _context;

        private readonly Users _user;

        public CardService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
        }

        public IQueryable<CardsDTO> GetCards()
        {
            return _context.Cards.Where(u => u.UserId == _user.Id)
                                 .Select(c => CardToDTO(c));
        }

        public IQueryable<CardsDTO> GetCardsWithCardsInvoiceDate(string reference)
        {
            //LEFT JOIN IN LINQ
            IQueryable<CardsDTO>? result = from c in _context.Cards
                                           join cid in _context.CardsInvoiceDate on new { CardId = c.Id, Reference = reference } equals new { cid.CardId, cid.Reference } into cardInvoiceDate
                                           from cid in cardInvoiceDate.DefaultIfEmpty()
                                           select new CardsDTO
                                           {
                                               Id              = c.Id,
                                               UserId          = c.UserId,
                                               Name            = c.Name,
                                               Color           = c.Color,
                                               Background      = c.Background,
                                               Disabled        = c.Disabled,
                                               //ClosingDay      = c.ClosingDay,
                                               CardInvoiceDate = cid != null ? new CardsInvoiceDate
                                               {
                                                   Id = cid.Id,
                                                   Reference = cid.Reference,
                                                   CardId = cid.CardId,
                                                   InvoiceStart = cid.InvoiceStart,
                                                   InvoiceEnd = cid.InvoiceEnd,
                                                   UserId = cid.UserId
                                               } : null
                                           };



            return result;
        }

        public IQueryable<Cards> GetCards(int id)
        {
            IQueryable<Cards> card = _context.Cards.Where(c => c.Id == id && c.UserId == _user.Id);

            return card;
        }

        public Task<int> PutCard(int id, Cards card)
        {
            _context.Entry(card).State = EntityState.Modified;

            return _context.SaveChangesAsync();
        }

        public Task<int> PostCard(Cards card)
        {
            card.UserId = _user.Id;

            _context.Cards.Add(card);

            return _context.SaveChangesAsync();
        }

        public Task<int> DeleteCard(Cards card)
        {
            _context.Cards.Remove(card);

            return _context.SaveChangesAsync();
        }

        public bool CardExists(int id)
        {
            return _context.Cards.Any(e => e.Id == id);
        }

        public bool ValidarUsuario(int id)
        {
            return id == _user.Id;
        }

        private static CardsDTO CardToDTO(Cards card) =>
        new()
        {
            Id         = card.Id,
            UserId     = card.UserId,
            Name       = card.Name,
            Color      = card.Color,
            Background = card.Background,
            Disabled   = card.Disabled,
            //ClosingDay = card.ClosingDay
        };
    }
}

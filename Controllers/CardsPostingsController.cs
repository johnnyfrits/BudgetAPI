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
    public class CardsPostingsController : ControllerBase
    {
        private readonly ICardPostingService _cardPostingService;

        public CardsPostingsController(ICardPostingService cardPostingService)
        {
            _cardPostingService = cardPostingService;
        }

        // GET: api/CardsPostings
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CardsPostings>>> GetCardsPostings()
        {
            return await _cardPostingService.GetCardsPostings().ToListAsync();
        }

        // GET: api/CardsPostings/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CardsPostings>> GetCardsPostings(int id)
        {
            CardsPostings? cardsPostings = await _cardPostingService.GetCardsPostings(id).FirstOrDefaultAsync();

            if (cardsPostings == null)
            {
                return NotFound();
            }

            return cardsPostings;
        }

        [HttpGet("ByDescription/{description}")]
        public async Task<ActionResult<CardsPostings>> ByDescription(string description)
        {
            CardsPostings? cardsPostings = await _cardPostingService.GetCardsPostingsByDescription(description).FirstOrDefaultAsync();

            if (cardsPostings == null)
            {
                return NotFound();
            }

            return cardsPostings;
        }

        [HttpGet("{cardId}/{reference}")]
        public async Task<ActionResult<IEnumerable<CardsPostingsDTO>>> GetCardsPostings(int cardId, string reference)
        {
            List<CardsPostingsDTO>? cardsPostings = await _cardPostingService.GetCardsPostings(cardId, reference).ToListAsync();

            return cardsPostings;
        }

        [HttpGet("People/{peopleId}/{reference}")]
        public async Task<ActionResult<IEnumerable<CardsPostings>>> GetCardsPostings(string peopleId, string reference)
        {
            List<CardsPostings>? cardsPostings = await _cardPostingService.GetCardsPostings(peopleId, reference).ToListAsync();

            return cardsPostings;
        }

        [HttpGet("People")]
        public async Task<ActionResult<IEnumerable<CardsPostingsPeople>>> GetCardsPostingsPeople(int cardId, string reference)
        {
            List<CardsPostingsPeople>? cardsPostingsPeople = await _cardPostingService.GetCardsPostingsPeople(cardId, reference).ToListAsync();

            return cardsPostingsPeople;
        }

        [HttpGet("PeopleById")]
        public async Task<ActionResult<CardsPostingsPeople?>> GetCardsPostingsByPeopleIdAsync(string? peopleId, string reference, int cardId)
        {
            CardsPostingsPeople? cardsPostingPeople = await Task.Run(() =>
            {
                return _cardPostingService.GetCardsPostingsByPeopleId(peopleId, reference, cardId);
            });

            return cardsPostingPeople;
        }

        // PUT: api/CardsPostings/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCardsPostings(int id, CardsPostings cardsPostings)
        {
            if (id != cardsPostings.Id || !_cardPostingService.ValidarUsuario(id))
            {
                return BadRequest();
            }

            try
            {
                await _cardPostingService.PutCardsPostings(cardsPostings);
            }
            catch (DbUpdateConcurrencyException dex)
            {
                if (!_cardPostingService.CardsPostingsExists(id))
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

        [HttpPut("SetPositions")]
        public async Task<ActionResult<CardsPostings>> SetPositions(List<CardsPostings> cardsPostings)
        {
            await _cardPostingService.SetPositions(cardsPostings);

            return Ok();
        }

        [HttpPut("AllParcels/{id}")]
        public async Task<ActionResult<CardsPostings>> PutCardsPostingsWithParcels(int id, CardsPostings cardsPostings, bool repeat, int qtyMonths)
        {
            try
            {
                if (id != cardsPostings.Id || !_cardPostingService.ValidarUsuario(id))
                {
                    return BadRequest();
                }

                await Task.Run(() =>
                {
                    _cardPostingService.PutCardsPostingsWithParcels(cardsPostings, repeat, qtyMonths);
                });

                return Ok();
            }
            catch (Exception ex)
            {
                return Problem(ex.Message);
            }
        }

        // POST: api/CardsPostings
        [HttpPost]
        public async Task<ActionResult<CardsPostings>> PostCardsPostings(CardsPostings cardsPostings)
        {
            try
            {
                if (!_cardPostingService.ValidateCardAndUser(cardsPostings.CardId))
                {
                    return BadRequest();
                }

                await _cardPostingService.PostCardsPostings(cardsPostings);

                return await GetCardsPostings(cardsPostings.Id);
            }
            catch (Exception ex)
            {
                return Problem(ex.ToString() + "\n\n" + ex.InnerException?.Message);
            }
        }

        [HttpPost("AllParcels")]
        public async Task<ActionResult<CardsPostings>> PostCardsPostingsWithParcels(CardsPostings cardsPostings, bool repeat, int qtyMonths)
        {
            try
            {
                if (!_cardPostingService.ValidateCardAndUser(cardsPostings.CardId))
                {
                    return BadRequest();
                }

                await Task.Run(() =>
                {
                    _cardPostingService.PostCardsPostingsWithParcels(cardsPostings, repeat, qtyMonths);
                });

                return await GetCardsPostings(cardsPostings.Id);

            }
            catch (Exception ex)
            {
                return Problem(ex.Message);
            }
        }

        // DELETE: api/CardsPostings/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCardsPostings(int id)
        {
            CardsPostings? cardPosting = await _cardPostingService.GetCardsPostings(id).FirstOrDefaultAsync();

            if (cardPosting == null)
            {
                return NotFound();
            }

            if (!_cardPostingService.ValidarUsuario(cardPosting.Id))
            {
                return BadRequest();
            }

            await _cardPostingService.DeleteCardsPostings(cardPosting);

            return Ok();
        }
    }
}

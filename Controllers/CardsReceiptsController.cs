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
    public class CardsReceiptsController : ControllerBase
    {
        private readonly ICardReceiptService _cardReceiptService;

        public CardsReceiptsController(ICardReceiptService cardReceiptService)
        {
            _cardReceiptService = cardReceiptService;
        }

        // GET: api/CardsReceipts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CardsReceipts>>> GetCardsReceipts()
        {
            return await _cardReceiptService.GetCardReceipts().ToListAsync();
        }

        // GET: api/CardsReceipts/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CardsReceipts>> GetCardsReceipts(int id)
        {
            CardsReceipts? cardReceipt = await _cardReceiptService.GetCardReceipts(id).FirstOrDefaultAsync();

            if (cardReceipt == null)
            {
                return NotFound();
            }

            return cardReceipt;
        }

        // PUT: api/CardsReceipts/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCardsReceipts(int id, CardsReceipts cardsReceipts)
        {
            if (id != cardsReceipts.Id || !_cardReceiptService.ValidarUsuario(cardsReceipts.Id))
            {
                return BadRequest();
            }

            try
            {
                await _cardReceiptService.PutCardReceipt(cardsReceipts);
            }
            catch (DbUpdateConcurrencyException dex)
            {
                if (!_cardReceiptService.CardReceiptExists(id))
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

        // POST: api/CardsReceipts
        [HttpPost]
        public async Task<ActionResult<CardsReceipts>> PostCardsReceipts(CardsReceipts cardsReceipts)
        {
            if (!_cardReceiptService.ValidateAccountAndUser(cardsReceipts.CardId))
            {
                return BadRequest();
            }

            try
            {
                await _cardReceiptService.PostCardReceipt(cardsReceipts);

            }
            catch (Exception ex )
            {
                return Problem(ex.Message);
            }

            return CreatedAtAction("GetCardsReceipts", new { id = cardsReceipts.Id }, cardsReceipts);
        }

        // DELETE: api/CardsReceipts/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCardsReceipts(int id)
        {
            CardsReceipts? cardReceipt = await _cardReceiptService.GetCardReceipts(id).FirstOrDefaultAsync();

            if (cardReceipt == null)
            {
                return NotFound();
            }

            if (!_cardReceiptService.ValidarUsuario(cardReceipt.Id))
            {
                return BadRequest();
            }

            await _cardReceiptService.DeleteCardReceipt(cardReceipt);

            return Ok();
        }
    }
}

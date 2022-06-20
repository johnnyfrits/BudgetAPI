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
	public class CategoriesController : ControllerBase
	{
		private readonly ICategoryService _categoryService;

		public CategoriesController(ICategoryService categoryService)
		{
			_categoryService = categoryService;
		}

		// GET: api/Categories
		[HttpGet]
		public async Task<ActionResult<IEnumerable<Categories>>> GetCategories()
		{
			return await _categoryService.GetCategories().ToListAsync();
		}

		// GET: api/Categories/5
		[HttpGet("{id}")]
		public async Task<ActionResult<Categories>> GetCategories(int id)
		{
			Categories? categories = await _categoryService.GetCategories(id).FirstOrDefaultAsync();

			if (categories == null)
			{
				return NotFound();
			}

			return categories;
		}

		// PUT: api/Categories/5
		[HttpPut("{id}")]
		public async Task<IActionResult> PutCategories(int id, Categories category)
		{
			if (id != category.Id || !_categoryService.ValidarUsuario(category.UserId))
			{
				return BadRequest();
			}

			try
			{
				await _categoryService.PutCategories(category);
			}
			catch (DbUpdateConcurrencyException dex)
			{
				if (!_categoryService.CategoriesExists(id))
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

		// POST: api/Categories
		[HttpPost]
		public async Task<ActionResult<Categories>> PostCategories(Categories category)
		{
			await _categoryService.PostCategories(category);

			return CreatedAtAction("GetCategories", new { id = category.Id }, category);
		}

		// DELETE: api/Categories/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteCategories(int id)
		{
			Categories? category = await _categoryService.GetCategories(id).FirstOrDefaultAsync();

			if (category == null)
			{
				return NotFound();
			}

			if (!_categoryService.ValidarUsuario(category.UserId))
			{
				return BadRequest();
			}

			await _categoryService.DeleteCategories(category);

			return Ok();
		}
	}
}

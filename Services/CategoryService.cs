using BudgetAPI.Data;
using BudgetAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace BudgetAPI.Services
{
	public interface ICategoryService
	{
		IQueryable<Categories> GetCategories();
		IQueryable<Categories> GetCategories(int id);
		Task<int> PutCategories(Categories category);
		Task<int> PostCategories(Categories category);
		Task<int> DeleteCategories(Categories category);
		bool CategoriesExists(int id);
		bool ValidarUsuario(int id);
	}
	public class CategoryService : ICategoryService
	{
		private readonly BudgetContext _context;

		private readonly Users _user;

		public CategoryService(BudgetContext context, IHttpContextAccessor httpContextAccessor)
		{
			_context = context;
			_user    = httpContextAccessor.HttpContext!.Items["User"] as Users ?? new Users();
		}

		public IQueryable<Categories> GetCategories()
		{
			IQueryable<Categories> query = _context.Categories.Where(a => a.UserId == _user.Id);

			return query;
		}

		public IQueryable<Categories> GetCategories(int id)
		{
			var categories = _context.Categories.Where(a => a.UserId == _user.Id && a.Id == id);

			return categories;
		}

		public Task<int> PutCategories(Categories category)
		{
			_context.Entry(category).State = EntityState.Modified;

			return _context.SaveChangesAsync();
		}

		public Task<int> PostCategories(Categories category)
		{
			category.UserId = _user.Id;

			_context.Categories.Add(category);

			return _context.SaveChangesAsync();
		}

		public Task<int> DeleteCategories(Categories category)
		{
			_context.Categories.Remove(category);

			return _context.SaveChangesAsync();
		}

		public bool CategoriesExists(int id)
		{
			return _context.Categories.Any(e => e.Id == id);
		}

		public bool ValidarUsuario(int id)
		{
			return id == _user.Id;
		}
	}
}

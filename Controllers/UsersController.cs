using BudgetAPI.Authorization;
using BudgetAPI.Helpers;
using BudgetAPI.Models;
using BudgetAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace BudgetAPI.Controllers
{
	[Authorize]
	[ApiController]
	[Route("api/[controller]")]
	public class UsersController : ControllerBase
	{
		private readonly IUserService _userService;
		private readonly AppSettings _appSettings;

		public UsersController(IUserService userService, IOptions<AppSettings> appSettings)
		{
			_userService = userService;
			_appSettings = appSettings.Value;
		}

		[AllowAnonymous]
		[HttpPost("authenticate")]
		public IActionResult Authenticate(UsersAuthenticateRequest model)
		{
			UsersAuthenticateResponse? response = _userService.Authenticate(model);

			return Ok(response);
		}

		[AllowAnonymous]
		[HttpPost("register")]
		public IActionResult Register(UsersRegisterRequest model)
		{
			_userService.Register(model);

			return Ok(new { message = "Cadastro concluído!" });
		}

		[HttpGet]
		public IActionResult GetAll()
		{
			IEnumerable<Users>? users = _userService.GetAll();

			return Ok(users);
		}

		[HttpGet("{id}")]
		public IActionResult GetById(int id)
		{
			Users? user = _userService.GetById(id);

			return Ok(user);
		}

		[HttpPut("{id}")]
		public IActionResult Update(int id, UsersUpdateRequest model)
		{
			_userService.Update(id, model);

			return Ok(new { message = "Usuário atualizado!" });
		}

		[HttpDelete("{id}")]
		public IActionResult Delete(int id)
		{
			_userService.Delete(id);

			return Ok(new { message = "Usuário excluído!" });
		}
	}
}

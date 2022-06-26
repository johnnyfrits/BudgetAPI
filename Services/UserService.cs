using BudgetAPI.Authorization;
using BudgetAPI.Data;
using BudgetAPI.Models;

namespace BudgetAPI.Services
{
	public interface IUserService
	{
		UsersAuthenticateResponse Authenticate(UsersAuthenticateRequest model);
		IEnumerable<Users> GetAll();
		Users GetById(int id);
		void Register(UsersRegisterRequest newUser);
		void Update(int id, UsersUpdateRequest model);
		void Delete(int id);
		bool UserExists(UsersRegisterRequest user);
		bool UserExists(int id, UsersUpdateRequest currentUser);
	}

	public class UserService : IUserService
	{
		private readonly BudgetContext _context;
		private readonly IJwtUtils _jwtUtils;
		private readonly IHttpContextAccessor _httpContextAccessor;

		public UserService(BudgetContext context, IJwtUtils jwtUtils, IHttpContextAccessor httpContextAccessor)
		{
			_context             = context;
			_jwtUtils            = jwtUtils;
			_httpContextAccessor = httpContextAccessor;
		}

		public UsersAuthenticateResponse Authenticate(UsersAuthenticateRequest model)
		{
			Users? user = _context.Users.SingleOrDefault(x => x.Login == model.Login);

// validate

			var hash = BCrypt.Net.BCrypt.HashPassword(model.Password);

			if (user == null || !BCrypt.Net.BCrypt.Verify(model.Password, user.Password))
				//throw new AppException("Username or password is incorrect");
				throw new Exception("Login ou senha está incorreto!");

			// authentication successful
			//var response = _mapper.Map<AuthenticateResponse>(user);
			var response = new UsersAuthenticateResponse
			{
				Id    = user.Id,
				Name  = user.Name,
				Login = user.Login
			};

			response.Token = _jwtUtils.GenerateToken(user);

			return response;
		}

		public void Delete(int id)
		{
			Users? user = GetUser(id);

			_context.Users.Remove(user);

			_context.SaveChanges();
		}

		public IEnumerable<Users> GetAll()
		{
			return _context.Users;
		}

		public Users GetById(int id)
		{
			return GetUser(id);
		}

		public void Register(UsersRegisterRequest newUser)
		{
			// map newUser to new user object
			//var user = _mapper.Map<User>(newUser);
			var user = new Users
			{
				Name  = newUser.Name,
				Login = newUser.Login
			};

			// hash password
			user.Password = BCrypt.Net.BCrypt.HashPassword(newUser.Password);

			// save user
			_context.Users.Add(user);

			_context.SaveChanges();
		}

		public bool UserExists(UsersRegisterRequest user)
		{
			return _context.Users.Any(x => x.Login == user.Login);
		}

		public bool UserExists(int id, UsersUpdateRequest currentUser)
		{
			Users user = GetUser(id);

			return currentUser.Login != user.Login && _context.Users.Any(x => x.Login == currentUser.Login);
		}

		public void Update(int id, UsersUpdateRequest model)
		{
			Users user = GetUser(id);

			// hash password if it was entered
			if (!string.IsNullOrEmpty(model.Password))
				user.Password = BCrypt.Net.BCrypt.HashPassword(model.Password);

			// copy newUser to user and save
			//_mapper.Map(newUser, user);
			user.Name  = model.Name;
			user.Login = model.Login;

			_context.Users.Update(user);

			_context.SaveChanges();
		}

		private Users GetUser(int id)
		{
			Users? user = _context.Users.Find(id);

			if (user == null) 
				throw new KeyNotFoundException("Usuário não encontrado!");

			return user;
		}
	}
}

using System.ComponentModel.DataAnnotations;

namespace BudgetAPI.Models
{
	public class UsersAuthenticateRequest
	{
		[Required]
		public string Login { get; set; }

		[Required]
		public string Password { get; set; }
	}
}

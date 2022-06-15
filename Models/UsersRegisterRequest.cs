using System.ComponentModel.DataAnnotations;

namespace BudgetAPI.Models
{
	public class UsersRegisterRequest
	{
		[Required]
		public string Name { get; set; }
		[Required]
		public string Login { get; set; }
		[Required]
		public string Password { get; set; }
	}
}

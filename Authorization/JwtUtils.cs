using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BudgetAPI.Helpers;
using BudgetAPI.Models;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace BudgetAPI.Authorization
{
	public interface IJwtUtils
	{
		public string GenerateToken(Users user);
		public int? ValidateToken(string? token);
	}

	public class JwtUtils : IJwtUtils
	{
		private readonly AppSettings _appSettings;

		public JwtUtils(IOptions<AppSettings> appSettings)
		{
			_appSettings = appSettings.Value;
		}

		public string GenerateToken(Users user)
		{
			// generate token that is valid for 7 days
			var tokenHandler = new JwtSecurityTokenHandler();

			byte[]? key = Encoding.ASCII.GetBytes(_appSettings.Secret);

			var tokenDescriptor = new SecurityTokenDescriptor
			{
				Subject = new ClaimsIdentity(new[] { new Claim("id", user.Id.ToString()) }),
				Expires = DateTime.UtcNow.AddDays(7),
				SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
			};

			SecurityToken? token = tokenHandler.CreateToken(tokenDescriptor);

			return tokenHandler.WriteToken(token);
		}

		public int? ValidateToken(string? token)
		{
			if (token == null)
				return null;

			var tokenHandler = new JwtSecurityTokenHandler();

			byte[]? key = Encoding.ASCII.GetBytes(_appSettings.Secret);

			try
			{
				tokenHandler.ValidateToken(token, new TokenValidationParameters
				{
					ValidateIssuerSigningKey = true,
					IssuerSigningKey         = new SymmetricSecurityKey(key),
					ValidateIssuer           = false,
					ValidateAudience         = false,
					ClockSkew                = TimeSpan.Zero // set clockskew to zero so tokens expire exactly at token expiration time (instead of 5 minutes later)
				}, out SecurityToken validatedToken);

				var jwtToken = (JwtSecurityToken)validatedToken;
				var userId   = int.Parse(jwtToken.Claims.First(x => x.Type == "id").Value);

				// return user id from JWT token if validation successful
				return userId;
			}
			catch
			{
				// return null if validation fails
				return null;
			}
		}
	}
}

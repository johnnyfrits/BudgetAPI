using BudgetAPI.Models;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;

namespace BudgetAPI.Authorization
{
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
	public class AuthorizeAttribute : Attribute, IAuthorizationFilter
	{
		public void OnAuthorization(AuthorizationFilterContext context)
		{
			// skip authorization if action is decorated with [AllowAnonymous] attribute
			bool allowAnonymous = context.ActionDescriptor.EndpointMetadata.OfType<AllowAnonymousAttribute>().Any();

			if (allowAnonymous)
				return;

			// authorization
			var user = context.HttpContext.Items["User"] as Users;

			//var urlId = context.RouteData.Values["id"];

			var unathourized = false;

			if (user == null)
			{
				unathourized = true;
			}
			//else if (urlId != null && urlId.ToString() != user.Id.ToString())
			//{
			//	unathourized = true;
			//}

			if (unathourized)
			{
				context.Result = new JsonResult(new { message = "Unauthorized" }) { StatusCode = StatusCodes.Status401Unauthorized };
			}
		}
	}
}

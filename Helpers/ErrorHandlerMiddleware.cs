using System.Net;
using System.Text.Json;

namespace BudgetAPI.Helpers
{
	public class ErrorHandlerMiddleware
	{
		private readonly RequestDelegate _next;

		public ErrorHandlerMiddleware(RequestDelegate next)
		{
			_next = next;
		}

		public async Task Invoke(HttpContext context)
		{
			try
			{
				await _next(context);
			}
			catch (Exception error)
			{
				HttpResponse? response = context.Response;

				response.ContentType = "application/json";

				switch (error)
				{
				   case KeyNotFoundException e:
						// not found error
						response.StatusCode = (int)HttpStatusCode.NotFound;
						break;
					//case AppException e:
					//    // custom application error
					//    response.StatusCode = (int)HttpStatusCode.BadRequest;
					//    break;
					case Exception e:
						// custom application error
						response.StatusCode = (int)HttpStatusCode.BadRequest;
						break;
					default:
						// unhandled error
						response.StatusCode = (int)HttpStatusCode.InternalServerError;
						break;
				}

				var result = JsonSerializer.Serialize(new { message = error?.Message });
			   
				await response.WriteAsync(result);
			}
		}
	}
}

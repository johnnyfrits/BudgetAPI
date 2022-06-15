namespace BudgetAPI.Authorization
{

	[AttributeUsage(AttributeTargets.Method)]
	public class AllowAnonymousAttribute : Attribute
	{ }
}
using System.Diagnostics;
using BudgetAPI.Authorization;
using BudgetAPI.Data;
using BudgetAPI.Helpers;
using BudgetAPI.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

int mode = 0;

//if (Debugger.IsAttached)
//{
//	mode = 1;
//}

if (mode == 0)
{
	//builder.Services.AddDbContext<BudgetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("AzureConnection")));
	builder.Services.AddDbContext<BudgetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("AzureConnection")));
}
else
{
	builder.Services.AddDbContext<BudgetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("LocalConnection")));
}

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(config =>
{
	config.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
	{
		Title = "BudgetAPI",
		Version = "v1"
	});
});
builder.Services.AddCors();
// Configure strongly typed settings object
builder.Services.Configure<AppSettings>(builder.Configuration.GetSection("AppSettings"));
// Configure DI for application services
builder.Services.AddScoped<IJwtUtils, JwtUtils>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IAccountService, AccountService>();
builder.Services.AddScoped<IAccountPostingService, AccountPostingService>();
builder.Services.AddScoped<IBudgetService, BudgetService>();
builder.Services.AddScoped<ICardService, CardService>();
builder.Services.AddScoped<ICardPostingService, CardPostingService>();
builder.Services.AddScoped<ICardReceiptService, CardReceiptService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IExpenseService, ExpenseService>();
builder.Services.AddScoped<IIncomeService, IncomeService>();
builder.Services.AddScoped<IPeopleService, PeopleService>();
builder.Services.AddHttpContextAccessor();


var app = builder.Build();

app.UseCors(options => options//.WithOrigins("http://localhost:4200")
					   .AllowAnyMethod()
					   .AllowAnyHeader()
					   .AllowAnyOrigin()
					   );

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// global error handler
app.UseMiddleware<ErrorHandlerMiddleware>();

// custom jwt auth middleware
app.UseMiddleware<JwtMiddleware>();

app.MapControllers();

app.Run();

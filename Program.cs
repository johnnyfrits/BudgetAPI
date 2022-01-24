using System.Diagnostics;
using BudgetAPI.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

int mode = 1;

if (Debugger.IsAttached)
{
	mode = 1;
}

if (mode == 0)
{
	builder.Services.AddDbContext<BudgetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("AzureConnection")));
}
else
{
	builder.Services.AddDbContext<BudgetContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("LocalConnection")));
}

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
builder.Services.AddSwaggerGen(config =>
{
	config.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
	{
		Title = "BudgetAPI",
		Version = "v1"
	});
});

builder.Services.AddCors();

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

app.UseAuthorization();	

app.MapControllers();

app.Run();

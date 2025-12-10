using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddDbContext<InsuranceDbContext>(options =>
    options.UseMySql("server=db;database=insurance;user=root;password=rootpass", new MySqlServerVersion(new Version(8,0,33))));
builder.Services.AddControllers();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder => builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();
app.UseCors("AllowAll");
app.MapControllers();
app.Run();

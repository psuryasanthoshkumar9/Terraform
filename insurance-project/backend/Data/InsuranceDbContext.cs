using Microsoft.EntityFrameworkCore;

public class InsuranceDbContext : DbContext
{
    public InsuranceDbContext(DbContextOptions<InsuranceDbContext> options) : base(options) { }

    public DbSet<Policy> Policies { get; set; }
}

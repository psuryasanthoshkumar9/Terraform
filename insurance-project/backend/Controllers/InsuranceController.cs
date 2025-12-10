using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class InsuranceController : ControllerBase
{
    private readonly InsuranceDbContext _context;
    public InsuranceController(InsuranceDbContext context) => _context = context;

    [HttpGet]
    public async Task<IActionResult> Get() => Ok(await _context.Policies.ToListAsync());

    [HttpPost]
    public async Task<IActionResult> Post(Policy policy)
    {
        _context.Policies.Add(policy);
        await _context.SaveChangesAsync();
        return Ok(policy);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Put(int id, Policy policy)
    {
        var existing = await _context.Policies.FindAsync(id);
        if (existing == null) return NotFound();

        existing.PolicyNumber = policy.PolicyNumber;
        existing.PolicyHolder = policy.PolicyHolder;
        existing.Premium = policy.Premium;
        existing.StartDate = policy.StartDate;
        existing.EndDate = policy.EndDate;

        await _context.SaveChangesAsync();
        return Ok(existing);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var policy = await _context.Policies.FindAsync(id);
        if (policy == null) return NotFound();

        _context.Policies.Remove(policy);
        await _context.SaveChangesAsync();
        return Ok();
    }
}

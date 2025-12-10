import { useState, useEffect } from "react";

export default function PolicyForm({ policy, onSaved }) {
  const [form, setForm] = useState(policy || {
    policyNumber: "", policyHolder: "", premium: "", startDate: "", endDate: ""
  });

  useEffect(() => { setForm(policy || form); }, [policy]);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    const method = form.id ? "PUT" : "POST";
    const url = form.id ? `http://localhost:5000/api/insurance/${form.id}` : "http://localhost:5000/api/insurance";
    await fetch(url, { method, headers: { "Content-Type": "application/json" }, body: JSON.stringify(form) });
    onSaved();
  };

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-2">
      <input placeholder="Policy Number" name="policyNumber" value={form.policyNumber} onChange={handleChange} />
      <input placeholder="Policy Holder" name="policyHolder" value={form.policyHolder} onChange={handleChange} />
      <input placeholder="Premium" name="premium" value={form.premium} onChange={handleChange} />
      <input type="date" name="startDate" value={form.startDate} onChange={handleChange} />
      <input type="date" name="endDate" value={form.endDate} onChange={handleChange} />
      <button type="submit">Save</button>
    </form>
  );
}

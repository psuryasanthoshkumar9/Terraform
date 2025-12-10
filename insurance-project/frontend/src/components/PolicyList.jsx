import { useEffect, useState } from "react";

export default function PolicyList({ onEdit }) {
  const [policies, setPolicies] = useState([]);

  const fetchPolicies = async () => {
    const res = await fetch("http://localhost:5000/api/insurance");
    const data = await res.json();
    setPolicies(data);
  };

  const deletePolicy = async (id) => {
    await fetch(`http://localhost:5000/api/insurance/${id}`, { method: "DELETE" });
    fetchPolicies();
  };

  useEffect(() => { fetchPolicies(); }, []);

  return (
    <table className="table-auto border-collapse border border-gray-500">
      <thead>
        <tr>
          <th>Policy Number</th><th>Holder</th><th>Premium</th><th>Start</th><th>End</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {policies.map(p => (
          <tr key={p.id}>
            <td>{p.policyNumber}</td>
            <td>{p.policyHolder}</td>
            <td>{p.premium}</td>
            <td>{p.startDate}</td>
            <td>{p.endDate}</td>
            <td>
              <button onClick={() => onEdit(p)}>Edit</button>
              <button onClick={() => deletePolicy(p.id)}>Delete</button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

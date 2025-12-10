import React, { useEffect, useState } from 'react'
fetchAll()
}


const edit = async (id)=>{
const res = await fetch(`${API}/api/policies/${id}`)
const data = await res.json()
setForm({customer_id: data.customer_id, policy_type: data.policy_type, premium: data.premium})
setEditing(id)
}


const remove = async id =>{
if(!confirm('Delete policy?')) return;
await fetch(`${API}/api/policies/${id}`,{method:'DELETE'})
fetchAll()
}


return (
<div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
<div className="card lg:col-span-1">
<h2 className="font-semibold mb-2">{editing? 'Edit Policy' : 'New Policy'}</h2>
<form onSubmit={submit} className="space-y-2">
<select className="w-full border rounded p-2" value={form.customer_id} onChange={e=>setForm({...form, customer_id: e.target.value})} required>
<option value="">-- Select Customer --</option>
{customers.map(c=> <option key={c.id} value={c.id}>{c.name} ({c.id})</option>)}
</select>
<input className="w-full border rounded p-2" placeholder="Policy Type" value={form.policy_type} onChange={e=>setForm({...form, policy_type:e.target.value})} required />
<input className="w-full border rounded p-2" placeholder="Premium" value={form.premium} onChange={e=>setForm({...form, premium:e.target.value})} required />
<div className="flex gap-2">
<button className="px-3 py-1 bg-green-600 text-white rounded">Save</button>
<button type="button" className="px-3 py-1 bg-gray-200 rounded" onClick={()=>{setForm({customer_id:'',policy_type:'',premium:''}); setEditing(null)}}>Clear</button>
</div>
</form>
</div>


<div className="card lg:col-span-2">
<h2 className="font-semibold mb-2">Policies</h2>
<table className="w-full text-left">
<thead><tr className="text-sm text-gray-600"><th>ID</th><th>Type</th><th>Premium</th><th>Customer</th><th>Actions</th></tr></thead>
<tbody>
{list.map(p=> (
<tr key={p.id} className="border-t">
<td className="py-2">{p.id}</td>
<td>{p.policy_type}</td>
<td>{p.premium}</td>
<td>{p.customer_name || p.customer_id}</td>
<td>
<button className="mr-2 text-blue-600" onClick={()=>edit(p.id)}>Edit</button>
<button className="text-red-600" onClick={()=>remove(p.id)}>Delete</button>
</td>
</tr>
))}
</tbody>
</table>
</div>
</div>
)
}
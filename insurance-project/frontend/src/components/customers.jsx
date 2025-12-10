import React, { useEffect, useState } from 'react'
if(!confirm('Delete?')) return;
await fetch(`${API}/api/customers/${id}`,{method:'DELETE'})
fetchList()
}


return (
<div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
<div className="card lg:col-span-1">
<h2 className="font-semibold mb-2">{editing? 'Edit Customer': 'New Customer'}</h2>
<form onSubmit={submit} className="space-y-2">
<input className="w-full border rounded p-2" placeholder="Name" value={form.name} onChange={e=>setForm({...form,name:e.target.value})} required />
<input className="w-full border rounded p-2" placeholder="Age" value={form.age} onChange={e=>setForm({...form,age:e.target.value})} />
<input className="w-full border rounded p-2" placeholder="Phone" value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})} />
<div className="flex gap-2">
<button className="px-3 py-1 bg-green-600 text-white rounded">Save</button>
<button type="button" className="px-3 py-1 bg-gray-200 rounded" onClick={()=>{setForm({name:'',age:'',phone:''}); setEditing(null)}}>Clear</button>
</div>
</form>
</div>


<div className="card lg:col-span-2">
<h2 className="font-semibold mb-2">Customers</h2>
{loading ? <div>Loading...</div> : (
<table className="w-full text-left">
<thead>
<tr className="text-sm text-gray-600"><th>Name</th><th>Age</th><th>Phone</th><th>Actions</th></tr>
</thead>
<tbody>
{list.map(c=> (
<tr key={c.id} className="border-t">
<td className="py-2">{c.name}</td>
<td>{c.age}</td>
<td>{c.phone}</td>
<td>
<button className="mr-2 text-blue-600" onClick={()=>edit(c.id)}>Edit</button>
<button className="text-red-600" onClick={()=>remove(c.id)}>Delete</button>
</td>
</tr>
))}
</tbody>
</table>
)}
</div>
</div>
)
}
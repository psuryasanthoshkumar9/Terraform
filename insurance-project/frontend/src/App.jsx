import React, { useState } from 'react'
import Customers from './components/Customers'
import Policies from './components/Policies'


const App = () => {
const [view, setView] = useState('customers')
return (
<div className="container">
<header className="flex items-center justify-between mb-6">
<h1 className="text-2xl font-bold">Insurance Admin</h1>
<nav className="space-x-2">
<button className={`px-3 py-1 rounded ${view==='customers'?'bg-blue-600 text-white':'bg-white'}`} onClick={()=>setView('customers')}>Customers</button>
<button className={`px-3 py-1 rounded ${view==='policies'?'bg-blue-600 text-white':'bg-white'}`} onClick={()=>setView('policies')}>Policies</button>
</nav>
</header>


<main>
{view === 'customers' ? <Customers /> : <Policies />}
</main>
</div>
)
}
export default App
import React, { useEffect, useState } from "react";

// API URL from .env (Vite injects at build time)
const API = import.meta.env.VITE_API_URL || "http://localhost:5000";

function StatCard({ title, value, icon }) {
  return (
    <div style={{background:"#fff",borderRadius:16,padding:16,boxShadow:"0 6px 18px rgba(0,0,0,0.08)"}}>
      <div style={{fontSize:18,color:"#333"}}>{title}</div>
      <div style={{fontSize:24,fontWeight:700}}>{value}</div>
    </div>
  );
}

export default function App() {
  const [students, setStudents] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [stats, setStats] = useState({ students: 0, teachers: 0 });
  const [showAdd, setShowAdd] = useState(false);
  const [form, setForm] = useState({ name: "", age: "", class: "" });

  async function fetchAll() {
    try {
      const [sRes, tRes, dRes] = await Promise.all([
        fetch(`${API}/students`).then(r => r.json()),
        fetch(`${API}/teachers`).then(r => r.json()),
        fetch(`${API}/dashboard`).then(r => r.json())
      ]);
      setStudents(sRes || []);
      setTeachers(tRes || []);
      setStats(dRes || {students:0, teachers:0});
    } catch (e) {
      console.error("fetchAll error", e);
    }
  }

  useEffect(() => { fetchAll(); }, []);

  async function handleAdd(e) {
    e.preventDefault();
    try {
      await fetch(`${API}/students`, {
        method: "POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify({ name: form.name, age: Number(form.age), class: form.class })
      });
      setForm({ name: "", age: "", class: "" });
      setShowAdd(false);
      await fetchAll();
    } catch (e) {
      console.error("add error", e);
    }
  }

  return (
    <div style={{padding:24,fontFamily:"Inter,system-ui,Arial"}}>
      <header style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:24}}>
        <h1>School Dashboard</h1>
        <div style={{color:"#666"}}>Admin panel • beautiful UI</div>
      </header>

      <div style={{display:"grid",gridTemplateColumns:"repeat(3,1fr)",gap:12,marginBottom:18}}>
        <StatCard title="Students" value={stats.students} icon="👩‍🎓" />
        <StatCard title="Teachers" value={stats.teachers} icon="🧑‍🏫" />
        <div style={{display:"flex",alignItems:"center",justifyContent:"flex-end"}}>
          <button onClick={()=>setShowAdd(!showAdd)} style={{background:"#5b21b6",color:"#fff",padding:"8px 14px",borderRadius:8}}>+ Add Student</button>
        </div>
      </div>

      {showAdd && (
        <form onSubmit={handleAdd} style={{background:"#fff",padding:12,borderRadius:8,marginBottom:18}}>
          <div style={{display:"flex",gap:8}}>
            <input value={form.name} onChange={e=>setForm(s=>({...s,name:e.target.value}))} placeholder="Name" style={{padding:8,flex:1}} />
            <input value={form.age} onChange={e=>setForm(s=>({...s,age:e.target.value}))} placeholder="Age" style={{padding:8,width:100}} />
            <input value={form.class} onChange={e=>setForm(s=>({...s,class:e.target.value}))} placeholder="Class" style={{padding:8,width:120}} />
            <button type="submit" style={{background:"#10b981",color:"#fff",padding:"8px 12px",borderRadius:6}}>Save</button>
          </div>
        </form>
      )}

      <section style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:12}}>
        <div style={{background:"#fff",padding:12,borderRadius:8}}>
          <h3>Students</h3>
          <div>
            {students.map(s=>(
              <div key={s.id} style={{display:"flex",justifyContent:"space-between",padding:8,borderBottom:"1px solid #eee"}}>
                <div>
                  <div style={{fontWeight:600}}>{s.name}</div>
                  <div style={{color:"#666"}}>Age: {s.age} • Class: {s.class}</div>
                </div>
                <div style={{color:"#999"}}>ID {s.id}</div>
              </div>
            ))}
          </div>
        </div>

        <div style={{background:"#fff",padding:12,borderRadius:8}}>
          <h3>Teachers</h3>
          <div>
            {teachers.map(t=>(
              <div key={t.id} style={{display:"flex",justifyContent:"space-between",padding:8,borderBottom:"1px solid #eee"}}>
                <div>
                  <div style={{fontWeight:600}}>{t.name}</div>
                  <div style={{color:"#666"}}>Subject: {t.subject}</div>
                </div>
                <div style={{color:"#999"}}>ID {t.id}</div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );
}

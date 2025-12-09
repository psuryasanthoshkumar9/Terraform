import React, { useEffect, useState } from "react";

// Use VITE_API_URL from frontend/.env, fallback to localhost for local dev
const API = import.meta.env.VITE_API_URL || "http://localhost:5000";

function StatCard({ title, value, icon }) {
  return (
    <div className="bg-white rounded-2xl shadow p-5 flex items-center gap-4">
      <div className="bg-indigo-100 rounded-full w-12 h-12 flex items-center justify-center text-indigo-600">
        {icon}
      </div>
      <div>
        <div className="text-sm text-slate-500">{title}</div>
        <div className="text-2xl font-semibold">{value}</div>
      </div>
    </div>
  );
}

export default function App() {
  const [students, setStudents] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [stats, setStats] = useState({ students: 0, teachers: 0 });
  const [showAdd, setShowAdd] = useState(false);
  const [form, setForm] = useState({ name: "", age: "", class: "" });

  // Fetch data from backend
  useEffect(() => {
    fetch(`${API}/students`).then((r) => r.json()).then(setStudents).catch(console.error);
    fetch(`${API}/teachers`).then((r) => r.json()).then(setTeachers).catch(console.error);
    fetch(`${API}/dashboard`).then((r) => r.json()).then(setStats).catch(console.error);
  }, []);

  function handleAdd(e) {
    e.preventDefault();
    fetch(`${API}/students`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: form.name, age: Number(form.age), class: form.class }),
    })
      .then(() => {
        setForm({ name: "", age: "", class: "" });
        setShowAdd(false);
        return fetch(`${API}/students`).then((r) => r.json()).then(setStudents);
      })
      .catch(console.error);
  }

  return (
    <div className="min-h-screen p-6 bg-gray-100">
      <div className="max-w-6xl mx-auto">
        <header className="flex items-center justify-between mb-8">
          <h1 className="text-3xl font-bold text-slate-700">School Dashboard</h1>
          <div className="text-sm text-slate-500">Admin panel • beautiful UI</div>
        </header>

        <div className="grid grid-cols-3 gap-4 mb-6">
          <StatCard title="Students" value={stats.students} icon="👩‍🎓" />
          <StatCard title="Teachers" value={stats.teachers} icon="🧑‍🏫" />
          <div className="flex items-center gap-4">
            <button
              onClick={() => setShowAdd(!showAdd)}
              className="ml-auto bg-indigo-600 text-white px-4 py-2 rounded-lg shadow"
            >
              + Add Student
            </button>
          </div>
        </div>

        {showAdd && (
          <form className="bg-white p-4 rounded-lg shadow mb-6" onSubmit={handleAdd}>
            <div className="flex gap-4">
              <input
                value={form.name}
                onChange={(e) => setForm((s) => ({ ...s, name: e.target.value }))}
                placeholder="Name"
                className="border p-2 rounded w-1/3"
              />
              <input
                value={form.age}
                onChange={(e) => setForm((s) => ({ ...s, age: e.target.value }))}
                placeholder="Age"
                className="border p-2 rounded w-1/6"
              />
              <input
                value={form.class}
                onChange={(e) => setForm((s) => ({ ...s, class: e.target.value }))}
                placeholder="Class"
                className="border p-2 rounded w-1/6"
              />
              <button type="submit" className="bg-green-600 text-white px-4 rounded">
                Save
              </button>
            </div>
          </form>
        )}

        <section className="grid grid-cols-2 gap-6">
          <div className="bg-white p-4 rounded-lg shadow">
            <h2 className="text-xl font-semibold mb-3">Students</h2>
            <div className="space-y-2">
              {students.map((s) => (
                <div key={s.id} className="flex items-center justify-between border rounded p-3">
                  <div>
                    <div className="font-medium">{s.name}</div>
                    <div className="text-sm text-slate-500">
                      Age: {s.age} • Class: {s.class}
                    </div>
                  </div>
                  <div className="text-sm text-slate-400">ID {s.id}</div>
                </div>
              ))}
            </div>
          </div>

          <div className="bg-white p-4 rounded-lg shadow">
            <h2 className="text-xl font-semibold mb-3">Teachers</h2>
            <div className="space-y-2">
              {teachers.map((t) => (
                <div key={t.id} className="flex items-center justify-between border rounded p-3">
                  <div>
                    <div className="font-medium">{t.name}</div>
                    <div className="text-sm text-slate-500">Subject: {t.subject}</div>
                  </div>
                  <div className="text-sm text-slate-400">ID {t.id}</div>
                </div>
              ))}
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

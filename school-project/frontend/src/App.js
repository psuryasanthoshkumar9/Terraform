import React, { useEffect, useState } from "react";

function App() {
  const [students, setStudents] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/students")
      .then(res => res.json())
      .then(data => setStudents(data))
      .catch(err => console.error(err));
  }, []);

  return (
    <div>
      <h1>School Students</h1>
      <ul>
        {students.map(student => (
          <li key={student.id}>{student.name} - {student.age}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;

import { useState } from "react";
import PolicyList from "./components/PolicyList";
import PolicyForm from "./components/PolicyForm";

function App() {
  const [editing, setEditing] = useState(null);
  const [refresh, setRefresh] = useState(false);

  return (
    <div className="p-4">
      <h1 className="text-xl font-bold">Insurance Management</h1>
      <PolicyForm policy={editing} onSaved={() => { setEditing(null); setRefresh(!refresh); }} />
      <PolicyList key={refresh} onEdit={setEditing} />
    </div>
  );
}

export default App;

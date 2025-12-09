import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css"; // optional, if not present it's okay

const root = createRoot(document.getElementById("root"));
root.render(<App />);

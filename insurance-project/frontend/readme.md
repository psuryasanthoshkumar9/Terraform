# Frontend (Part 3)


1. Place this `frontend/` folder inside your project root `insurance-project/`.
2. The frontend expects backend API at `http://localhost:5000` by default. If your backend is running on a different host/port, change `VITE_API_BASE` in a `.env` file (Vite) or change the `API` constant inside components.
3. Run using docker-compose from project root:


```bash
docker compose up --build
```


Open http://localhost:3000 (compose exposed port) to view the UI.




// End of frontend code bundle
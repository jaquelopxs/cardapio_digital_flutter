import express from "express";
import http from "http";
import { Server } from "socket.io";
import cors from "cors";
import dotenv from "dotenv";
import { pool } from "./src/config/db.js";

dotenv.config();

const app = express();
const server = http.createServer(app);

export const io = new Server(server, {
  cors: {
    origin: "http://localhost:3001",
    methods: ["GET", "POST", "PUT"]
  }
});

app.use(cors());
app.use(express.json());

// ROTAS
import authRoutes from "./src/routes/authRoutes.js";
import produtosRoutes from "./src/routes/produtosRoutes.js";
import pedidosRoutes from "./src/routes/pedidosRoutes.js";

app.use("/auth", authRoutes);
app.use("/produtos", produtosRoutes);
app.use("/pedidos", pedidosRoutes);

// TESTE
app.get("/", (req, res) => res.send("API rodando"));

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log("Servidor rodando na porta " + PORT);
});

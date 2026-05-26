import express from "express";
import http from "http";
import { Server } from "socket.io";
import cors from "cors";
import dotenv from "dotenv";

// Routes
import authRoutes from "./src/routes/authRoutes.js";
import produtosRoutes from "./src/routes/produtosRoutes.js";
import pedidosRoutes from "./src/routes/pedidosRoutes.js";

dotenv.config();

const app = express();
const server = http.createServer(app);

// Socket.io setup
export const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST", "PUT"]
  }
});

// Middleware
app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));
app.use(express.json());

// Request Logger
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Routes implementation
app.use("/auth", authRoutes);
app.use("/produtos", produtosRoutes);
app.use("/pedidos", pedidosRoutes);

// Base route
app.get("/", (req, res) => res.json({ message: "API Cardápio Digital rodando" }));

// About endpoint (RF004)
app.get("/info", (req, res) => {
  res.json({
    projeto: "Cardápio Digital",
    objetivo: "Permitir que clientes visualizem produtos e realizem pedidos.",
    instituicao: "Prática Extensionista VIII",
    versao: "1.0.0"
  });
});

// Error Handling Middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Erro interno no servidor" });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Conectado ao banco: ${process.env.DB_NAME}`);
});

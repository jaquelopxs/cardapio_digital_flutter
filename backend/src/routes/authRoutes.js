import express from "express";
import { pool } from "../config/db.js";
import { compararSenha } from "../../banco/criptografia.js";
import jwt from "jsonwebtoken";

const router = express.Router();

router.post("/login", async (req, res) => {
  const { email, senha } = req.body;

  try {
    const result = await pool.query("SELECT * FROM admin WHERE email = $1", [email]);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: "Usuário não encontrado" });
    }

    const admin = result.rows[0];
    
    // Suporta tanto senha pura quanto hash para o admin do SQL dump
    let senhaValida = false;
    if (senha === admin.senha) {
      senhaValida = true;
    } else {
      senhaValida = await compararSenha(senha, admin.senha);
    }

    if (!senhaValida) {
      return res.status(401).json({ error: "Senha incorreta" });
    }

    const token = jwt.sign({ id: admin.id, email: admin.email }, process.env.JWT_SECRET || "chave", {
      expiresIn: "24h",
    });

    res.json({ token, admin: { id: admin.id, nome: admin.nome, email: admin.email } });
  } catch (err) {
    res.status(500).json({ error: "Erro no servidor" });
  }
});

export default router;

import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;

<<<<<<< HEAD
// Se tiver DATABASE_URL (Supabase/Render), usa ela.
// Caso contrário, usa as variáveis separadas (ambiente local).
export const pool = process.env.DATABASE_URL
  ? new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: { rejectUnauthorized: false }, // necessário para Supabase
    })
  : new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT,
    });
=======
export const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});
>>>>>>> 72bbee81325504357f9041a0baafdc846eaa2c26

pool.on('connect', () => {
  console.log('Base de dados conectada com sucesso!');
});

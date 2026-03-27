import nodemailer from 'nodemailer';

export const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com", // Ou seu provedor
  port: 587,
  secure: false,
  auth: {
    user: "seu-email@gmail.com",
    pass: "sua-senha-de-app" 
  }
});
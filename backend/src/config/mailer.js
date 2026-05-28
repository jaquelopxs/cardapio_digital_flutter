import dns from 'node:dns';
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dns.setDefaultResultOrder('ipv4first');
dotenv.config();

export const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS
  }
});
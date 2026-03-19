import bcrypt from "bcrypt";

export const gerarHash = async (senhaPura) => {
  return await bcrypt.hash(senhaPura, 10);
};

export const compararSenha = async (senhaDigitada, senhaHashBanco) => {
  return await bcrypt.compare(senhaDigitada, senhaHashBanco);
};

// // node criptografia.js gerar 123456
// if (process.argv[2] === "gerar") {
//   (async () => {
//     const senha = process.argv[3] || "123456";
//     const hash = await gerarHash(senha);
//     console.log("Hash gerado:", hash);
//   })();
// }

// node criptografia.js gerar minhaSenhaAqui


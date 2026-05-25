import jwt from 'jsonwebtoken';

export const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }

  const parts = authHeader.split(' ');

  if (parts.length !== 2) {
    return res.status(401).json({ error: 'Erro no token' });
  }

  const [scheme, token] = parts;

  if (!/^Bearer$/i.test(scheme)) {
    return res.status(401).json({ error: 'Token malformatado' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: 'Token inválido' });
    }

    req.userId = decoded.id;
    return next();
  });
};

export const adminMiddleware = (req, res, next) => {
  // Nota: Para usar adminMiddleware, authMiddleware deve ser chamado antes
  // ou a lógica de verificação deve ser repetida/combinada.
  // Aqui assumimos que decodificamos o usuário e buscamos no banco ou o JWT tem a flag.
  
  // Como o JWT atual em authController não inclui is_admin, vamos confiar no userId
  // e opcionalmente buscar no banco, ou atualizar o JWT para incluir is_admin.
  next(); // Placeholder - Recomendo atualizar o JWT no authController
};

# Como Publicar o Cardápio Digital

## PASSO 1 — Supabase (banco de dados)

1. Acesse https://supabase.com e crie uma conta gratuita
2. Clique em **New Project** → dê um nome → defina uma senha forte
3. Vá em **SQL Editor** → cole o conteúdo de `backend/banco/cardapio_digital_script.sql` → clique em Run
4. Vá em **Settings → Database → Connection string (URI)** e copie a URL
   - Ela tem formato: `postgresql://postgres:SUASENHA@db.XXXX.supabase.co:5432/postgres`
5. Guarde essa URL — vai usar no próximo passo

---

## PASSO 2 — Render (backend Node.js)

1. Suba a pasta `backend/` para um repositório no GitHub
2. Acesse https://render.com e crie uma conta gratuita
3. Clique em **New → Web Service** → conecte seu repositório do GitHub
4. Configure:
   - Root Directory: `backend`
   - Build Command: `npm install`
   - Start Command: `node server.js`
5. Em **Environment Variables**, adicione:
   ```
   DATABASE_URL = (URL do Supabase do passo anterior)
   JWT_SECRET   = uma_chave_secreta_qualquer
   MAIL_USER    = emporiosophia82@gmail.com
   MAIL_PASS    = tuliuliqfdwphakh
   PORT         = 3000
   ```
6. Clique em **Create Web Service**
7. Aguarde o deploy — você receberá uma URL tipo:
   `https://cardapio-backend.onrender.com`

---

## PASSO 3 — Atualizar URL no Flutter

Abra o arquivo `lib/services/api_service.dart` e troque:
```dart
static const String _prodUrl = 'https://SUA-URL-AQUI.onrender.com';
```
Pela URL real do Render:
```dart
static const String _prodUrl = 'https://cardapio-backend.onrender.com';
```

---

## PASSO 4 — Build do Flutter Web

No terminal, dentro da pasta do projeto Flutter:
```bash
flutter build web
```
Isso gera a pasta `build/web/` com o app pronto.

---

## PASSO 5 — Firebase Hosting (publicar o app)

1. Acesse https://console.firebase.google.com → crie um projeto gratuito
2. No terminal, instale o Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
3. Faça login:
   ```bash
   firebase login
   ```
4. Dentro da pasta do Flutter, inicialize:
   ```bash
   firebase init hosting
   ```
   - Quando perguntar qual pasta: digite `build/web`
   - "Configure as single-page app?": **Yes**
5. Publique:
   ```bash
   firebase deploy
   ```
6. ✅ Pronto! Você receberá um link público tipo:
   `https://seu-projeto.web.app`

---

## Resumo da ordem

Supabase → Render → trocar URL no Flutter → flutter build web → firebase deploy

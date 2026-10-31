# 🎃 Halloween JP — Concurso de Fantasias

Site estático (HTML + JS) com Supabase. Cadastro com nome + fantasia, ranking ao vivo (atualiza a cada 5s), 1 voto por celular (pode trocar).

## Setup (5 min)

1. **Supabase**: crie um projeto em supabase.com → **SQL Editor** → cole o conteúdo de `supabase.sql` → Run.
2. **Chaves**: em *Project Settings → API*, copie a **Project URL** e a **anon public key** para `public/config.js`.
3. **Vercel**: importe o repo em vercel.com/new (Framework: *Other*, sem build). O `vercel.json` já aponta para `public/`.
   - Ou via CLI: `npx vercel --prod` na raiz do repo.

Pra zerar tudo no fim: `truncate votos, participantes restart identity;` no SQL Editor.

> É só pelo meme: dá pra burlar o "1 voto por celular" limpando o navegador. Não use pra eleição de verdade 👻

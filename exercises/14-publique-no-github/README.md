# Desafio 14 — Publique no GitHub

⏱ 5 minutos · Módulo 6: Remotos

## Objetivo

Fazer o primeiro `push` para um remoto de verdade: um repositório **seu** no GitHub, criado agora.

## Onde

```bash
cd ~/labs/14-publique-no-github
```

## Estado inicial

Um repositório local com o livro de receitas e um README, mas **sem remoto** (`git remote -v` não mostra nada). Ele só existe neste Codespace.

## Tarefa

1. Crie um arquivo `aprendizados.md` com **três** coisas que você aprendeu hoje. Formato livre; uma lista serve. Faça commit:

   ```bash
   git add aprendizados.md
   git commit -m "Adiciona meus aprendizados do curso"
   ```

2. No GitHub, crie um repositório vazio: clique em **+** (canto superior direito) → **New repository**. Nome: `livro-de-receitas`. **Não** marque "Add a README" nem .gitignore nem licença, para que ele nasça vazio. Clique em **Create repository**.

3. O GitHub mostra uma página com instruções para "push an existing repository". Copie a URL do repositório e ligue o remoto:

   ```bash
   git remote add origin https://github.com/<seu-usuario>/livro-de-receitas.git
   git remote -v
   ```

4. Publique. O `-u` liga a `main` local à `main` do GitHub, para que os próximos `push` e `pull` saibam para onde ir. Se o VS Code pedir para autorizar o acesso ao GitHub, aceite:

   ```bash
   git push -u origin main
   ```

5. Atualize a página do repositório no navegador e encontre suas receitas, o `aprendizados.md` e o commit. Depois confira localmente:

   ```bash
   git status          # up to date with 'origin/main'
   ```

## Verificação

```bash
check.sh 14
```

## Dicas

- O nome do remoto, `origin`, é só uma convenção. Poderia ser qualquer nome.
- `git remote -v` mostra para onde `origin` aponta. Se errou a URL: `git remote set-url origin <url-certa>`.

# Desafio 14 — Publique no GitHub

⏱ 5 minutos · Módulo 6: Remotos

## Objetivo

Fazer o primeiro `push` para um repositório criado na **sua conta** do GitHub.

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

2. No GitHub, clique em **+** (canto superior direito) → **New repository** e use o nome `livro-de-receitas`. O repositório precisa estar vazio: **não** marque "Add a README", .gitignore ou licença. Clique em **Create repository**.

3. O GitHub mostra uma página com instruções para "push an existing repository". Copie a URL do repositório e ligue o remoto:

   ```bash
   git remote add origin https://github.com/<seu-usuario>/livro-de-receitas.git
   git remote -v
   ```

4. Publique o repositório. O `-u` associa a `main` local à `main` do GitHub, definindo a branch remota usada nos próximos `push` e `pull`. Se o VS Code pedir para autorizar o acesso ao GitHub, aceite:

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

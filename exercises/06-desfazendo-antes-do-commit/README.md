# Desafio 6 — Desfazendo antes do commit

⏱ 5 minutos · Módulo 3b: Desfazendo

## Objetivo

Recuperar um arquivo estragado e tirar da staging area um arquivo que entrou por engano. Tudo isso **antes** de qualquer commit.

## Onde

```bash
cd ~/labs/06-desfazendo-antes-do-commit
```

## Estado inicial

Rode `git status` e `git diff`. Aconteceram dois acidentes:

- `bolo-de-cenoura.md` foi sobrescrito e ficou com três linhas de "ops"; a mudança está só na árvore de trabalho;
- `notas-pessoais.md` (com a senha do wifi!) foi adicionado à staging area por engano.

## Tarefa

1. Descarte a mudança no bolo, trazendo de volta a versão do último commit:

   ```bash
   git restore bolo-de-cenoura.md
   cat bolo-de-cenoura.md
   ```

2. Tire as notas da staging area, mas sem apagar o arquivo do disco:

   ```bash
   git restore --staged notas-pessoais.md
   git status
   ```

   O arquivo continua na pasta, agora como *untracked*. Não é problema: ele simplesmente não vai para o commit.

3. **Não faça commit.** O desafio termina com a árvore de trabalho igual ao último commit, mais o arquivo de notas não rastreado.

## Verificação

```bash
check.sh 06
```

## Atenção

`git restore <arquivo>` **joga fora** o que estava na árvore de trabalho, sem perguntar. Antes de usar, olhe o `git diff` e tenha certeza de que não quer aquilo.

## Missão extra

Adicione `notas-pessoais.md` a um `.gitignore` para que ele nunca mais apareça como não rastreado.

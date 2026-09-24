# Desafio 6 — Desfazendo antes do commit

⏱ 5 minutos · Módulo 3b: Desfazendo

## Objetivo

Recuperar o conteúdo de um arquivo alterado por engano e tirar outro arquivo da staging area, **sem criar um commit**.

## Onde

```bash
cd ~/labs/06-desfazendo-antes-do-commit
```

## Estado inicial

Rode `git status` e `git diff` para conferir as duas alterações feitas por engano:

- `bolo-de-cenoura.md` foi sobrescrito e ficou com três linhas de "ops"; a mudança está só na árvore de trabalho;
- `notas-pessoais.md`, que contém a senha do Wi-Fi, foi adicionado à staging area por engano.

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

   O arquivo continua na pasta como *untracked* (não rastreado), fora da staging area.

3. **Não faça commit.** O desafio termina com a árvore de trabalho igual ao último commit, mais o arquivo de notas não rastreado.

## Verificação

```bash
check.sh 06
```

## Atenção

`git restore <arquivo>` **descarta as alterações** na árvore de trabalho sem pedir confirmação. Antes de usar, confira o `git diff` e confirme que quer descartar essas mudanças.

## Missão extra

Adicione `notas-pessoais.md` a um `.gitignore` para que ele nunca mais apareça como não rastreado.

# Desafio 12 — O colega invisível

⏱ 6 minutos · Módulo 6: Remotos

## Objetivo

Praticar a sincronização com um repositório remoto: alguém publica antes de você, seu `push` é rejeitado e você precisa fazer `pull` antes de tentar o `push` novamente.

## Onde

```bash
cd ~/labs/12-o-colega-invisivel
```

## Estado inicial

Este repositório é um **clone**. O remoto `origin` é um repositório *bare* local (não precisa de internet nem de senha). Veja:

```bash
git remote -v
git log --oneline
git status          # "Your branch is up to date with 'origin/main'"
```

Há um colega de equipe trabalhando no mesmo projeto. Ele é simulado pelo comando `colega.sh`.

## Tarefa

1. Acrescente um dia ao `cardapio.md` e faça commit. Veja que `git status` agora diz que você está **1 commit à frente** de `origin/main`:

   ```bash
   git commit -am "Adiciona a quinta ao cardápio"
   git status
   ```

2. Enquanto isso, o colega publica uma mudança em `avisos.md`:

   ```bash
   colega.sh 12
   ```

3. Tente publicar o seu commit. O Git **rejeita**: o remoto tem um commit que você não tem, e o Git não vai jogá-lo fora:

   ```bash
   git push
   ```

4. Traga o commit do colega e integre ao seu. Como os arquivos são diferentes, não há conflito; o Git cria um merge commit (salve e feche o editor):

   ```bash
   git pull
   git log --oneline --graph
   ```

5. Publique os commits integrados e confira a sincronização:

   ```bash
   git push
   git status          # up to date
   ```

## Verificação

```bash
check.sh 12
```

## Dicas

- `origin/main` é uma **referência local** ao último estado conhecido da `main` no remoto. Ela é atualizada com `fetch`, `pull` ou `push`.
- `git pull` = `git fetch` + `git merge origin/main`.

## Missão extra

Consulte o histórico e as branches conhecidas do remoto com `git log --oneline origin/main` e `git branch -r`. Depois rode `git fetch` e repare que nada muda, porque você já está sincronizado.

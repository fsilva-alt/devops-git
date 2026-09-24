# Desafio 10 — Guardando para depois

⏱ 5 minutos · Módulo 4b: Stash · desafio elástico

## Objetivo

Interromper um trabalho pela metade para atender um pedido urgente em outra branch, e depois retomar de onde parou, com `git stash`.

## Onde

```bash
cd ~/labs/10-guardando-para-depois
```

## Estado inicial

Você está na branch `feature/sopas`, com `sopas.md` no meio de uma edição (veja `git status` e `git diff`). Chega o pedido urgente: na `main`, o bolo de cenoura manda assar a **1800 graus**. Precisa virar 180 antes que alguém queime a cozinha.

Tente ir para a `main` agora:

```bash
git switch main
```

O Git recusa: sua mudança em `sopas.md` seria perdida na troca. Você não quer commitar uma receita pela metade, então...

## Tarefa

1. Guarde o trabalho em andamento na "gaveta":

   ```bash
   git stash
   git status        # árvore limpa
   git stash list    # a gaveta tem um item
   ```

2. Vá para a `main`, corrija a temperatura em `bolo-de-cenoura.md` e faça commit:

   ```bash
   git switch main
   # edite: 1800 -> 180
   git commit -am "Corrige temperatura do forno do bolo"
   ```

3. Volte para a sua branch e recupere o trabalho:

   ```bash
   git switch feature/sopas
   git stash pop
   git diff          # as batatas voltaram
   git stash list    # gaveta vazia
   ```

## Verificação

```bash
check.sh 10
```

## Dicas

- `stash pop` recupera **e** remove da gaveta. `stash apply` recupera e mantém.
- Por padrão o stash não guarda arquivos novos (untracked). Use `git stash -u` para incluí-los.

## Missão extra

Guarde dois stashes com mensagens (`git stash push -m "descrição"`), liste com `git stash list` e recupere um específico com `git stash pop stash@{1}`.

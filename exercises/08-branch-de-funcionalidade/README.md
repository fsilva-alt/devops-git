# Desafio 8 — Branch de funcionalidade

⏱ 5 minutos · Módulo 4: Branches

## Objetivo

Trabalhar numa branch separada, ver que a `main` não é afetada, e integrar com um merge **fast-forward**.

## Onde

```bash
cd ~/labs/08-branch-de-funcionalidade
```

## Estado inicial

Um repositório com dois commits na `main`. Veja com `git log --oneline` e `git branch`.

## Tarefa

1. Crie a branch e mude para ela de uma vez:

   ```bash
   git switch -c feature/sobremesas
   git branch
   ```

2. Crie `sobremesas.md` com um título e um item, e faça commit. Depois acrescente outro item e faça um segundo commit:

   ```bash
   git add sobremesas.md
   git commit -m "Cria lista de sobremesas"
   # edite o arquivo...
   git commit -am "Adiciona mousse à lista"
   ```

3. Volte para a `main` e olhe a pasta. O arquivo "sumiu":

   ```bash
   git switch main
   ls
   ```

   Ele não foi apagado: está nos commits da outra branch. A `main` simplesmente ainda não os tem.

4. Faça o merge. Como a `main` não recebeu nenhum commit enquanto isso, o Git só **avança o ponteiro** (fast-forward), sem criar um commit de merge:

   ```bash
   git merge feature/sobremesas
   git log --oneline --graph
   ls
   ```

## Verificação

```bash
check.sh 08
```

## Missão extra

Veja para onde cada branch aponta com `git log --oneline --all --decorate`. Repare que `main` e `feature/sobremesas` apontam para o **mesmo** commit depois do fast-forward.

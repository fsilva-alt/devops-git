# Desafio 2 — Registrando mudanças

⏱ 6 minutos · Módulo 2: Registrando mudanças

## Objetivo

Praticar o ciclo **editar → `git diff` → `git add` → `git diff --staged` → `git commit`** e escrever mensagens de commit que expliquem a mudança.

## Onde

```bash
cd ~/labs/02-registrando-mudancas
```

## Estado inicial

Um repositório com um único commit e as três receitas.

## Tarefa

1. Abra uma receita no editor e mude alguma coisa (acrescente um ingrediente, ajuste uma quantidade, corrija um passo).

2. Veja a diferença entre a árvore de trabalho e o último commit:

   ```bash
   git diff
   ```

3. Coloque a mudança na staging area e compare de novo. Agora `git diff` não mostra nada, mas `git diff --staged` mostra o que vai entrar no commit:

   ```bash
   git add bolo-de-cenoura.md
   git diff
   git diff --staged
   ```

4. Faça o commit com uma mensagem que descreva **o que** mudou:

   ```bash
   git commit -m "Adiciona canela ao bolo de cenoura"
   ```

5. Repita até ter **três commits novos**, cada um com uma mensagem diferente e descritiva.

6. Veja o histórico resumido:

   ```bash
   git log --oneline
   ```

## Verificação

```bash
check.sh 02
```

## Dicas

- Uma boa mensagem completa a frase "Este commit...": *Adiciona*, *Corrige*, *Remove*, *Ajusta*.
- `git commit -am "..."` faz `add` e `commit` de uma vez, mas só para arquivos que o Git **já rastreia**.

## Missão extra

Rode `git log -p` e leia os diffs de cada commit. Depois experimente `git log --stat`.

# Desafio 13 — Conflito com o colega

⏱ 7 minutos · Módulo 6: Remotos

## Objetivo

Consultar as mudanças do remoto com `git fetch` **antes** de integrá-las e resolver um conflito entre a sua alteração e a de um colega.

## Onde

```bash
cd ~/labs/13-conflito-com-o-colega
```

## Estado inicial

Um clone de outro repositório bare, com as três receitas. Você e o colega vão mexer na **mesma linha**.

## Tarefa

1. Mude o preço sugerido do bolo em `bolo-de-cenoura.md` para **R$ 50,00** e faça commit:

   ```bash
   git commit -am "Atualiza preço do bolo para R$ 50,00"
   ```

2. O colega, sem saber, muda o mesmo preço para outro valor e publica:

   ```bash
   colega.sh 13
   ```

3. Use `git fetch` para baixar as mudanças do colega e examine-as **antes de integrar**:

   ```bash
   git fetch
   git status                          # 1 à frente, 1 atrás: divergiu
   git log --oneline main..origin/main # o que o colega fez
   git diff main origin/main           # o que muda
   ```

4. Agora integre. Vai dar conflito, porque os dois mudaram a mesma linha:

   ```bash
   git pull
   ```

5. Resolva como no desafio 11: no trecho em conflito de `bolo-de-cenoura.md`, mantenha apenas a linha com o preço final e remova os marcadores. Depois, conclua o merge:

   ```bash
   git add bolo-de-cenoura.md
   git commit
   ```

6. Publique a versão reconciliada:

   ```bash
   git push
   ```

## Verificação

```bash
check.sh 13
```

## Dicas

- `main..origin/main` significa "commits que estão em `origin/main` mas não em `main`". Inverta (`origin/main..main`) para ver o que você tem e o remoto não.
- `fetch` nunca altera seus arquivos; ele permite consultar as mudanças do remoto antes de integrá-las.

## Missão extra

Como você explicaria ao colega a escolha do preço final? Registre a decisão na mensagem do merge commit (`git commit --amend` logo após o merge, **antes** do push) e confira com `git log -1`.

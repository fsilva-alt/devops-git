# Desafio 13 — Conflito com o colega

⏱ 7 minutos · Módulo 6: Remotos

## Objetivo

Espiar o que chegou no remoto com `git fetch` **antes** de integrar, e resolver um conflito que veio de outra pessoa.

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

3. Desta vez, em vez de `pull` direto, primeiro **só baixe** o que há de novo e olhe antes de integrar:

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

5. Resolva como no desafio 11: edite `bolo-de-cenoura.md` deixando só o preço final, depois:

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
- `fetch` nunca altera seus arquivos; é sempre seguro rodar.

## Missão extra

Numa equipe de verdade, quem decide o preço final? Escreva a decisão na mensagem do merge commit (`git commit --amend` logo após o merge, **antes** do push) e veja com `git log -1`.

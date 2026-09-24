# Desafio 11 — Resolva o conflito

⏱ 7 minutos · Módulo 5: Conflitos

## Objetivo

Resolver um conflito de merge: ler os marcadores, escolher o conteúdo final e concluir o merge.

## Onde

```bash
cd ~/labs/11-resolva-o-conflito
```

## Estado inicial

Você está na `main`. A `main` e a branch `ajuste-preco` mudaram **a mesma linha** de `bolo-de-cenoura.md` (o preço sugerido), cada uma para um valor diferente. Veja:

```bash
git log --oneline --graph --all
git diff main ajuste-preco
```

## Tarefa

1. Tente o merge. O Git avisa do conflito e para no meio:

   ```bash
   git merge ajuste-preco
   git status
   ```

2. Abra `bolo-de-cenoura.md`. O trecho em conflito está assim:

   ```
   <<<<<<< HEAD
   Preço sugerido: R$ 42,00
   =======
   Preço sugerido: R$ 48,00
   >>>>>>> ajuste-preco
   ```

   Entre `<<<<<<<` e `=======` está a versão da sua branch (`HEAD`, a `main`). Entre `=======` e `>>>>>>>` está a versão que está chegando.

3. **Escolha** o preço final: um dos dois valores ou um terceiro. No trecho em conflito, deixe **uma única linha de preço**, sem nenhum marcador. Você pode usar os botões do VS Code ou editar o trecho manualmente.

4. Diga ao Git que resolveu e conclua o merge:

   ```bash
   git add bolo-de-cenoura.md
   git commit
   ```

   O editor abre com a mensagem de merge pronta; salve e feche.

5. Confira: `git log --oneline --graph` mostra o merge commit, e `git status` está limpo.

## Verificação

```bash
check.sh 11
```

## Missão extra

Para praticar o cancelamento de um merge, recrie o cenário e use `git merge --abort`:

```bash
reset.sh 11
cd ~/labs/11-resolva-o-conflito
git merge ajuste-preco      # conflito de novo
git merge --abort           # volta ao estado anterior ao merge
git status                  # limpo
```

Depois resolva de novo para deixar o desafio concluído.

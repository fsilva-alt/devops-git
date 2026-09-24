# Desafio 9 — Caminhos que divergem

⏱ 6 minutos · Módulo 4: Branches

## Objetivo

Fazer um merge de **três vias**: quando as duas branches receberam commits depois de se separarem, o Git precisa criar um *merge commit* para juntá-las.

## Onde

```bash
cd ~/labs/09-caminhos-que-divergem
```

## Estado inicial

Você está na `main`. A branch `feature/bebidas` tem dois commits que a `main` não tem, e a `main` tem um commit que a `feature/bebidas` não tem. Veja a bifurcação:

```bash
git log --oneline --graph --all
```

## Tarefa

1. Faça o merge. Desta vez o Git não consegue só avançar o ponteiro; ele cria um commit de merge e abre o editor com a mensagem sugerida. **Salve e feche o arquivo** (feche a aba no VS Code) para concluir:

   ```bash
   git merge feature/bebidas
   ```

2. Veja o resultado. O merge commit tem **dois pais**:

   ```bash
   git log --oneline --graph --all
   ```

3. Apague a branch agora que seus commits foram integrados à `main`:

   ```bash
   git branch -d feature/bebidas
   git branch
   ```

## Verificação

```bash
check.sh 09
```

## Dicas

- `git branch -d` só apaga branches já integradas. Se o Git recusar, confira quais commits ainda faltam integrar. A opção `-D` força a exclusão mesmo nesse caso.
- Apagar a branch **não** apaga os commits: eles continuam na `main`.

## Missão extra

`git merge --no-ff` cria um merge commit **mesmo** quando um fast-forward seria possível. Alguns times preferem isso para manter visível no gráfico onde cada funcionalidade começou e terminou. Refaça o desafio 8 (`reset.sh 08`) usando `--no-ff` e compare os gráficos.

# Desafio 7 — Desfazendo depois do commit

⏱ 6 minutos · Módulo 3b: Desfazendo

## Objetivo

Corrigir o último commit com `--amend` e desfazer um commit antigo com `revert`, que cria um commit novo em vez de apagar o histórico.

## Onde

```bash
cd ~/labs/07-desfazendo-depois-do-commit
```

## Estado inicial

Rode `git log --oneline`. Dois problemas:

- o **último** commit tem um erro de digitação na mensagem: "pudin" em vez de "pudim";
- um commit **antigo**, "Ajusta ingredientes do brigadeiro", trocou a manteiga por sal. Ninguém percebeu, e outros commits vieram depois.

## Tarefa

1. Corrija a mensagem do último commit. Faça isso **primeiro**, enquanto ele ainda é o último:

   ```bash
   git commit --amend -m "Adiciona receita de pudim"
   git log --oneline
   ```

   Repare que o hash do commit mudou: `--amend` **substitui** o commit por outro.

2. Encontre o hash do commit do sal e desfaça-o com `revert`. O Git abre o editor com uma mensagem pronta; basta salvar e fechar:

   ```bash
   git log --oneline
   git revert <hash-do-commit-do-sal>
   ```

3. Confira: o brigadeiro voltou a ter manteiga, o commit do sal **continua** no histórico, e há um commit novo desfazendo-o.

   ```bash
   grep manteiga brigadeiro.md
   git log --oneline
   ```

## Verificação

```bash
check.sh 07
```

## Por que não apagar o commit errado?

`--amend` reescreve o histórico e só é seguro em commits que **ainda não foram compartilhados**. Se alguém já baixou aquele commit, reescrever cria dois históricos diferentes e uma dor de cabeça na hora de sincronizar. `revert` é seguro sempre, porque só adiciona.

## Missão extra

Veja o que o revert fez por dentro: `git show HEAD`. Depois experimente `git revert HEAD` para desfazer o próprio revert (e `git revert HEAD` de novo para voltar).

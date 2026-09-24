# Desafio 5 — Detetive do histórico

⏱ 6 minutos · Módulo 3: Histórico

## Objetivo

Usar o histórico para responder perguntas sobre o projeto: quem mudou o quê, quando e por quê.

## Onde

```bash
cd ~/labs/05-detetive-do-historico
```

## Estado inicial

Um repositório com 12 commits feitos por quatro pessoas: Ana, Bruno, Carla e Diego. Você não estava lá quando aconteceu, mas o histórico estava.

## Tarefa

Abra `respostas.txt` e preencha as três respostas na linha que começa com `R:`:

1. **Quem alterou o preço sugerido do bolo de cenoura?** (nome da pessoa)
2. **Em qual commit a receita de pão caseiro entrou?** (hash curto, os 7 primeiros caracteres)
3. **Quantas porções o bolo passou a render depois do commit "Ajusta porções"?**

Não precisa fazer commit das respostas.

## Ferramentas

| Comando | Para quê |
|---|---|
| `git log --oneline` | visão geral, um commit por linha |
| `git log --oneline -- pao-caseiro.md` | só os commits que tocaram um arquivo |
| `git show <hash>` | o que exatamente um commit mudou |
| `git blame bolo-de-cenoura.md` | quem escreveu cada linha do arquivo, e em qual commit |
| `git log -S"45,00"` | commits que adicionaram ou removeram um texto |
| `git log --author=Carla` | commits de uma pessoa |

## Verificação

```bash
check.sh 05
```

## Missão extra

Rode `git log --oneline --graph --all --decorate` e depois `git log --stat --author=Bruno`. Qual foi o arquivo mais mexido por Bruno?

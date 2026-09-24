# Desafio 3 — Commit cirúrgico

⏱ 5 minutos · Módulo 2b: Staging seletivo

## Objetivo

Usar a staging area para separar mudanças que não têm relação entre si em commits diferentes. Commits pequenos e coesos são mais fáceis de ler, revisar e desfazer.

## Onde

```bash
cd ~/labs/03-commit-cirurgico
```

## Estado inicial

Dois arquivos modificados, ainda não adicionados:

- `bolo-de-cenoura.md`: uma correção no modo de preparo;
- `brigadeiro.md`: um ingrediente novo.

Confira com `git status` e `git diff`.

## Tarefa

Faça **um commit para cada arquivo**. A ideia é que `git add` recebe um arquivo por vez:

```bash
git add bolo-de-cenoura.md
git commit -m "Corrige instrução de mistura do bolo"

git add brigadeiro.md
git commit -m "Adiciona pitada de sal ao brigadeiro"
```

Depois confira que cada commit tocou um arquivo só:

```bash
git log --oneline --stat
```

## Verificação

```bash
check.sh 03
```

## Missão extra

Duas mudanças **no mesmo arquivo** também podem ir para commits separados:

1. Edite `pao-de-queijo.md` em dois lugares distantes: mude o título no topo e acrescente um passo no final.
2. Rode `git add -p pao-de-queijo.md`. O Git mostra cada trecho (*hunk*) e pergunta: responda `y` para incluir e `n` para deixar de fora.
3. Faça o commit do primeiro trecho, depois adicione e commite o segundo.

A verificação reconhece a missão extra quando `pao-de-queijo.md` aparece em dois commits diferentes.

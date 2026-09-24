# Gabarito

Sequência de comandos que resolve cada desafio. Serve para o professor, para os monitores e para quem quiser conferir depois da aula. A versão executável, usada pelos testes, está em `tests/solucoes.sh`.

Todos os desafios de 1 a 13 começam com `cd ~/labs/NN-nome`.

## Desafio 0 — Configure sua identidade

```bash
git config --global user.name "Seu Nome"
git config --global user.email seu-email@exemplo.com
```

## Desafio 1 — Meu primeiro repositório

```bash
git init
git add bolo-de-cenoura.md
git status
git add .
git commit -m "Cria o livro de receitas"
```

## Desafio 2 — Registrando mudanças

```bash
echo "- 1 pitada de canela" >> bolo-de-cenoura.md
git diff
git add bolo-de-cenoura.md
git diff --staged
git commit -m "Adiciona canela ao bolo"
# mais duas edições com commits e mensagens diferentes
git log --oneline
```

## Desafio 3 — Commit cirúrgico

```bash
git add bolo-de-cenoura.md
git commit -m "Corrige instrução de mistura do bolo"
git add brigadeiro.md
git commit -m "Adiciona pitada de sal ao brigadeiro"
```

Missão extra: edite `pao-de-queijo.md` no topo e no final, depois `git add -p pao-de-queijo.md` respondendo `y` ao primeiro trecho e `n` ao segundo; commit; `git add` e commit do restante.

## Desafio 4 — Ignorando o que não importa

```bash
printf '*.log\nbuild/\n.env\n' > .gitignore
git check-ignore -v debug.log build/livro.html .env
git add .gitignore
git commit -m "Ignora logs, build e segredos"
```

Missão extra:

```bash
git rm --cached antigo.log
git commit -m "Para de rastrear antigo.log"
```

## Desafio 5 — Detetive do histórico

| Pergunta | Resposta | Como achar |
|---|---|---|
| Quem alterou o preço do bolo | **Carla Mendes** (commit "Pequenos ajustes") | `git blame bolo-de-cenoura.md` ou `git log -S"45,00"` |
| Commit que criou o pão caseiro | hash de "Adiciona receita de pão caseiro" | `git log --oneline -- pao-caseiro.md` (o mais antigo) |
| Porções depois de "Ajusta porções" | **12** | `git log --oneline` e `git show <hash>` |

Os hashes são determinísticos (autores e datas fixos); confira com `git log --oneline` no seu Codespace.

## Desafio 6 — Desfazendo antes do commit

```bash
git restore bolo-de-cenoura.md
git restore --staged notas-pessoais.md
```

## Desafio 7 — Desfazendo depois do commit

```bash
git commit --amend -m "Adiciona receita de pudim"
git log --oneline                                   # ache "Ajusta ingredientes do brigadeiro"
git revert <hash>                                   # salve e feche o editor
```

Se o aluno fez o revert **antes** do amend, o amend mudou a mensagem do revert e o "pudin" ficou. Saída: `reset.sh 07`.

## Desafio 8 — Branch de funcionalidade

```bash
git switch -c feature/sobremesas
printf '# Sobremesas\n\n- Pudim\n' > sobremesas.md
git add sobremesas.md && git commit -m "Cria lista de sobremesas"
echo "- Mousse" >> sobremesas.md
git commit -am "Adiciona mousse à lista"
git switch main
git merge feature/sobremesas                        # Fast-forward
```

## Desafio 9 — Caminhos que divergem

```bash
git merge feature/bebidas                           # salve e feche o editor
git log --oneline --graph --all
git branch -d feature/bebidas
```

## Desafio 10 — Guardando para depois

```bash
git stash
git switch main
sed -i 's/1800 graus/180 graus/' bolo-de-cenoura.md
git commit -am "Corrige temperatura do forno"
git switch feature/sopas
git stash pop
```

## Desafio 11 — Resolva o conflito

```bash
git merge ajuste-preco                              # CONFLICT
# edite bolo-de-cenoura.md: deixe uma linha "Preço sugerido: R$ 48,00" (ou o valor escolhido)
git add bolo-de-cenoura.md
git commit                                          # salve e feche o editor
```

Missão extra: `reset.sh 11`, `cd` de volta, `git merge ajuste-preco`, `git merge --abort`.

## Desafio 12 — O colega invisível

```bash
echo "- Quinta: mousse de maracujá" >> cardapio.md
git commit -am "Adiciona a quinta ao cardápio"
colega.sh 12
git push                                            # rejected
git pull                                            # merge; salve e feche o editor
git push
```

## Desafio 13 — Conflito com o colega

```bash
sed -i 's/R\$ 40,00/R$ 50,00/' bolo-de-cenoura.md
git commit -am "Atualiza preço do bolo para R$ 50,00"
colega.sh 13
git fetch
git log --oneline main..origin/main
git pull                                            # CONFLICT
# edite bolo-de-cenoura.md deixando uma linha de preço
git add bolo-de-cenoura.md
git commit
git push
```

## Desafio 14 — Publique no GitHub

Na web: **+ → New repository**, nome `livro-de-receitas`, sem README/.gitignore/licença, **Create repository**. Depois:

```bash
cd ~/labs/14-publique-no-github
printf '# Aprendizados\n\n- ...\n- ...\n- ...\n' > aprendizados.md
git add aprendizados.md
git commit -m "Adiciona meus aprendizados do curso"
git remote add origin https://github.com/<usuario>/livro-de-receitas.git
git push -u origin main                             # aceite a autorização do GitHub, se aparecer
```

## Desafio 15 — Seu primeiro pull request

Na mesma pasta do desafio 14:

```bash
git switch -c mais-um-aprendizado
echo "- ..." >> aprendizados.md
git commit -am "Adiciona um quarto aprendizado"
git push -u origin mais-um-aprendizado
# no GitHub: Compare & pull request → Create pull request → Merge pull request → Confirm merge
git switch main
git pull
git branch -d mais-um-aprendizado
```

# Gabarito

Sequência de comandos que resolve cada desafio. Serve para o professor, para os monitores e para quem quiser conferir depois da aula. A versão executável dos desafios 0 a 15, usada pelos testes, está em `tests/solucoes.sh`. O desafio 16 tem conferência manual no GitHub.

Todos os desafios de 1 a 13 começam com `cd ~/labs/NN-nome`.

## Desafio 0 — Configure sua identidade

```bash
git config --global user.name "<seu nome de verdade>"
git config --global user.email <e-mail da sua conta GitHub>
```

A verificação recusa nomes e e-mails de exemplo (`Fulano`, `Seu Nome`, `voce@…`, `@exemplo.*`). Substitua-os pelo nome e e-mail do aluno antes de executar os comandos.

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

Missão extra: edite `pao-de-queijo.md` no topo e no final. Rode `git add -p pao-de-queijo.md`, respondendo `y` ao primeiro trecho e `n` ao segundo, e faça o commit. Depois use `git add` e faça o commit do restante.

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

Se o aluno fez o revert **antes** do amend, acabou alterando a mensagem do revert, e o erro "pudin" permaneceu. Nesse caso, use `reset.sh 07` para recomeçar.

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

O `install.sh` já prepara a autenticação pelo GitHub CLI. Use um terminal novo após instalar. No GitHub, clique em **+ → New repository** e dê ao repositório o nome `livro-de-receitas`. Deixe as opções de README, .gitignore e licença desmarcadas e clique em **Create repository**. Depois, no terminal:

```bash
cd ~/labs/14-publique-no-github
code aprendizados.md
# escreva três aprendizados e salve; o nome é no plural
git add aprendizados.md
git diff --staged
git commit -m "Adiciona meus aprendizados do curso"
git remote add origin https://github.com/<usuario>/livro-de-receitas.git
git push -u origin main
check.sh 14
```

Se houver 403, confira a URL, siga a [recuperação da autenticação](../exercises/14-publique-no-github/README.md#autenticação-no-codespaces) e repita `git push -u origin main`. Um push rejeitado não configura o upstream. Se o aluno já commitou `aprendizado.md`, no singular, siga a [correção do nome e conteúdo](../exercises/14-publique-no-github/README.md#já-fez-commit-de-aprendizadomd-no-singular).

## Desafio 15 — Seu primeiro pull request

Na mesma pasta do desafio 14, depois de `check.sh 14` aprovar, reutilizando o login preparado pelo instalador.

```bash
cd ~/labs/14-publique-no-github
git switch -c mais-um-aprendizado
code aprendizados.md
# acrescente o quarto aprendizado e salve
git add aprendizados.md
git diff --staged
git commit -m "Adiciona um quarto aprendizado"
git push -u origin mais-um-aprendizado
# no próprio repositório: base main, compare mais-um-aprendizado; revise o diff
# Create pull request → Create a merge commit → Merge pull request → Confirm merge
git switch main
git pull
git branch -d mais-um-aprendizado
check.sh 15
```

Confira o PR como **Merged** no GitHub. Em caso de 403, refaça a autenticação e repita o push da branch `mais-um-aprendizado` antes de abrir o PR.

## Desafio 16 — Contribua com um fork

Use uma conta diferente de `fsilva-alt` para testar o fork. O login já foi preparado pelo instalador, mesmo que o aluno tenha pulado os desafios 14 e 15.

No GitHub, abra [fsilva-alt/receitas-de-pizza](https://github.com/fsilva-alt/receitas-de-pizza), clique em **Fork**, selecione sua conta como **Owner**, mantenha o nome e clique em **Create fork**. Depois, no terminal, substitua `seu-usuario` pelo usuário do aluno:

```bash
USUARIO=seu-usuario
mkdir -p ~/labs
git clone "https://github.com/$USUARIO/receitas-de-pizza.git" ~/labs/16-contribua-com-um-fork
cd ~/labs/16-contribua-com-um-fork
git remote add upstream https://github.com/fsilva-alt/receitas-de-pizza.git
git fetch upstream
git switch main
git merge --ff-only upstream/main
git remote -v
git switch -c minha-pizza
code "pizza-$USUARIO.md"
# escreva e salve uma receita com título, ingredientes e modo de preparo
git add "pizza-$USUARIO.md"
git diff --staged
git commit -m "Adiciona minha receita de pizza"
git push -u origin minha-pizza
git status
```

Se o push retornar 403, confira se `origin` aponta para o fork do aluno, refaça a autenticação e repita `git push -u origin minha-pizza`. O clone de um repositório público pode funcionar mesmo sem permissão para publicar.

No repositório original, abra **Pull requests → New pull request → compare across forks**. Confira:

- **base repository:** `fsilva-alt/receitas-de-pizza`; **base:** `main`;
- **head repository:** `SEU-USUARIO/receitas-de-pizza`; **compare:** `minha-pizza`.

Revise o diff e crie o PR com título e descrição da receita. A conferência manual verifica os remotos, a branch publicada, o arquivo na aba **Files changed** e o destino do PR. O aluno entrega o link do PR aberto; o responsável pelo projeto faz a revisão e decide sobre o merge.

Missão extra, depois do merge:

```bash
git switch main
git fetch upstream
git merge --ff-only upstream/main
git push origin main
```

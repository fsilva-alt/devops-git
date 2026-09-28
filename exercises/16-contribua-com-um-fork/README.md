# Desafio 16 — Contribua com um fork

⏱ 15 minutos · Módulo 7: Fluxo no GitHub

## Objetivo

Contribuir com [fsilva-alt/receitas-de-pizza](https://github.com/fsilva-alt/receitas-de-pizza) pelo fluxo **fork → clone → branch → commit → push → pull request**. Você publica a mudança no seu fork e propõe que ela entre no repositório original.

## Onde

No navegador e no terminal do seu Codespace. Você vai criar a pasta `~/labs/16-contribua-com-um-fork` com `git clone`; ela não é gerada pelo instalador.

## Antes de começar

- **Fork:** uma cópia do repositório na sua conta do GitHub, ligada ao projeto original. Você pode publicar branches nessa cópia.
- **Clone:** uma cópia do repositório no seu Codespace, com os arquivos e o histórico Git, onde você vai trabalhar.
- **Pull request (PR):** uma proposta para integrar os commits da sua branch à branch de destino. Neste desafio, o destino será a `main` do projeto original.

Tenha sua conta GitHub aberta no navegador e a identidade Git configurada, como no desafio 0.

## Tarefa

### 1. Faça o fork no GitHub

1. Abra [github.com/fsilva-alt/receitas-de-pizza](https://github.com/fsilva-alt/receitas-de-pizza).
2. Clique em **Fork**, no canto superior direito.
3. Em **Owner**, selecione sua conta. Mantenha o nome `receitas-de-pizza` e a opção **Copy the main branch only** marcada.
4. Clique em **Create fork**. Se você já tiver esse fork, abra-o.
5. Confira: a página deve ser `SEU-USUARIO/receitas-de-pizza` e mostrar **forked from fsilva-alt/receitas-de-pizza**.

### 2. Clone o seu fork

Na página **do seu fork**, clique em **Code → HTTPS** para ver a URL. No terminal, substitua `seu-usuario` pelo seu nome de usuário no GitHub e execute:

```bash
USUARIO=seu-usuario
mkdir -p ~/labs
git clone "https://github.com/$USUARIO/receitas-de-pizza.git" ~/labs/16-contribua-com-um-fork
cd ~/labs/16-contribua-com-um-fork
git remote -v
```

O `clone` já configura o remoto `origin`. Confira que ele aponta para **sua conta**, pois é lá que você fará o `push`.

### 3. Ligue o clone ao projeto original

Adicione um segundo remoto, chamado `upstream`, para acompanhar o repositório original:

```bash
git remote add upstream https://github.com/fsilva-alt/receitas-de-pizza.git
git fetch upstream
git switch main
git merge --ff-only upstream/main
git remote -v
```

| Remoto | Aponta para | Uso neste desafio |
|---|---|---|
| `origin` | `SEU-USUARIO/receitas-de-pizza` | Publicar sua branch |
| `upstream` | `fsilva-alt/receitas-de-pizza` | Buscar atualizações do projeto original |

Aqui, `upstream` é o **nome de um remoto**. Já o `-u` de `git push -u` configura a **branch de acompanhamento**, também chamada de upstream; são usos diferentes da palavra.

### 4. Crie uma branch e escreva sua receita

```bash
git switch -c minha-pizza
code "pizza-$USUARIO.md"
```

Escreva uma receita de pizza com título, ingredientes com quantidades e modo de preparo numerado. Use `mucarela.md`, `calabresa.md` ou `portuguesa.md` como referência. Salve o arquivo.

O nome `pizza-SEU-USUARIO.md` ajuda cada pessoa da turma a contribuir em um arquivo diferente. Se abriu outro terminal, defina `USUARIO` novamente antes de usar os comandos com `$USUARIO`.

### 5. Revise e faça o commit

```bash
git status
git add "pizza-$USUARIO.md"
git diff --staged
git commit -m "Adiciona minha receita de pizza"
```

Confira no diff se a receita está completa e se apenas o arquivo esperado será incluído.

### 6. Publique a branch no seu fork

```bash
git push -u origin minha-pizza
```

Se o VS Code pedir autorização para acessar o GitHub, aceite. Abra seu fork no navegador, selecione a branch `minha-pizza` e confira o arquivo publicado.

### 7. Abra o pull request para o projeto original

1. Abra [os pull requests do projeto original](https://github.com/fsilva-alt/receitas-de-pizza/pulls) e clique em **New pull request**.
2. Clique em **compare across forks**, se necessário, para escolher os dois repositórios.
3. Confira os quatro campos:

   | Campo no GitHub | Valor |
   |---|---|
   | **base repository** (destino) | `fsilva-alt/receitas-de-pizza` |
   | **base** | `main` |
   | **head repository** (origem) | `SEU-USUARIO/receitas-de-pizza` |
   | **compare** | `minha-pizza` |

4. Revise o diff: ele deve mostrar sua receita. Clique em **Create pull request**.
5. Escreva um título como **Adiciona pizza de brócolis** e uma descrição dizendo o que adicionou e como conferiu o arquivo. Clique em **Create pull request** para enviar.
6. Copie o link do PR e compartilhe com o professor ou monitor.

A pessoa responsável pelo projeto original revisa o PR e decide sobre o merge. **O desafio está concluído quando o PR correto estiver aberto**; você não precisa esperar pelo merge.

## Verificação

A conferência deste desafio é **manual**, no terminal e no GitHub:

- [ ] Seu repositório no GitHub aparece como fork de `fsilva-alt/receitas-de-pizza`.
- [ ] `git remote -v` mostra `origin` na sua conta e `upstream` no projeto original.
- [ ] `git status` mostra a branch `minha-pizza` sincronizada com `origin/minha-pizza`, sem mudanças pendentes.
- [ ] O PR está no projeto original, da branch `minha-pizza` do seu fork para a `main` de `fsilva-alt/receitas-de-pizza`.
- [ ] A aba **Files changed** do PR mostra sua receita e o link foi compartilhado com o professor ou monitor.

## Dicas

- **Erro 403 no push:** confira `git remote -v`. Se `origin` aponta para `fsilva-alt`, corrija com `git remote set-url origin "https://github.com/$USUARIO/receitas-de-pizza.git"`. Se já aponta para seu fork, confira a autorização de acesso no Codespace.
- **Não aparece diferença no PR:** confira se selecionou `minha-pizza` em **compare** e se fez commit e push nessa branch.
- **Pedido de ajuste na revisão:** edite o arquivo na mesma branch, faça outro commit e rode `git push`. O PR existente será atualizado automaticamente.

## Missão extra

Depois que seu PR for integrado, atualize a `main` local a partir do projeto original e publique essa atualização no seu fork:

```bash
git switch main
git fetch upstream
git merge --ff-only upstream/main
git push origin main
```

Agora a `main` local e a do seu fork incluem as contribuições que você acabou de buscar do projeto original.

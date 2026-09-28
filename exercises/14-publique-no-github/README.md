# Desafio 14 — Publique no GitHub

⏱ 5 minutos · Módulo 6: Remotos

## Objetivo

Fazer o primeiro `push` para um repositório criado na **sua conta** do GitHub.

## Onde

```bash
cd ~/labs/14-publique-no-github
```

## Estado inicial

Um repositório local com o livro de receitas e um README, mas **sem remoto** (`git remote -v` não mostra nada). Ele só existe neste Codespace.

## Antes de começar

Configure sua identidade com o desafio 0 antes de fazer commits. `user.name` e `user.email` identificam o autor; a permissão para publicar no GitHub vem da **autenticação**. `whoami` mostra o usuário Linux (`codespace`), não a conta GitHub.

O `install.sh` já prepara o login no GitHub. Use um terminal novo após a instalação e siga a tarefa. Se houver erro de acesso, consulte [Autenticação no Codespaces](#autenticação-no-codespaces).

## Tarefa

1. Abra `code aprendizados.md`, escreva **três** coisas que você aprendeu hoje e salve. Use exatamente `aprendizados.md`, no plural: esse é o arquivo esperado pela verificação e pelo desafio 15. Formato livre; uma lista serve. Confira e faça commit:

   ```bash
   git status
   git add aprendizados.md
   git diff --staged
   git commit -m "Adiciona meus aprendizados do curso"
   ```

2. No GitHub, clique em **+** (canto superior direito) → **New repository** e use o nome `livro-de-receitas`. O repositório precisa estar vazio: **não** marque "Add a README", .gitignore ou licença. Clique em **Create repository**.

3. O GitHub mostra uma página com instruções para "push an existing repository". Copie a URL **HTTPS** do repositório e ligue o remoto, substituindo `<seu-usuario>` pelo seu usuário GitHub:

   ```bash
   git remote add origin https://github.com/<seu-usuario>/livro-de-receitas.git
   git remote -v
   ```

4. Com a [autenticação preparada](#autenticação-no-codespaces), publique o repositório. O `-u` associa a `main` local à `main` do GitHub, definindo a branch remota usada nos próximos `push` e `pull`:

   ```bash
   git push -u origin main
   ```

   Aguarde a confirmação de envio e a mensagem de que `main` acompanha `origin/main`. Se houver 403, corrija a autenticação e **repita esse mesmo comando**; um push que falhou não configura o upstream.

5. Atualize a página do repositório no navegador e encontre suas receitas, o `aprendizados.md` e o commit. Depois confira localmente:

   ```bash
   git status          # up to date with 'origin/main'
   ```

## Verificação

```bash
check.sh 14
```

Confira também na página do GitHub que `aprendizados.md` contém seus três aprendizados. `nothing to commit, working tree clean` informa que não há mudanças locais pendentes; sozinho, não comprova que houve publicação.

## Autenticação no Codespaces

Esta seção serve para recuperar o acesso se o login expirar, se você usou uma instalação antiga ou se aparecer **403**. Você também pode rodar o `install.sh` novamente para atualizar o ambiente e preparar o login, preservando os laboratórios.

O `GITHUB_TOKEN` automático do Codespace tem acesso limitado a determinados repositórios. Um repositório novo ou um fork pode ficar fora desse acesso e rejeitar o push, mesmo sendo da sua conta. O instalador usa o login do GitHub CLI (`gh`) pelo navegador e configura o Git para usar essa credencial.

Para corrigir manualmente, no mesmo terminal em que fará o push:

```bash
unset GH_TOKEN GITHUB_TOKEN
gh auth login --hostname github.com --git-protocol https --web
```

Siga as instruções do terminal: copie o código temporário, abra `https://github.com/login/device` se o navegador não abrir sozinho e autorize o GitHub CLI com **a conta em que criou o repositório**. Depois que o login terminar:

```bash
gh auth setup-git --hostname github.com
gh auth status --active --hostname github.com
```

Confira a conta ativa e repita o push. O `setup-git` configura o Git para usar a credencial do `gh`; sozinho, ele não amplia as permissões de um token. As variáveis `GH_TOKEN` e `GITHUB_TOKEN` têm prioridade sobre o login salvo, por isso o `unset` vem primeiro.

### Ao abrir outro terminal

O `unset` manual vale só para o terminal atual. O `install.sh` também configura o `.bashrc` e o `.zshrc` (se existir) para remover essas variáveis nos novos terminais do Codespaces. É preciso abrir um terminal novo após instalar, ou carregar o arquivo com `source ~/.bashrc` (bash) / `source ~/.zshrc` (zsh).

Se estiver num terminal antigo ou que não carregou essa configuração:

```bash
unset GH_TOKEN GITHUB_TOKEN
gh auth status --active --hostname github.com
```

Se a credencial salva estiver válida e a conta ativa for a sua, continue. Se não houver login válido, repita o login e o `setup-git` acima. O `gh` pode salvar a credencial em arquivo quando não há um cofre de credenciais (`keyring`); a ausência da palavra `keyring` não significa que o login falhou.

Para conferir a autenticação, use `gh auth status`, que mascara o token. Não imprima nem compartilhe o valor das variáveis de token; se ele foi exposto, revogue a credencial.

## Dicas

- O nome do remoto, `origin`, é só uma convenção. Poderia ser qualquer nome.
- `git remote -v` mostra para onde `origin` aponta. Se errou a URL: `git remote set-url origin <url-certa>`.
- **403 / Permission denied:** confira se `origin` aponta para seu `livro-de-receitas` e siga a [autenticação no Codespaces](#autenticação-no-codespaces). Depois repita `git push -u origin main`.
- **`gh auth login` diz que usa `GITHUB_TOKEN` ou `GH_TOKEN`:** rode `unset GH_TOKEN GITHUB_TOKEN` no mesmo terminal antes do login.
- **`main has no upstream branch`:** o primeiro envio com `-u` ainda não foi concluído. Rode `git push -u origin main` após resolver o acesso.
- **`remote origin already exists`:** use `git remote -v` para conferir o endereço e `git remote set-url origin <url-certa>` para corrigi-lo.

### Já fez commit de `aprendizado.md`, no singular?

Se esse é o arquivo dos seus aprendizados e ainda não existe `aprendizados.md`, renomeie o arquivo rastreado:

```bash
git mv aprendizado.md aprendizados.md
code aprendizados.md
```

Complete os três aprendizados, salve e registre a correção:

```bash
git add aprendizados.md
git diff --staged
git commit -m "Corrige o arquivo de aprendizados"
git push -u origin main
check.sh 14
```

Referências: [acesso do Codespaces a outros repositórios](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces), [login do GitHub CLI](https://cli.github.com/manual/gh_auth_login) e [prioridade das variáveis de autenticação](https://cli.github.com/manual/gh_help_environment).

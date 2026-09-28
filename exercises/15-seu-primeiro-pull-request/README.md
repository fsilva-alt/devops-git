# Desafio 15 — Seu primeiro pull request

⏱ 7 minutos · Módulo 7: Fluxo no GitHub · pode ficar para depois da aula

## Objetivo

Percorrer o fluxo que a maioria das equipes usa: branch → push → pull request → merge na web → pull local.

## Onde

A mesma pasta do desafio 14, que já está ligada ao seu repositório no GitHub:

```bash
cd ~/labs/14-publique-no-github
```

## Antes de começar

Conclua o desafio 14 e rode `check.sh 14`. Confira no GitHub o arquivo **`aprendizados.md`**, no plural, com três aprendizados. A `main` local deve acompanhar `origin/main` depois de um `git push -u origin main` bem-sucedido.

O login preparado pelo `install.sh` continua valendo. Se precisar recuperar o acesso, siga a [autenticação no Codespaces](../14-publique-no-github/README.md#autenticação-no-codespaces).

## Tarefa

1. Crie uma branch e acrescente um quarto aprendizado em `aprendizados.md`:

   ```bash
   git switch -c mais-um-aprendizado
   code aprendizados.md
   # acrescente o quarto aprendizado e salve
   git add aprendizados.md
   git diff --staged
   git commit -m "Adiciona um quarto aprendizado"
   ```

2. Publique a branch. O `-u` associa a branch local à remota, definindo qual será usada nos próximos `push` e `pull`:

   ```bash
   git push -u origin mais-um-aprendizado
   ```

   Continue quando o envio terminar com sucesso. Se aparecer 403, siga a [autenticação do desafio 14](../14-publique-no-github/README.md#autenticação-no-codespaces) e repita `git push -u origin mais-um-aprendizado`.

3. O Git imprime um link para criar o pull request. Abra-o (ou vá ao seu `livro-de-receitas` no GitHub e clique em **Compare & pull request**). Confira **base: main** e **compare: mais-um-aprendizado**, ambas no seu repositório, e revise o diff. Escreva um título, clique em **Create pull request** e, na página do PR, escolha **Create a merge commit**, clique em **Merge pull request** e depois em **Confirm merge**.

4. O merge foi feito **no GitHub**; agora atualize a `main` local para receber essas mudanças:

   ```bash
   git switch main
   git pull
   git log --oneline --graph -5
   ```

5. Com as mudanças integradas à `main`, apague a branch local. O GitHub oferece um botão para apagar a remota:

   ```bash
   git branch -d mais-um-aprendizado
   ```

## Verificação

```bash
check.sh 15
```

Use o número `15`: como você continua na pasta do desafio 14, `check.sh` sem número verifica o desafio 14. Confira também que o PR aparece como **Merged** no GitHub e que a `main` contém o quarto aprendizado.

## Por que não commitar direto na main?

No pull request, você pode **revisar e discutir** a mudança antes de integrá-la, com comentários e resultados de testes automáticos. Essa revisão também pode ser feita quando você trabalha sozinho.

## Missão extra

Abra um segundo PR e pratique a revisão de código: antes de fazer o merge, deixe um comentário numa linha do diff, na aba **Files changed**.

# Desafio 15 — Seu primeiro pull request

⏱ 7 minutos · Módulo 7: Fluxo no GitHub · desafio elástico

## Objetivo

Percorrer o fluxo que a maioria das equipes usa: branch → push → pull request → merge na web → pull local.

## Onde

A mesma pasta do desafio 14, que já está ligada ao seu repositório no GitHub:

```bash
cd ~/labs/14-publique-no-github
```

## Tarefa

1. Crie uma branch e acrescente um quarto aprendizado em `aprendizados.md`:

   ```bash
   git switch -c mais-um-aprendizado
   # edite o arquivo
   git commit -am "Adiciona um quarto aprendizado"
   ```

2. Publique a branch. O `-u` liga a branch local à remota, para que os próximos `push` e `pull` saibam para onde ir:

   ```bash
   git push -u origin mais-um-aprendizado
   ```

3. O Git imprime um link para criar o pull request. Abra-o (ou vá ao repositório no GitHub e clique em **Compare & pull request**). Escreva um título, clique em **Create pull request** e, na página do PR, clique em **Merge pull request** e depois em **Confirm merge**.

4. O merge aconteceu **no GitHub**. Sua `main` local ainda não sabe disso. Sincronize:

   ```bash
   git switch main
   git pull
   git log --oneline --graph -5
   ```

5. A branch já cumpriu seu papel. Apague a cópia local (o GitHub oferece um botão para apagar a remota):

   ```bash
   git branch -d mais-um-aprendizado
   ```

## Verificação

```bash
check.sh 15
```

## Por que não commitar direto na main?

Um pull request cria um lugar para **conversar** sobre a mudança antes de integrá-la: revisão, comentários, testes automáticos. Mesmo trabalhando sozinho, é um bom hábito.

## Missão extra

Abra um segundo PR e, antes de fazer o merge, deixe um comentário numa linha do diff (aba **Files changed**). Esse é o mecanismo de code review.

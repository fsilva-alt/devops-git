# Desafio 15 — Seu primeiro pull request

⏱ 7 minutos · Módulo 7: Fluxo no GitHub · pode ficar para depois da aula

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

2. Publique a branch. O `-u` associa a branch local à remota, definindo qual será usada nos próximos `push` e `pull`:

   ```bash
   git push -u origin mais-um-aprendizado
   ```

3. O Git imprime um link para criar o pull request. Abra-o (ou vá ao repositório no GitHub e clique em **Compare & pull request**). Escreva um título, clique em **Create pull request** e, na página do PR, clique em **Merge pull request** e depois em **Confirm merge**.

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

## Por que não commitar direto na main?

No pull request, você pode **revisar e discutir** a mudança antes de integrá-la, com comentários e resultados de testes automáticos. Essa revisão também pode ser feita quando você trabalha sozinho.

## Missão extra

Abra um segundo PR e pratique a revisão de código: antes de fazer o merge, deixe um comentário numa linha do diff, na aba **Files changed**.

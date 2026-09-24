# Curso de Git no GitHub Codespaces

Curso de Git para iniciantes, com 3 horas de aula ao vivo pelo Zoom e prática no Codespace individual de cada pessoa. Você faz os exercícios pelo navegador, sem instalar nada no computador.

> **Para alunos:** comece pela seção [Antes da aula](#antes-da-aula). No dia do curso, siga a [Sequência da aula](#sequência-da-aula).
> **Para professores e monitores:** consulte o [guia do professor](docs/guia-do-professor.md).

## O que você vai aprender

- as três áreas do Git: diretório de trabalho, staging area e repositório;
- fazer commits pequenos, com mensagens claras;
- investigar o histórico: quem mudou o quê, quando e por quê;
- desfazer mudanças com segurança, antes e depois do commit;
- trabalhar com branches, fazer merge e resolver conflitos;
- sincronizar com um remoto e abrir um pull request no GitHub.

A ementa completa, com cronograma, está em [docs/ementa.md](docs/ementa.md).

## Antes da aula

Prepare o ambiente **pelo menos um dia antes** para ter tempo de resolver eventuais problemas de acesso.

1. Tenha uma conta no [GitHub](https://github.com) e esteja logado.
2. Crie um Codespace em branco: acesse [github.com/codespaces](https://github.com/codespaces) e clique em **New codespace** com o template **Blank**, ou vá direto em [codespaces/new](https://github.com/codespaces/new). A primeira criação leva de 1 a 3 minutos.
3. Quando o VS Code abrir no navegador, cole no terminal e pressione Enter:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-git/main/install.sh)"
   ```

   O instalador baixa o curso para `~/devops-git`, monta os laboratórios em `~/labs` e termina com a mensagem **"Curso de Git instalado com sucesso!"**.

4. Abra um terminal novo (ou rode `source ~/.bashrc`) e teste:

   ```bash
   check.sh 00
   ```

   O comando pode avisar que faltam seu nome e e-mail. Nesse caso, a verificação está funcionando; você vai configurar esses dados na aula.

5. Pare o Codespace para poupar as horas de uso da sua franquia gratuita: em [github.com/codespaces](https://github.com/codespaces), **⋯ → Stop codespace**. No dia da aula, abra-o novamente; os arquivos continuam salvos.

## Como o ambiente funciona

| Caminho | Conteúdo |
|---|---|
| `~/devops-git/` | Este repositório: enunciados, scripts e documentos |
| `~/devops-git/exercises/NN-nome/README.md` | O enunciado de cada desafio |
| `~/labs/NN-nome/` | Um repositório Git independente para cada desafio de 1 a 14 |

Comandos disponíveis no terminal:

| Comando | Função |
|---|---|
| `check.sh NN` | Verifica o desafio NN e responde ✅ ou uma dica |
| `reset.sh NN` | Recria o desafio NN do zero e apaga o trabalho feito **apenas nesse desafio** |
| `colega.sh NN` | Simula um colega publicando no remoto (desafios 12 e 13) |
| `setup.sh` | Gera os laboratórios que ainda não existem; o instalador já rodou isso |

Dentro da pasta de um laboratório, `check.sh` e `reset.sh` funcionam sem o número. Para ler um enunciado no editor: `code ~/devops-git/exercises/05-detetive-do-historico/README.md`.

## Sequência da aula

| # | Desafio | Tema |
|---|---|---|
| [0](exercises/00-configure-sua-identidade/README.md) | Configure sua identidade | `git config` |
| [1](exercises/01-meu-primeiro-repositorio/README.md) | Meu primeiro repositório | `init`, `status`, `add`, `commit` |
| [2](exercises/02-registrando-mudancas/README.md) | Registrando mudanças | `diff`, `diff --staged`, `log` |
| [3](exercises/03-commit-cirurgico/README.md) | Commit cirúrgico | staging seletivo, `add -p` |
| [4](exercises/04-ignorando-o-que-nao-importa/README.md) | Ignorando o que não importa ⏱ | `.gitignore`, `check-ignore`, `rm --cached` |
| [5](exercises/05-detetive-do-historico/README.md) | Detetive do histórico | `log`, `show`, `blame`, `log -S` |
| [6](exercises/06-desfazendo-antes-do-commit/README.md) | Desfazendo antes do commit | `restore`, `restore --staged` |
| [7](exercises/07-desfazendo-depois-do-commit/README.md) | Desfazendo depois do commit | `commit --amend`, `revert` |
| [8](exercises/08-branch-de-funcionalidade/README.md) | Branch de funcionalidade | `switch -c`, merge fast-forward |
| [9](exercises/09-caminhos-que-divergem/README.md) | Caminhos que divergem | merge de três vias, `branch -d` |
| [10](exercises/10-guardando-para-depois/README.md) | Guardando para depois ⏱ | `stash` |
| [11](exercises/11-resolva-o-conflito/README.md) | Resolva o conflito | marcadores, `merge --abort` |
| [12](exercises/12-o-colega-invisivel/README.md) | O colega invisível | `push` rejeitado, `pull` |
| [13](exercises/13-conflito-com-o-colega/README.md) | Conflito com o colega | `fetch`, `main..origin/main` |
| [14](exercises/14-publique-no-github/README.md) | Publique no GitHub | `remote add`, `push -u` para o GitHub |
| [15](exercises/15-seu-primeiro-pull-request/README.md) | Seu primeiro pull request ⏱ | branch, PR, merge na web, `pull` |

⏱ indica os desafios que podem ficar como tarefa para depois da aula, caso haja atraso.

## Ao final da aula

1. Confira que seu trabalho está publicado: `check.sh 14` e `check.sh 15`.
2. **Pare ou exclua o Codespace.** Um Codespace parado continua ocupando armazenamento da franquia gratuita; um excluído não. Os laboratórios são descartáveis: o instalador recria tudo em outro Codespace a qualquer momento.
3. O repositório `livro-de-receitas` que você publicou no desafio 14 continua na sua conta do GitHub, com o `aprendizados.md`, para revisar depois.

## Para desenvolver o curso

Os laboratórios são gerados por `scripts/labs.sh` e verificados por `scripts/checks.sh`. A suíte de testes em `tests/` roda em um container Ubuntu limpo e precisa de Docker. Ela executa o `install.sh` como um aluno faria e confere, para cada desafio, se `check.sh` reprova o estado vazio, dá a dica correspondente a cada resposta errada e aprova a solução do gabarito. Para rodar:

```bash
tests/rodar.sh
```

## Licença

[MIT](LICENSE).

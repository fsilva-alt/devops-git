# Guia do professor

Este guia reúne a preparação da aula, o funcionamento dos laboratórios e as soluções para os problemas mais comuns.

## Antes do evento

- [ ] Garantir que o repositório `fsilva-alt/devops-git` está público, com o `install.sh` na branch `main` (é dele que o `curl` do instalador lê).
- [ ] Testar num Codespace em branco novo: rodar o instalador, concluir o login pelo navegador solicitado por ele, abrir um terminal novo e cronometrar os desafios 0 a 15. Conferir o push do desafio 14 e a retomada em outro terminal; a autenticação deve estar pronta antes da aula.
- [ ] Testar o desafio 16 com uma conta diferente de `fsilva-alt`: conferir acesso público a `fsilva-alt/receitas-de-pizza`, fork, clone, push e abertura do PR. Combinar com os monitores onde os alunos entregarão os links e quem revisará as receitas.
- [ ] Pedir aos alunos que façam a seção "Antes da aula" do README **pelo menos um dia antes** e parem o Codespace.
- [ ] Combinar com os monitores: sugestão de 1 monitor para cada 25 pessoas.
- [ ] Preparar o Zoom: chat liberado, um monitor de olho no chat, salas simultâneas opcionais para atendimento individual.

## Como o ambiente funciona por dentro

| Arquivo | Função |
|---|---|
| `install.sh` | Clona o curso em `~/devops-git`, roda o `setup.sh`, autentica com `gh` pelo navegador (ou reutiliza login salvo), configura o Git e coloca `scripts/` no `PATH`. O bloco do curso no bash/zsh também remove tokens de ambiente nos terminais do Codespaces para usar a credencial salva. Idempotente; rodar de novo atualiza o curso |
| `scripts/setup.sh` | Define `init.defaultBranch`, `core.editor`, `pull.rebase`; gera os labs 01–14 em `~/labs`. Idempotente: não apaga o que já existe. `--force` regenera tudo |
| `scripts/labs.sh` | Uma função `gerar_NN` por desafio; commits com autor e data fixos, então os hashes são iguais em todas as máquinas |
| `scripts/checks.sh` | Uma função `verificar_NN` por desafio; cada falha vem com uma dica |
| `scripts/check.sh NN` | Roda a verificação. Sai com 0 quando concluído |
| `scripts/reset.sh NN` | Apaga e regenera **só** o lab NN |
| `scripts/colega.sh NN` | Clona o bare de `~/labs/.remotos/NN.git` numa pasta temporária, commita como "Colega Invisível" e faz push |
| `tests/rodar.sh` | Roda `tests/solucoes.sh` num container Ubuntu limpo: resolve todos os desafios locais e confere que a verificação reprova antes e aprova depois |

Cada lab guarda metadados em `.git/lab/` (o hash do commit base, por exemplo), que as verificações usam. O aluno não vê isso no `git log`.

Os labs ficam **fora** do repositório do curso para evitar repositórios Git aninhados e confusão ao consultar o `git status` do curso.

O desafio 16 é criado pelo próprio aluno com `git clone`, em `~/labs/16-contribua-com-um-fork`. Sua verificação é manual; `check.sh` atende os desafios 00–15 e `reset.sh` recria os labs 01–14.

## Condução da aula

### Ritmo

- Anuncie cada desafio com o número e o horário de término. Peça que sinalizem no chat com ✅ quando `check.sh NN` aprovar.
- Quando cerca de 70% sinalizarem, avise que falta 1 minuto e passe ao próximo bloco ao fim desse prazo. Quem ainda estiver fazendo o desafio recebe ajuda de um monitor; quem terminar cedo pode fazer a missão extra.
- Se houver 5 minutos de atraso ao final do Módulo 2b, deixe o **Desafio 4** como tarefa de casa. Se precisar de mais tempo, faça o mesmo com o **Desafio 10** (ao fim do bloco de stash) e o **Desafio 15** (no fim da aula).
- O login para os **Desafios 14–16** acontece no `install.sh`, na preparação antes da aula. Se alguém instalou uma versão antiga, peça que rode o instalador novamente e abra um terminal novo. Para recuperar um acesso que falhou, use a [autenticação do desafio 14](../exercises/14-publique-no-github/README.md#autenticação-no-codespaces).
- No **Desafio 16**, reforce o destino do PR: `fsilva-alt/receitas-de-pizza:main`, recebendo a branch `minha-pizza` do fork de cada aluno. A entrega é o link do PR aberto; o merge pode acontecer depois da revisão. Cada aluno usa `pizza-SEU-USUARIO.md` para reduzir conflitos entre contribuições.

### Compartilhamento de tela

Mostre o seu próprio Codespace, não slides, sempre que possível. Rode os comandos ao vivo e deixe o `git log --oneline --graph --all` na tela. A extensão Git Graph está instalada e ajuda a visualizar branches e merges, mas ensine o terminal primeiro.

### Editor

O `setup.sh` define `core.editor "code --wait"`. Quando `git merge`, `git revert` ou `git commit` sem `-m` precisarem de uma mensagem, o VS Code abre uma aba para editá-la. Avise **antes do Desafio 7**: "salve e feche a aba para o Git continuar". Enquanto a aba estiver aberta, o terminal aguarda o editor.

## Problemas comuns

| Sintoma | Causa | Solução |
|---|---|---|
| `check.sh: command not found` | Terminal aberto antes de o instalador mexer no `.bashrc`/`.zshrc` | `source ~/.bashrc` (ou `~/.zshrc`), ou abrir um terminal novo; em último caso `bash ~/devops-git/scripts/check.sh NN` |
| Instalador falhou no `curl` | Sem rede, ou URL digitada errada | Conferir a linha; se persistir, `git clone https://github.com/fsilva-alt/devops-git ~/devops-git && bash ~/devops-git/install.sh` |
| `Author identity unknown` no commit | Desafio 0 não feito | `git config --global user.name/user.email` |
| Terminal "travado" após `git merge` | Esperando o editor | Procurar a aba `COMMIT_EDITMSG` no VS Code, salvar e fechar |
| Vim aberto (`~` nas linhas) | `core.editor` não definido | `Esc`, `:q!`, `Enter`; depois `git config --global core.editor "code --wait"` |
| `Need to specify how to reconcile divergent branches` | `pull.rebase` não definido | `git config --global pull.rebase false` |
| Aluno perdido no meio de um desafio | Estado inconsistente | `reset.sh NN` e recomeçar; leva segundos |
| Pasta do lab sumiu / `No such file or directory` | Rodou `reset.sh` de dentro da pasta | `cd` de novo para a pasta |
| `push` dos Desafios 14 ou 15 pede senha ou falha com 403 | Token automático do Codespace sem acesso ao repositório, ou URL/conta incorreta | Conferir `git remote -v` e seguir a [autenticação do desafio 14](../exercises/14-publique-no-github/README.md#autenticação-no-codespaces): remover as variáveis do terminal, login pelo navegador e `setup-git`; repetir o push com `-u` para a branch do desafio |
| `gh auth login` recusa login porque usa `GITHUB_TOKEN` ou `GH_TOKEN` | Terminal antigo ou configuração do instalador não carregada; variável tem prioridade sobre o login salvo | Abrir um terminal novo após instalar; para corrigir no atual, `unset GH_TOKEN GITHUB_TOKEN` antes do login |
| `main has no upstream branch` após um 403 | O primeiro push com `-u` falhou | Resolver a autenticação e repetir `git push -u origin main` |
| `check.sh 14` reclama de `aprendizados.md`, mas há `aprendizado.md` | Nome no singular | Seguir a [correção do nome e conteúdo](../exercises/14-publique-no-github/README.md#já-fez-commit-de-aprendizadomd-no-singular): renomear com `git mv`, completar três aprendizados, fazer commit e push |
| Repositório do Desafio 14 foi criado com README | Aluno marcou "Add a README" ao criar | O push é rejeitado; `git pull --allow-unrelated-histories origin main` e depois `git push -u origin main`, ou criar outro repositório vazio |
| `push` do Desafio 16 falha com 403 | `origin` aponta para o projeto original ou o token não permite escrita no fork | Conferir `git remote -v`: `origin` deve apontar para a conta do aluno; seguir a autenticação do desafio 14 e repetir `git push -u origin minha-pizza` |
| PR do Desafio 16 foi aberto no próprio fork | Destino escolhido incorretamente | Abrir o PR no original usando **compare across forks**: base `fsilva-alt/receitas-de-pizza:main`, head `ALUNO/receitas-de-pizza:minha-pizza`; fechar o PR aberto no destino errado |
| Codespace lento ou não abre | Franquia esgotada ou região sobrecarregada | Verificar em github.com/codespaces; parar Codespaces antigos |
| Os arquivos não estão no Codespace | Codespace anterior foi **excluído** (não só parado) | Criar outro Codespace; o `setup.sh` recria os labs no estado inicial. O trabalho publicado no GitHub continua disponível lá |

### Diagnóstico de autenticação nos desafios 14–16

- `user.name`/`user.email` são a autoria dos commits; `whoami` é o usuário Linux. Confira a conta GitHub ativa com `gh auth status --hostname github.com`.
- A conta correta no `gh auth status` e até `permissions.push: true` na API do repositório não garantem que o **token em uso** permite aquele push. O token automático pode estar limitado a outro repositório. Só rodar `gh auth setup-git` reutiliza a mesma credencial; faça o `unset` antes do login pelo navegador.
- O `gh` pode salvar o login em arquivo quando não há `keyring`. Não use a presença dessa palavra como teste de autenticação; confira a conta e o estado do login com `gh auth status`.
- `working tree clean` só descreve as mudanças locais. Confira o envio bem-sucedido e os arquivos na página do GitHub. Nos desafios 14 e 15, confira também o conteúdo de `aprendizados.md`; no 15, confira o PR como **Merged**.
- Use o token mascarado de `gh auth status` para diagnóstico. Não peça ao aluno para imprimir variáveis de token. Se uma credencial aparecer no chat ou na tela compartilhada, revogue-a e refaça o login.

## Ajustes fáceis

- **Mudar o tema das receitas:** só `scripts/labs.sh`. As verificações dependem de alguns nomes de arquivo e de trechos (`45,00`, `2 batatas`, `manteiga`); procure em `scripts/checks.sh` antes de trocar.
- **Adicionar um desafio com verificação automática:** acrescente o nome em `LAB_NOMES` (`scripts/lib.sh`), uma função `gerar_NN` em `labs.sh`, uma `verificar_NN` em `checks.sh`, o enunciado em `exercises/` e um bloco em `tests/solucoes.sh`. Ajuste `ULTIMO_LAB_LOCAL` se o desafio for local.
- **Desafio com conferência manual, como o 16:** mantenha o enunciado, o gabarito, o índice, a ementa e os slides atualizados, com os critérios de entrega no GitHub.
- **Rodar os testes:** `tests/rodar.sh` (precisa de Docker). Rode sempre que mexer em `labs.sh` ou `checks.sh`.

## Encerramento

1. `check.sh 14` e `check.sh 15` para conferir que o trabalho está no GitHub. No desafio 16, conferir o PR no projeto original e receber o link do aluno.
2. Parar ou excluir o Codespace. Reforce: **parado ainda consome armazenamento**; excluído não. Os labs são descartáveis.
3. Próximos passos sugeridos: [Pro Git](https://git-scm.com/book/pt-br/v2) (gratuito, em português), [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR) (interativo), e contribuir com outro projeto open source via fork e pull request.

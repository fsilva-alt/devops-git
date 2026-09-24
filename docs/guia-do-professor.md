# Guia do professor

Este guia reúne a preparação da aula, o funcionamento dos laboratórios e as soluções para os problemas mais comuns.

## Antes do evento

- [ ] Garantir que o repositório `fsilva-alt/devops-git` está público, com o `install.sh` na branch `main` (é dele que o `curl` do instalador lê).
- [ ] Testar num Codespace em branco novo: rodar a linha do instalador, cronometrar os 16 desafios e, principalmente, conferir que o `git push` do desafio 14 funciona (a autorização do GitHub pode aparecer uma vez no VS Code).
- [ ] Pedir aos alunos que façam a seção "Antes da aula" do README **pelo menos um dia antes** e parem o Codespace.
- [ ] Combinar com os monitores: sugestão de 1 monitor para cada 25 pessoas.
- [ ] Preparar o Zoom: chat liberado, um monitor de olho no chat, salas simultâneas opcionais para atendimento individual.

## Como o ambiente funciona por dentro

| Arquivo | Função |
|---|---|
| `install.sh` | O que o aluno roda via `sh -c "$(curl ...)"` num Codespace em branco: clona o curso em `~/devops-git`, roda o `setup.sh`, coloca `scripts/` no `PATH` do bash e do zsh e mostra a mensagem de sucesso. Idempotente; rodar de novo atualiza o curso |
| `scripts/setup.sh` | Define `init.defaultBranch`, `core.editor`, `pull.rebase`; gera os labs 01–14 em `~/labs`. Idempotente: não apaga o que já existe. `--force` regenera tudo |
| `scripts/labs.sh` | Uma função `gerar_NN` por desafio; commits com autor e data fixos, então os hashes são iguais em todas as máquinas |
| `scripts/checks.sh` | Uma função `verificar_NN` por desafio; cada falha vem com uma dica |
| `scripts/check.sh NN` | Roda a verificação. Sai com 0 quando concluído |
| `scripts/reset.sh NN` | Apaga e regenera **só** o lab NN |
| `scripts/colega.sh NN` | Clona o bare de `~/labs/.remotos/NN.git` numa pasta temporária, commita como "Colega Invisível" e faz push |
| `tests/rodar.sh` | Roda `tests/solucoes.sh` num container Ubuntu limpo: resolve todos os desafios locais e confere que a verificação reprova antes e aprova depois |

Cada lab guarda metadados em `.git/lab/` (o hash do commit base, por exemplo), que as verificações usam. O aluno não vê isso no `git log`.

Os labs ficam **fora** do repositório do curso para evitar repositórios Git aninhados e confusão ao consultar o `git status` do curso.

## Condução da aula

### Ritmo

- Anuncie cada desafio com o número e o horário de término. Peça que sinalizem no chat com ✅ quando `check.sh NN` aprovar.
- Quando cerca de 70% sinalizarem, avise que falta 1 minuto e passe ao próximo bloco ao fim desse prazo. Quem ainda estiver fazendo o desafio recebe ajuda de um monitor; quem terminar cedo pode fazer a missão extra.
- Se houver 5 minutos de atraso ao final do Módulo 2b, deixe o **Desafio 4** como tarefa de casa. Se precisar de mais tempo, faça o mesmo com o **Desafio 10** (ao fim do bloco de stash) e o **Desafio 15** (no fim da aula).

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
| `push` do Desafio 14 pede senha ou falha com 403 | Codespace sem autorização para aquele repositório, ou URL de outra conta | Aceitar o pedido de autorização do GitHub que o VS Code mostra; conferir `git remote -v` (tem de ser o repositório do próprio aluno). Alternativa: no VS Code, aba Source Control → **Publish to GitHub** |
| Repositório do Desafio 14 foi criado com README | Aluno marcou "Add a README" ao criar | O push é rejeitado; `git pull --allow-unrelated-histories origin main` e depois `git push -u origin main`, ou criar outro repositório vazio |
| Codespace lento ou não abre | Franquia esgotada ou região sobrecarregada | Verificar em github.com/codespaces; parar Codespaces antigos |
| Os arquivos não estão no Codespace | Codespace anterior foi **excluído** (não só parado) | Criar outro Codespace; o `setup.sh` recria os labs no estado inicial. O trabalho publicado no GitHub continua disponível lá |

## Ajustes fáceis

- **Mudar o tema das receitas:** só `scripts/labs.sh`. As verificações dependem de alguns nomes de arquivo e de trechos (`45,00`, `2 batatas`, `manteiga`); procure em `scripts/checks.sh` antes de trocar.
- **Adicionar um desafio:** acrescente o nome em `LAB_NOMES` (`scripts/lib.sh`), uma função `gerar_NN` em `labs.sh`, uma `verificar_NN` em `checks.sh`, o enunciado em `exercises/` e um bloco em `tests/solucoes.sh`. Ajuste `ULTIMO_LAB_LOCAL` se o desafio for local.
- **Rodar os testes:** `tests/rodar.sh` (precisa de Docker). Rode sempre que mexer em `labs.sh` ou `checks.sh`.

## Encerramento

1. `check.sh 14` e `check.sh 15` para conferir que o trabalho está no GitHub.
2. Parar ou excluir o Codespace. Reforce: **parado ainda consome armazenamento**; excluído não. Os labs são descartáveis.
3. Próximos passos sugeridos: [Pro Git](https://git-scm.com/book/pt-br/v2) (gratuito, em português), [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR) (interativo), e contribuir com um projeto open source pequeno via pull request.

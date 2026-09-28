# Ementa — Curso de Git no GitHub Codespaces

| Item | Definição |
|---|---|
| Formato | Aula síncrona via Zoom, com prática no Codespace individual de cada pessoa |
| Duração | 3 horas |
| Turma | Cerca de 100 pessoas |
| Público | Iniciantes, sem experiência prévia com Git |
| Pré-requisitos | Conta GitHub pessoal e navegador atualizado |
| Preparação | Criar um Codespace em branco e executar o comando de instalação antes do dia da aula |

## Objetivos de aprendizagem

Ao final, a pessoa deverá ser capaz de:

- explicar as três áreas do Git: diretório de trabalho, staging area e repositório;
- criar commits bem delimitados, com mensagens claras;
- investigar o histórico de um projeto;
- desfazer mudanças com segurança, antes e depois do commit;
- trabalhar com branches e resolver conflitos de merge;
- sincronizar com um repositório remoto e abrir um pull request;
- contribuir com outro projeto usando fork, clone e PR para o repositório original.

## Conteúdo por módulo

| Módulo | Conteúdo |
|---|---|
| 1. Fundamentos | O que é controle de versão; commit como snapshot; as três áreas; `init`, `status`; identidade (`config`) |
| 2. Registrando mudanças | `add`, `commit`, `diff`, `diff --staged`, `log`; o que é uma boa mensagem de commit |
| 2b. Staging seletivo | Commits pequenos e coesos; `add -p`; `.gitignore`; `rm --cached` |
| 3. Histórico | `log --oneline --graph`, `show`, `blame`, `log -S`, `log --author`, `log -- arquivo` |
| 3b. Desfazendo | `restore`, `restore --staged`, `commit --amend`, `revert`; por que não reescrever o histórico compartilhado |
| 4. Branches | Branch como ponteiro; `HEAD`; `switch`; merge fast-forward e de três vias; `branch -d` |
| 4b. Stash | Guardar trabalho pela metade para trocar de contexto |
| 5. Conflitos | Por que acontecem; marcadores; resolução; `merge --abort` |
| 6. Remotos | Local e remoto; `origin`; `clone`; `fetch` e `pull`; `push`; upstream; ahead/behind |
| 7. Fluxo no GitHub | Branch, push, pull request, merge na web, pull, fork, clone e remoto `upstream` |

## Cronograma

| Horário | Bloco | Conteúdo |
|---|---|---|
| 0:00–0:10 | Abertura | Logística do Zoom, abrir o Codespace, **Desafio 0** (identidade) guiado |
| 0:10–0:18 | Módulo 1 | Controle de versão, commits como snapshots, as três áreas, `init`, `status` |
| 0:18–0:24 | **Desafio 1** | Meu primeiro repositório |
| 0:24–0:30 | Módulo 2 | `add`, `commit`, `diff`, `diff --staged`, `log`, boas mensagens |
| 0:30–0:36 | **Desafio 2** | Registrando mudanças |
| 0:36–0:40 | Módulo 2b | Commits pequenos e coesos, `.gitignore` |
| 0:40–0:45 | **Desafio 3** | Commit cirúrgico |
| 0:45–0:50 | **Desafio 4** ⏱ | Ignorando o que não importa |
| 0:50–0:55 | Módulo 3 | `log --oneline --graph`, `show`, `blame`, `log -S`, `log --author` |
| 0:55–1:01 | **Desafio 5** | Detetive do histórico |
| 1:01–1:07 | Módulo 3b | `restore`, `restore --staged`, `commit --amend`, `revert` |
| 1:07–1:12 | **Desafio 6** | Desfazendo antes do commit |
| 1:12–1:18 | **Desafio 7** | Desfazendo depois do commit |
| 1:18–1:28 | Intervalo | |
| 1:28–1:35 | Módulo 4 | Branch como ponteiro, `HEAD`, `switch`, merge fast-forward e de três vias |
| 1:35–1:40 | **Desafio 8** | Branch de funcionalidade |
| 1:40–1:46 | **Desafio 9** | Caminhos que divergem |
| 1:46–1:49 | Módulo 4b | Stash |
| 1:49–1:54 | **Desafio 10** ⏱ | Guardando para depois |
| 1:54–1:59 | Módulo 5 | Conflitos: por que acontecem, marcadores, resolução, `merge --abort` |
| 1:59–2:06 | **Desafio 11** | Resolva o conflito |
| 2:06–2:12 | Módulo 6 | Local e remoto, `origin`, `clone`, `fetch` e `pull`, `push`, upstream, ahead/behind |
| 2:12–2:18 | **Desafio 12** | O colega invisível |
| 2:18–2:25 | **Desafio 13** | Conflito com o colega |
| 2:25–2:30 | **Desafio 14** | Publique no GitHub |
| 2:30–2:33 | Módulo 7 | Branch, push, pull request, merge, pull |
| 2:33–2:40 | **Desafio 15** ⏱ | Seu primeiro pull request |
| 2:40–2:55 | **Desafio 16** | Contribua com um fork |
| 2:55–3:00 | Encerramento | Salvar o trabalho, parar ou excluir o Codespace, próximos passos |

### Distribuição do tempo

| Tipo de bloco | Minutos |
|---|---:|
| Desafios (1 a 16) | 102 |
| Conteúdo expositivo | 53 |
| Abertura (inclui Desafio 0) | 10 |
| Intervalo | 10 |
| Encerramento | 5 |
| **Total** | **180** |

### Folga de tempo

O cronograma ocupa as 3 horas previstas. Se houver atraso, os desafios **4, 10 e 15** (⏱) podem ficar como tarefa para depois da aula, liberando até 17 minutos.

## Os 17 desafios

Os desafios 1 a 14 ficam em `~/labs/NN-nome/`, cada um com seu próprio histórico Git. No desafio 0, o aluno configura sua identidade global no Git. O desafio 15 usa a mesma pasta do 14, cujo conteúdo foi publicado em um novo repositório na conta GitHub do aluno. No desafio 16, o aluno faz um fork de `fsilva-alt/receitas-de-pizza` e o clona em `~/labs/16-contribua-com-um-fork`; a conferência é manual pelo PR no projeto original. Os enunciados completos estão em `exercises/`.

| # | Desafio | Tempo | Estado inicial | Tarefa | Verificação |
|---|---|---:|---|---|---|
| 0 | Configure sua identidade | 3 | Git sem `user.name`/`user.email` | `git config --global` para nome e e-mail | Identidade definida e diferente do exemplo |
| 1 | Meu primeiro repositório | 6 | Pasta com 3 receitas, sem `.git` | `init`, `status`, `add` (um e depois todos), primeiro commit | Repositório com ≥1 commit e árvore limpa |
| 2 | Registrando mudanças | 6 | Repositório com 1 commit | Ciclo editar/`diff`/`add`/`diff --staged`/`commit`, 3 vezes | ≥4 commits, mensagens distintas, árvore limpa |
| 3 | Commit cirúrgico | 5 | 2 arquivos modificados, sem relação | Um commit por arquivo | Cada commit toca 1 arquivo; extra: `add -p` |
| 4 | Ignorando o que não importa ⏱ | 5 | `*.log`, `build/`, `.env` soltos | Criar e commitar `.gitignore`, `check-ignore -v` | Tudo ignorado; extra: `rm --cached` de log rastreado |
| 5 | Detetive do histórico | 6 | 12 commits de 4 autores | Responder 3 perguntas em `respostas.txt` | Respostas conferem |
| 6 | Desfazendo antes do commit | 5 | Arquivo estragado + arquivo na staging por engano | `restore` e `restore --staged` | Arquivo original, staging vazia, nenhum commit |
| 7 | Desfazendo depois do commit | 6 | Último commit com erro de digitação; commit antigo com bug | `commit --amend`, `revert` | Mensagem corrigida, bug removido, commit antigo preservado |
| 8 | Branch de funcionalidade | 5 | `main` com 2 commits | `switch -c`, 2 commits, voltar, merge fast-forward | `main` tem os commits, sem merge commit |
| 9 | Caminhos que divergem | 6 | `main` e `feature/bebidas` divergiram | Merge de três vias, `log --graph --all`, `branch -d` | Existe merge commit, branch removida |
| 10 | Guardando para depois ⏱ | 5 | Trabalho pela metade + urgência na `main` | `stash`, corrigir na `main`, `stash pop` | Correção na `main`, trabalho recuperado, stash vazio |
| 11 | Resolva o conflito | 7 | `main` e `ajuste-preco` mudam a mesma linha | Merge, resolver, `add`, `commit`; extra: `merge --abort` | Sem marcadores, merge concluído |
| 12 | O colega invisível | 6 | Clone de um bare local | Commit, `colega.sh 12`, push rejeitado, `pull`, `push` | Remoto tem os dois commits |
| 13 | Conflito com o colega | 7 | Mesmo cenário, mesma linha | `fetch`, `log main..origin/main`, `pull`, resolver, `push` | Remoto atualizado, sem marcadores |
| 14 | Publique no GitHub | 5 | Repositório local sem remoto | Criar `aprendizados.md`, commit, criar repositório vazio no GitHub, `remote add`, `push -u` | `HEAD` = `origin/main`, upstream definido |
| 15 | Seu primeiro pull request ⏱ | 7 | Mesma pasta, já ligada ao GitHub | Branch, `push -u`, PR, merge na web, `pull`, `branch -d` | `main` sincronizada, branch apagada |
| 16 | Contribua com um fork | 15 | Repositório público `fsilva-alt/receitas-de-pizza` | Fork, clone, `upstream`, receita em uma branch, push no fork e PR para o original | Manual: remotos corretos, branch publicada e PR com a receita para a `main` do original |

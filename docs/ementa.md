# Ementa — Curso de Git no GitHub Codespaces

| Item | Definição |
|---|---|
| Formato | Aula síncrona via Zoom, com prática no Codespace individual de cada pessoa |
| Duração | 3 horas |
| Turma | Cerca de 100 pessoas |
| Público | Iniciantes, sem experiência prévia com Git |
| Pré-requisitos | Conta GitHub pessoal e navegador atualizado |
| Preparação | Criar um Codespace em branco e rodar o instalador de uma linha antes do dia da aula |

## Objetivos de aprendizagem

Ao final, a pessoa deverá ser capaz de:

- explicar as três áreas do Git: diretório de trabalho, staging area e repositório;
- criar commits bem delimitados, com mensagens claras;
- investigar o histórico de um projeto;
- desfazer mudanças com segurança, antes e depois do commit;
- trabalhar com branches e resolver conflitos de merge;
- sincronizar com um repositório remoto e abrir um pull request.

## Conteúdo por módulo

| Módulo | Conteúdo |
|---|---|
| 1. Fundamentos | O que é controle de versão; commit como snapshot; as três áreas; `init`, `status`; identidade (`config`) |
| 2. Registrando mudanças | `add`, `commit`, `diff`, `diff --staged`, `log`; o que é uma boa mensagem de commit |
| 2b. Staging seletivo | Commits pequenos e coesos; `add -p`; `.gitignore`; `rm --cached` |
| 3. Histórico | `log --oneline --graph`, `show`, `blame`, `log -S`, `log --author`, `log -- arquivo` |
| 3b. Desfazendo | `restore`, `restore --staged`, `commit --amend`, `revert`; por que não reescrever histórico compartilhado |
| 4. Branches | Branch como ponteiro; `HEAD`; `switch`; merge fast-forward e de três vias; `branch -d` |
| 4b. Stash | Guardar trabalho pela metade para trocar de contexto |
| 5. Conflitos | Por que acontecem; marcadores; resolução; `merge --abort` |
| 6. Remotos | Local e remoto; `origin`; `clone`; `fetch` e `pull`; `push`; upstream; ahead/behind |
| 7. Fluxo no GitHub | Branch, push, pull request, merge na web, pull |

## Cronograma

| Horário | Bloco | Conteúdo |
|---|---|---|
| 0:00–0:10 | Abertura | Logística do Zoom, abrir o Codespace, **Desafio 0** (identidade) guiado |
| 0:10–0:20 | Módulo 1 | Controle de versão, commits como snapshots, as três áreas, `init`, `status` |
| 0:20–0:26 | **Desafio 1** | Meu primeiro repositório |
| 0:26–0:33 | Módulo 2 | `add`, `commit`, `diff`, `diff --staged`, `log`, boas mensagens |
| 0:33–0:39 | **Desafio 2** | Registrando mudanças |
| 0:39–0:44 | Módulo 2b | Commits pequenos e coesos, `.gitignore` |
| 0:44–0:49 | **Desafio 3** | Commit cirúrgico |
| 0:49–0:54 | **Desafio 4** ⏱ | Ignorando o que não importa |
| 0:54–1:00 | Módulo 3 | `log --oneline --graph`, `show`, `blame`, `log -S`, `log --author` |
| 1:00–1:06 | **Desafio 5** | Detetive do histórico |
| 1:06–1:13 | Módulo 3b | `restore`, `restore --staged`, `commit --amend`, `revert` |
| 1:13–1:18 | **Desafio 6** | Desfazendo antes do commit |
| 1:18–1:24 | **Desafio 7** | Desfazendo depois do commit |
| 1:24–1:34 | Intervalo | |
| 1:34–1:43 | Módulo 4 | Branch como ponteiro, `HEAD`, `switch`, merge fast-forward e de três vias |
| 1:43–1:48 | **Desafio 8** | Branch de funcionalidade |
| 1:48–1:54 | **Desafio 9** | Caminhos que divergem |
| 1:54–1:58 | Módulo 4b | Stash |
| 1:58–2:03 | **Desafio 10** ⏱ | Guardando para depois |
| 2:03–2:09 | Módulo 5 | Conflitos: por que acontecem, marcadores, resolução, `merge --abort` |
| 2:09–2:16 | **Desafio 11** | Resolva o conflito |
| 2:16–2:25 | Módulo 6 | Local e remoto, `origin`, `clone`, `fetch` e `pull`, `push`, upstream, ahead/behind |
| 2:25–2:31 | **Desafio 12** | O colega invisível |
| 2:31–2:38 | **Desafio 13** | Conflito com o colega |
| 2:38–2:43 | **Desafio 14** | Publique no GitHub |
| 2:43–2:48 | Módulo 7 | Branch, push, pull request, merge, pull |
| 2:48–2:55 | **Desafio 15** ⏱ | Seu primeiro pull request |
| 2:55–3:00 | Encerramento | Salvar o trabalho, parar ou excluir o Codespace, próximos passos |

### Distribuição do tempo

| Tipo de bloco | Minutos |
|---|---:|
| Desafios (1 a 15) | 87 |
| Conteúdo expositivo | 68 |
| Abertura (inclui Desafio 0) | 10 |
| Intervalo | 10 |
| Encerramento | 5 |
| **Total** | **180** |

### Folga de tempo

O cronograma fecha em exatamente 3 horas. Os desafios **4, 10 e 15** (⏱) são **elásticos**: permanecem na lista, mas viram tarefa pós-aula se houver atraso. Isso libera até 17 minutos.

## Os 16 desafios

Os desafios 1 a 14 ficam em `~/labs/NN-nome/`, cada um com seu próprio histórico Git. O desafio 0 é configuração global do Git, e o 15 continua na pasta do 14, que o aluno publica num repositório novo da própria conta GitHub. Os enunciados completos estão em `exercises/`.

| # | Desafio | Tempo | Estado inicial | Tarefa | Verificação |
|---|---|---:|---|---|---|
| 0 | Configure sua identidade | 3 | Git sem `user.name`/`user.email` | `git config --global` para nome e e-mail | Identidade definida e diferente do exemplo |
| 1 | Meu primeiro repositório | 6 | Pasta com 3 receitas, sem `.git` | `init`, `status`, `add` (um e depois todos), primeiro commit | Repositório com ≥1 commit e árvore limpa |
| 2 | Registrando mudanças | 6 | Repositório com 1 commit | Ciclo editar/`diff`/`add`/`diff --staged`/`commit`, 3 vezes | ≥4 commits, mensagens distintas, árvore limpa |
| 3 | Commit cirúrgico | 5 | 2 arquivos modificados, sem relação | Um commit por arquivo | Cada commit toca 1 arquivo; extra: `add -p` |
| 4 | Ignorando o que não importa ⏱ | 5 | `*.log`, `build/`, `.env` soltos | Criar e commitar `.gitignore`, `check-ignore -v` | Tudo ignorado; extra: `rm --cached` de log rastreado |
| 5 | Detetive do histórico | 6 | 12 commits de 4 autores | Responder 3 perguntas em `respostas.txt` | Respostas conferem |
| 6 | Desfazendo antes do commit | 5 | Arquivo estragado + arquivo na staging por engano | `restore` e `restore --staged` | Arquivo original, staging vazia, nenhum commit |
| 7 | Desfazendo depois do commit | 6 | Último commit com typo; commit antigo com bug | `commit --amend`, `revert` | Mensagem corrigida, bug removido, commit antigo preservado |
| 8 | Branch de funcionalidade | 5 | `main` com 2 commits | `switch -c`, 2 commits, voltar, merge fast-forward | `main` tem os commits, sem merge commit |
| 9 | Caminhos que divergem | 6 | `main` e `feature/bebidas` divergiram | Merge de três vias, `log --graph --all`, `branch -d` | Existe merge commit, branch removida |
| 10 | Guardando para depois ⏱ | 5 | Trabalho pela metade + urgência na `main` | `stash`, corrigir na `main`, `stash pop` | Correção na `main`, trabalho recuperado, stash vazio |
| 11 | Resolva o conflito | 7 | `main` e `ajuste-preco` mudam a mesma linha | Merge, resolver, `add`, `commit`; extra: `merge --abort` | Sem marcadores, merge concluído |
| 12 | O colega invisível | 6 | Clone de um bare local | Commit, `colega.sh 12`, push rejeitado, `pull`, `push` | Remoto tem os dois commits |
| 13 | Conflito com o colega | 7 | Mesmo cenário, mesma linha | `fetch`, `log main..origin/main`, `pull`, resolver, `push` | Remoto atualizado, sem marcadores |
| 14 | Publique no GitHub | 5 | Repositório local sem remoto | Criar `aprendizados.md`, commit, criar repositório vazio no GitHub, `remote add`, `push -u` | `HEAD` = `origin/main`, upstream definido |
| 15 | Seu primeiro pull request ⏱ | 7 | Mesma pasta, já ligada ao GitHub | Branch, `push -u`, PR, merge na web, `pull`, `branch -d` | `main` sincronizada, branch apagada |

# Desafio 0 — Configure sua identidade

⏱ 3 minutos · feito junto com o professor, na abertura

## Objetivo

Configurar o nome e o e-mail usados para identificar a autoria dos seus commits. O Git precisa desses dados para criar um commit.

## Onde

Em qualquer pasta. A configuração é **global**, ou seja, vale para todos os repositórios deste Codespace.

## Os três níveis de configuração

O Git lê a mesma configuração em três arquivos diferentes. Do mais abrangente para o mais específico:

| Nível | Arquivo | Vale para | Quando usar |
|---|---|---|---|
| `--system` | `/etc/gitconfig` | **Todos os usuários** da máquina | Quase nunca; precisa de `sudo` |
| `--global` | `~/.gitconfig` | Todos os repositórios **do seu usuário** | O normal — é o que vamos usar |
| `--local` | `.git/config` do repositório | **Só aquele repositório** | Quando um projeto precisa de outra identidade (e-mail do trabalho, por exemplo) |

A configuração mais específica tem prioridade: se você definir `user.email` nos três níveis, o commit usará o valor de `--local` naquele repositório.

Para descobrir de onde veio cada valor:

```bash
git config --list --show-origin
```

## Tarefa

1. Configure seu nome (use o seu, não o do exemplo):

   ```bash
   git config --global user.name "Fulano de Tal"
   ```

2. Configure seu e-mail. Use o mesmo da sua conta GitHub, para que os commits apareçam ligados ao seu perfil:

   ```bash
   git config --global user.email fulanodetal@exemplo.pt
   ```

3. Confira o que ficou gravado:

   ```bash
   git config --global --list
   ```

   Além do nome e do e-mail, você vai ver três ajustes que o instalador do curso já fez por você:

   | Configuração | Para quê |
   |---|---|
   | `init.defaultBranch=main` | Repositórios novos começam na branch `main` |
   | `core.editor=code --wait` | Quando o Git precisar de uma mensagem, abre o VS Code em vez do Vim |
   | `pull.rebase=false` | `git pull` integra as mudanças com um merge, como vamos aprender na aula |

## Verificação

```bash
check.sh 00
```

A verificação **recusa** nomes e e-mails de exemplo (`Fulano de Tal`, `Seu Nome`, `voce@…`, qualquer `@exemplo.*`). Substitua esses valores pelos seus dados antes de executar os comandos.

## Dica

Se errar o nome ou o e-mail, rode o comando de novo com o valor correto para substituir o anterior.

## Missão extra

Entre em qualquer pasta com repositório e rode:

```bash
git config --local user.email outro@exemplo.com
git config user.email          # sem nível: mostra o valor que vale ali
git config --global user.email # continua o seu
```

Compare as saídas: neste repositório, o e-mail local tem prioridade sobre o global. Remova a configuração local com `git config --local --unset user.email`.

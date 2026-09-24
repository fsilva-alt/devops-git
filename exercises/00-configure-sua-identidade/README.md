# Desafio 0 — Configure sua identidade

⏱ 3 minutos · feito junto com o professor, na abertura

## Objetivo

Dizer ao Git quem você é. Cada commit carrega o nome e o e-mail de quem o fez, e o Git se recusa a fazer commit sem essa informação.

## Onde

Em qualquer pasta. A configuração é **global**, ou seja, vale para todos os repositórios deste Codespace.

## Os três níveis de configuração

O Git lê a mesma configuração em três arquivos diferentes. Do mais abrangente para o mais específico:

| Nível | Arquivo | Vale para | Quando usar |
|---|---|---|---|
| `--system` | `/etc/gitconfig` | **Todos os usuários** da máquina | Quase nunca; precisa de `sudo` |
| `--global` | `~/.gitconfig` | Todos os repositórios **do seu usuário** | O normal — é o que vamos usar |
| `--local` | `.git/config` do repositório | **Só aquele repositório** | Quando um projeto precisa de outra identidade (e-mail do trabalho, por exemplo) |

O mais específico vence: se você definir `user.email` nos três, o `--local` é o que assina o commit daquele repositório.

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

A verificação **recusa** nomes e e-mails de exemplo (`Fulano de Tal`, `Seu Nome`, `voce@…`, qualquer `@exemplo.*`). Copiar e colar sem trocar os valores reprova de propósito: quem assina os commits é você.

## Dica

Se errar alguma coisa, é só rodar o comando de novo com o valor certo. O último vence.

## Missão extra

Entre em qualquer pasta com repositório e rode:

```bash
git config --local user.email outro@exemplo.com
git config user.email          # sem nível: mostra o valor que vale ali
git config --global user.email # continua o seu
```

Viu o `--local` ganhar? Desfaça com `git config --local --unset user.email`.

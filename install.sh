#!/bin/sh
# Instalador do Curso de Git.
#
# Num Codespace em branco (ou em qualquer Linux com git e gh), rode:
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fsilva-alt/devops-git/main/install.sh)"
#
# O que ele faz:
#   1. vai para a sua pasta home;
#   2. baixa o curso para ~/devops-git (ou atualiza, se já existir);
#   3. gera os laboratórios em ~/labs (sem apagar os que já existem);
#   4. autentica no GitHub pelo navegador (ou reutiliza o login salvo);
#   5. configura PATH e autenticação nos terminais bash e zsh;
#   6. mostra os próximos passos.
#
# Pode ser rodado de novo sem medo: é idempotente.
#
# Variáveis opcionais: CURSO_REPO (URL ou caminho do repositório), CURSO_RAMO,
# CURSO_DIR (padrão ~/devops-git) e LABS_DIR (padrão ~/labs).
# CURSO_AUTH_GITHUB=0 pula a autenticação (para testes locais sem GitHub).

set -eu

CURSO_REPO="${CURSO_REPO:-https://github.com/fsilva-alt/devops-git.git}"
CURSO_RAMO="${CURSO_RAMO:-main}"
CURSO_DIR="${CURSO_DIR:-$HOME/devops-git}"
LABS_DIR="${LABS_DIR:-$HOME/labs}"
export LABS_DIR
CURSO_AUTH_GITHUB="${CURSO_AUTH_GITHUB:-1}"

passo() { printf '\033[34m▶\033[0m %s\n' "$*"; }
falha() { printf '\n\033[31m❌ %s\033[0m\n' "$*" >&2; exit 1; }

command -v git  >/dev/null 2>&1 || falha "O git não está instalado. Num Codespace ele já vem; em outra máquina, instale-o primeiro."
command -v bash >/dev/null 2>&1 || falha "O bash não está instalado; os scripts do curso precisam dele."
case "$CURSO_AUTH_GITHUB" in
  1) command -v gh >/dev/null 2>&1 || falha "O GitHub CLI (gh) não está instalado. Num Codespace ele já vem; em outra máquina, instale-o: https://cli.github.com" ;;
  0) ;;
  *) falha "CURSO_AUTH_GITHUB deve ser 1 (padrão) ou 0 (testes locais sem GitHub)." ;;
esac

cd "$HOME"

# --- 1. Baixar ou atualizar o curso -------------------------------------------
if [ -d "$CURSO_DIR/.git" ]; then
  passo "Atualizando o curso em $CURSO_DIR"
  git -C "$CURSO_DIR" pull -q --ff-only 2>/dev/null \
    || falha "Não consegui atualizar $CURSO_DIR. Se você mexeu nessa pasta, apague-a e rode o instalador de novo."
else
  passo "Baixando o curso para $CURSO_DIR"
  git clone -q --depth 1 -b "$CURSO_RAMO" "$CURSO_REPO" "$CURSO_DIR" 2>/dev/null \
    || falha "Não consegui clonar $CURSO_REPO. Verifique a conexão e o endereço."
fi

# --- 2. Gerar os laboratórios ----------------------------------------------------
passo "Preparando os laboratórios em $LABS_DIR"
bash "$CURSO_DIR/scripts/setup.sh"

# --- 3. Autenticação para os repositórios dos desafios 14–16 --------------------
if [ "$CURSO_AUTH_GITHUB" = 1 ]; then
  passo "Preparando o acesso ao GitHub para publicar seus repositórios"
  # O token automático do Codespace pode não ter acesso ao novo repo ou fork.
  # As variáveis têm prioridade sobre as credenciais salvas pelo gh.
  unset GH_TOKEN GITHUB_TOKEN
  if gh auth status --active --hostname github.com >/dev/null 2>&1; then
    passo "Reutilizando o login salvo no GitHub CLI"
  else
    [ -t 0 ] || falha "O login no GitHub precisa de um terminal interativo. Rode o install.sh novamente no terminal do Codespace. Para testes locais, use CURSO_AUTH_GITHUB=0."
    printf '\nAutorize o GitHub CLI com a conta que você usará nos desafios.\n'
    printf 'Siga o código e o endereço exibidos abaixo para entrar pelo navegador.\n\n'
    gh auth login --hostname github.com --git-protocol https --web \
      || falha "O login no GitHub não foi concluído. Rode o install.sh novamente para continuar; seus laboratórios serão preservados."
  fi
  gh auth setup-git --hostname github.com \
    || falha "Não consegui configurar o Git para usar o login do gh. Rode o install.sh novamente."
  gh auth status --active --hostname github.com \
    || falha "O login no GitHub não está válido. Rode o install.sh novamente para autenticar."
fi

# --- 4. Comandos no PATH e login nos novos terminais -----------------------------
BLOCO_INICIO='# >>> curso de git >>>'
BLOCO_FIM='# <<< curso de git <<<'
AUTH_LINHA='if [ "${CODESPACES:-}" = "true" ]; then unset GH_TOKEN GITHUB_TOKEN; fi'
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  # .bashrc é criado se não existir; .zshrc só é alterado se já existir
  if [ ! -f "$rc" ] && [ "$rc" != "$HOME/.bashrc" ]; then continue; fi
  if ! grep -qF "$BLOCO_INICIO" "$rc" 2>/dev/null; then
    {
      printf '\n%s\n' "$BLOCO_INICIO"
      printf 'export PATH="%s/scripts:$PATH"\n' "$CURSO_DIR"
      if [ "$LABS_DIR" != "$HOME/labs" ]; then printf 'export LABS_DIR="%s"\n' "$LABS_DIR"; fi
      printf '%s\n' "$BLOCO_FIM"
    } >> "$rc"
  fi
  # Atualiza também instalações antigas, preservando o restante do arquivo.
  # Fora do Codespaces, mantém as variáveis de autenticação do usuário.
  if [ "$CURSO_AUTH_GITHUB" = 1 ] && ! grep -qxF "$AUTH_LINHA" "$rc"; then
    sed -i "/^$BLOCO_FIM$/i\\$AUTH_LINHA" "$rc"
  fi
done

# --- 5. Mensagem final ----------------------------------------------------------------
n_labs=$(find "$LABS_DIR" -mindepth 1 -maxdepth 1 -type d -name '[0-9][0-9]-*' | wc -l | tr -d ' ')
printf '\n'
printf '\033[32m╭──────────────────────────────────────────────────────╮\033[0m\n'
printf '\033[32m│  ✅ Curso de Git instalado com sucesso!              │\033[0m\n'
printf '\033[32m╰──────────────────────────────────────────────────────╯\033[0m\n'
printf '\n'
printf '  Curso (enunciados, docs):  %s\n' "$CURSO_DIR"
printf '  Laboratórios:              %s  (%s desafios prontos)\n' "$LABS_DIR" "$n_labs"
if [ "$CURSO_AUTH_GITHUB" = 1 ]; then
  printf '  GitHub:                    login configurado para os desafios 14–16\n'
else
  printf '  GitHub:                    autenticação pulada (CURSO_AUTH_GITHUB=0)\n'
fi
printf '\n'
printf '  Próximos passos:\n'
printf '  1. Abra um terminal novo para carregar o PATH e a autenticação.\n'
printf '     Ou rode: source ~/.bashrc (bash) / source ~/.zshrc (zsh)\n'
printf '  2. Abra o guia do curso:             code %s/README.md\n' "$CURSO_DIR"
printf '  3. Faça o primeiro desafio:          check.sh 00\n'
printf '\n'

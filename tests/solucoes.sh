#!/usr/bin/env bash
# Suíte de testes DE DESENVOLVIMENTO do curso (não é usada na aula).
#
# Para cada desafio, exercita três situações e confere a resposta de check.sh:
#   vazio  -> o aluno não fez nada: deve reprovar;
#   errado -> o aluno fez algo plausível, mas incorreto: deve reprovar com a dica certa;
#   certo  -> a solução do gabarito: deve aprovar (e reconhecer a missão extra, quando há).
#
# Roda dentro do container de tests/Dockerfile (veja tests/rodar.sh), que imita um
# Codespace em branco: a primeira etapa é o próprio install.sh, apontado para uma
# cópia da árvore de trabalho atual. Também funciona em qualquer máquina com git,
# desde que HOME seja descartável (o instalador escreve em ~/devops-git, ~/labs,
# ~/.bashrc e ~/.zshrc). Os desafios 14 e 15 usam um bare local no papel do GitHub.

set -euo pipefail

FONTE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # o repositório em desenvolvimento
export GIT_EDITOR=true          # o aluno usa "code --wait"; aqui só fechamos o editor
export LANG=C.UTF-8
unset LABS_DIR                  # o instalador decide (~/labs)

if [[ -t 1 ]]; then C_VERDE=$'\e[32m'; C_VERM=$'\e[31m'; C_NEG=$'\e[1m'; C_FIM=$'\e[0m'; else C_VERDE=""; C_VERM=""; C_NEG=""; C_FIM=""; fi
ok()   { printf '%s\n' "${C_VERDE}✅${C_FIM} $*"; }
erro() { printf '%s\n' "${C_VERM}❌${C_FIM} $*" >&2; }

TOTAL=0; OKS=0; FALHOU=0
CHECK=check.sh

passo() { printf '\n%s\n' "${C_NEG}== $*${C_FIM}"; }
conta_ok() { TOTAL=$((TOTAL + 1)); OKS=$((OKS + 1)); ok "$*"; }
conta_falha() { TOTAL=$((TOTAL + 1)); FALHOU=1; erro "$*"; }

# reprova NN "rótulo" ["trecho esperado na saída"]
reprova() {
  local nn="$1" rotulo="$2" trecho="${3:-}" saida
  if saida="$("$CHECK" "$nn" 2>&1)"; then
    conta_falha "$nn $rotulo: check.sh aprovou, mas deveria reprovar"; printf '%s\n' "$saida"; return
  fi
  if [[ -n "$trecho" ]] && ! grep -qF -- "$trecho" <<<"$saida"; then
    conta_falha "$nn $rotulo: reprovou, mas sem a dica esperada ('$trecho')"; printf '%s\n' "$saida"; return
  fi
  conta_ok "$nn $rotulo: reprova${trecho:+ e aponta '$trecho'}"
}

# aprova NN "rótulo" [extra]
aprova() {
  local nn="$1" rotulo="$2" extra="${3:-}" saida
  if ! saida="$("$CHECK" "$nn" 2>&1)"; then
    conta_falha "$nn $rotulo: check.sh reprovou, mas deveria aprovar"; printf '%s\n' "$saida"; return
  fi
  if [[ "$extra" == "extra" ]] && ! grep -q 'Missão extra: concluída' <<<"$saida"; then
    conta_falha "$nn $rotulo: aprovou, mas não reconheceu a missão extra"; printf '%s\n' "$saida"; return
  fi
  conta_ok "$nn $rotulo: aprova${extra:+ (com missão extra)}"
}

recomeca() { reset.sh "$1" >/dev/null; cd "$(lab_dir "$1")"; }

# ---------------------------------------------------------------------------
passo "Instalador (install.sh) num ambiente em branco"
rm -rf "$HOME/labs" "$HOME/devops-git"
git config --global --unset-all user.name  2>/dev/null || true
git config --global --unset-all user.email 2>/dev/null || true
sed -i '/# >>> curso de git >>>/,/# <<< curso de git <<</d' "$HOME/.bashrc" "$HOME/.zshrc" 2>/dev/null || true

# O "GitHub" de onde o curl baixaria: uma cópia commitada da árvore de trabalho atual
ORIGEM="$(mktemp -d)/devops-git"
mkdir -p "$ORIGEM"
cp -r "$FONTE_DIR"/. "$ORIGEM"
rm -rf "$ORIGEM/.git"
git -C "$ORIGEM" init -q -b main
git -C "$ORIGEM" -c user.name=dev -c user.email=dev@exemplo.com add -A
git -C "$ORIGEM" -c user.name=dev -c user.email=dev@exemplo.com commit -q -m "Versão em teste"

cd /tmp   # o instalador tem de funcionar de qualquer pasta (ele faz cd $HOME)
saida="$(CURSO_REPO="$ORIGEM" sh "$ORIGEM/install.sh" 2>&1)" \
  && conta_ok "install.sh roda com sh (POSIX) e termina sem erro" \
  || { conta_falha "install.sh falhou"; printf '%s\n' "$saida"; exit 1; }
grep -q 'instalado com sucesso' <<<"$saida" && conta_ok "install.sh mostra a mensagem de sucesso" \
  || conta_falha "install.sh não mostrou a mensagem de sucesso"
grep -q 'check.sh 00' <<<"$saida" && conta_ok "install.sh indica o primeiro desafio" \
  || conta_falha "install.sh não indicou o próximo passo"
[[ -x "$HOME/devops-git/scripts/check.sh" ]] && conta_ok "curso clonado em ~/devops-git" \
  || conta_falha "~/devops-git/scripts/check.sh não existe"
[[ -d "$HOME/labs/01-meu-primeiro-repositorio" && -d "$HOME/labs/14-publique-no-github" ]] \
  && conta_ok "laboratórios gerados em ~/labs" || conta_falha "laboratórios não foram gerados em ~/labs"
grep -q 'devops-git/scripts' "$HOME/.bashrc" && conta_ok "PATH adicionado ao ~/.bashrc" \
  || conta_falha "PATH não foi adicionado ao ~/.bashrc"
grep -q 'devops-git/scripts' "$HOME/.zshrc" && conta_ok "PATH adicionado ao ~/.zshrc" \
  || conta_falha "PATH não foi adicionado ao ~/.zshrc"
bash -ic 'command -v check.sh' >/dev/null 2>&1 && conta_ok "check.sh disponível num shell novo" \
  || conta_falha "check.sh não está no PATH de um shell novo"
[[ "$(git config --global pull.rebase)" == "false" ]] && conta_ok "setup.sh define pull.rebase=false" \
  || conta_falha "setup.sh não definiu pull.rebase"

# Rodar de novo: atualiza sem apagar nada e sem duplicar o PATH
touch "$HOME/labs/01-meu-primeiro-repositorio/marca"
saida="$(CURSO_REPO="$ORIGEM" sh "$ORIGEM/install.sh" 2>&1)" && grep -q 'Atualizando' <<<"$saida" \
  && conta_ok "install.sh rodado de novo atualiza em vez de clonar" || conta_falha "segunda execução do install.sh"
[[ -f "$HOME/labs/01-meu-primeiro-repositorio/marca" ]] && conta_ok "segunda execução preserva os labs" \
  || conta_falha "segunda execução apagou os labs"
(( $(grep -c '# >>> curso de git >>>' "$HOME/.bashrc") == 1 )) && conta_ok "PATH não duplicado no ~/.bashrc" \
  || conta_falha "bloco do PATH duplicado no ~/.bashrc"
rm -f "$HOME/labs/01-meu-primeiro-repositorio/marca"

# Daqui em diante, tudo usa a instalação feita pelo aluno
CURSO_DIR="$HOME/devops-git"
export PATH="$CURSO_DIR/scripts:$PATH"
source "$CURSO_DIR/scripts/lib.sh"   # LABS_DIR, lab_dir, cores

# ---------------------------------------------------------------------------
passo "Desafio 00 — Configure sua identidade"
reprova 00 vazio "user.name não está configurado"
git config --global user.name "Fulano de Tal"
git config --global user.email fulanodetal@exemplo.pt
reprova 00 "errado (exemplo do enunciado)" "ainda é um exemplo"
git config --global user.name "Seu Nome"
git config --global user.email voce@exemplo.com
reprova 00 "errado (placeholder genérico)" "ainda é um exemplo"
git config --global user.name "Aluna Teste"
git config --global user.email "aluna-sem-arroba"
reprova 00 "errado (e-mail inválido)" "não parece um e-mail"
git config --global user.email aluna.teste@gmail.com
aprova 00 certo

# ---------------------------------------------------------------------------
passo "Desafio 01 — Meu primeiro repositório"
reprova 01 vazio "ainda não é um repositório"
cd "$(lab_dir 01)"
git init -q
git add bolo-de-cenoura.md
reprova 01 "errado (add sem commit)" "não tem nenhum commit"
git commit -q -m "Adiciona o bolo"
reprova 01 "errado (faltou adicionar arquivos)" "não rastreados"
recomeca 01
git init -q
git add bolo-de-cenoura.md
git status --short | grep -q '^A  bolo'
git add .
git commit -q -m "Cria o livro de receitas"
aprova 01 certo

# ---------------------------------------------------------------------------
passo "Desafio 02 — Registrando mudanças"
reprova 02 vazio "pede pelo menos 4"
cd "$(lab_dir 02)"
for i in 1 2 3; do echo "- linha $i" >> bolo-de-cenoura.md; git commit -q -am "mudança"; done
reprova 02 "errado (mensagens repetidas)" "repetidas"
recomeca 02
echo "- 1 pitada de canela" >> bolo-de-cenoura.md
git commit -q -am "Adiciona canela ao bolo"
echo "- Sirva quente" >> pao-de-queijo.md
reprova 02 "errado (mudança sem commit)" "não commitadas"
git commit -q -am "Adiciona dica de serviço ao pão de queijo"
echo "- Leite condensado de boa qualidade faz diferença" >> brigadeiro.md
git add brigadeiro.md
git diff --staged --quiet && conta_falha "02: diff --staged deveria mostrar algo"
git commit -q -m "Adiciona dica ao brigadeiro"
aprova 02 certo

# ---------------------------------------------------------------------------
passo "Desafio 03 — Commit cirúrgico"
reprova 03 vazio "esperava um para cada arquivo"
cd "$(lab_dir 03)"
git commit -q -am "Ajusta receitas"
reprova 03 "errado (um commit com os dois arquivos)" "toca 2 arquivos"
recomeca 03
git add bolo-de-cenoura.md
git commit -q -m "Corrige instrução de mistura do bolo"
git add brigadeiro.md
git commit -q -m "Adiciona pitada de sal ao brigadeiro"
aprova 03 certo
# Missão extra: duas mudanças no mesmo arquivo em commits separados
# (git add -p é interativo; simulamos o resultado final)
sed -i 's/^# Pão de queijo$/# Pão de queijo mineiro/' pao-de-queijo.md
git commit -q -am "Especifica a origem do pão de queijo"
echo "5. Sirva ainda quente." >> pao-de-queijo.md
git commit -q -am "Adiciona passo final ao pão de queijo"
aprova 03 "certo + extra" extra

# ---------------------------------------------------------------------------
passo "Desafio 04 — Ignorando o que não importa"
reprova 04 vazio ".gitignore ainda não foi commitado"
cd "$(lab_dir 04)"
printf '*.log\nbuild/\n' > .gitignore
git add .gitignore && git commit -q -m "Ignora logs e build"
reprova 04 "errado (esqueceu o .env)" "O arquivo .env não está sendo ignorado"
printf '*.log\nbuild/\n.env\n' > .gitignore
reprova 04 "errado (.gitignore alterado sem commit)" "não commitadas"
git commit -q -am "Ignora também o .env"
for p in debug.log build/livro.html .env; do git check-ignore -q "$p"; done
aprova 04 certo
git rm -q --cached antigo.log
git commit -q -m "Para de rastrear antigo.log"
[[ -f antigo.log ]] || conta_falha "04: rm --cached apagou o arquivo do disco"
aprova 04 "certo + extra" extra

# ---------------------------------------------------------------------------
passo "Desafio 05 — Detetive do histórico"
reprova 05 vazio "resposta 1 está em branco"
cd "$(lab_dir 05)"
hash_pao="$(git log --format=%h --diff-filter=A -- pao-caseiro.md)"
[[ "$(git log --format=%an -S'45,00' -- bolo-de-cenoura.md)" == "Carla Mendes" ]] \
  || conta_falha "05: o histórico gerado não tem Carla mudando o preço"

# responder R1 R2 R3  — preenche as três linhas "R:"
responder() {
  awk -v r1="$1" -v r2="$2" -v r3="$3" '
    /^R:/ { n++; print "R: " (n==1 ? r1 : n==2 ? r2 : r3); next } { print }' \
    respostas.txt > respostas.tmp && mv respostas.tmp respostas.txt
}
responder "Bruno Lima" "$hash_pao" "12"
reprova 05 "errado (autor errado)" "resposta 1"
git checkout -q respostas.txt
responder "Carla Mendes" "abc1234" "12"
reprova 05 "errado (hash errado)" "resposta 2"
git checkout -q respostas.txt
responder "Carla Mendes" "$hash_pao" "8"
reprova 05 "errado (porções erradas)" "resposta 3"
git checkout -q respostas.txt
responder "Carla Mendes" "$hash_pao" ""
reprova 05 "errado (uma resposta em branco)" "resposta 3 está em branco"
git checkout -q respostas.txt
responder "carla" "${hash_pao:0:7}" "12 porções"
aprova 05 "certo (variações aceitas)"
git checkout -q respostas.txt
responder "Carla Mendes" "$hash_pao" "12"
aprova 05 certo

# ---------------------------------------------------------------------------
passo "Desafio 06 — Desfazendo antes do commit"
reprova 06 vazio "git restore bolo-de-cenoura.md"
cd "$(lab_dir 06)"
git restore bolo-de-cenoura.md
reprova 06 "errado (staging ainda com o arquivo)" "staging area"
git commit -q -m "Adiciona notas"
reprova 06 "errado (commitou o arquivo errado)" "sem commit nenhum"
recomeca 06
git restore bolo-de-cenoura.md
git restore --staged notas-pessoais.md
aprova 06 certo
recomeca 06
reprova 06 "reset.sh devolve o estado inicial" "git restore bolo-de-cenoura.md"

# ---------------------------------------------------------------------------
passo "Desafio 07 — Desfazendo depois do commit"
reprova 07 vazio "pudin"
cd "$(lab_dir 07)"
bug="$(git log --format=%H --grep='Ajusta ingredientes do brigadeiro')"
git revert --no-edit "$bug" >/dev/null
git commit -q --amend -m "Adiciona receita de pudim"
reprova 07 "errado (revert antes do amend)" "erro de digitação"
recomeca 07
git commit -q --amend -m "Adiciona receita de pudim"
reprova 07 "errado (só o amend)" "ainda leva sal"
git reset -q --hard "$bug~1"
reprova 07 "errado (reset apagou o commit do bug)" "sumiu do histórico"
recomeca 07
git commit -q --amend -m "Adiciona receita de pudim"
bug="$(git log --format=%H --grep='Ajusta ingredientes do brigadeiro')"
git revert --no-edit "$bug" >/dev/null
aprova 07 certo

# ---------------------------------------------------------------------------
passo "Desafio 08 — Branch de funcionalidade"
reprova 08 vazio "sobremesas.md não está na main"
cd "$(lab_dir 08)"
printf '# Sobremesas\n\n- Pudim\n' > sobremesas.md
git add sobremesas.md && git commit -q -m "Cria lista de sobremesas"
printf -- '- Mousse\n' >> sobremesas.md && git commit -q -am "Adiciona mousse à lista"
reprova 08 "errado (commits direto na main)" "feature/sobremesas não existe"
recomeca 08
git switch -q -c feature/sobremesas
printf '# Sobremesas\n\n- Pudim\n' > sobremesas.md
git add sobremesas.md && git commit -q -m "Cria lista de sobremesas"
printf -- '- Mousse\n' >> sobremesas.md && git commit -q -am "Adiciona mousse à lista"
reprova 08 "errado (ficou na branch, sem merge)" "deveria terminar na 'main'"
git switch -q main
[[ ! -f sobremesas.md ]] || conta_falha "08: o arquivo deveria sumir na main antes do merge"
reprova 08 "errado (voltou para main, sem merge)" "sobremesas.md não está na main"
git merge -q feature/sobremesas
aprova 08 certo

# ---------------------------------------------------------------------------
passo "Desafio 09 — Caminhos que divergem"
reprova 09 vazio "Não há merge commit"
cd "$(lab_dir 09)"
git merge -q feature/bebidas
reprova 09 "errado (não apagou a branch)" "ainda existe"
recomeca 09
git branch -q -D feature/bebidas
reprova 09 "errado (apagou a branch sem merge)" "bebidas.md não está na main"
recomeca 09
git merge -q feature/bebidas
git branch -d -q feature/bebidas
aprova 09 certo

# ---------------------------------------------------------------------------
passo "Desafio 10 — Guardando para depois"
reprova 10 vazio "1800 graus"
cd "$(lab_dir 10)"
git switch -q main 2>/dev/null && conta_falha "10: o switch deveria ter sido bloqueado pelo Git"
git stash -q
git switch -q main
sed -i 's/1800 graus/180 graus/' bolo-de-cenoura.md
git commit -q -am "Corrige temperatura do forno"
reprova 10 "errado (esqueceu o stash na gaveta)" "guardado no stash"
git switch -q feature/sopas
git stash pop -q
aprova 10 certo
recomeca 10
git commit -q -am "Sopa pela metade"          # commitou em vez de guardar
git switch -q main
sed -i 's/1800 graus/180 graus/' bolo-de-cenoura.md
git commit -q -am "Corrige temperatura do forno"
reprova 10 "errado (terminou na main)" "deveria terminar na 'feature/sopas'"

# ---------------------------------------------------------------------------
passo "Desafio 11 — Resolva o conflito"
reprova 11 vazio "ainda não foi integrada"
cd "$(lab_dir 11)"
git merge -q ajuste-preco 2>/dev/null && conta_falha "11: o merge deveria ter conflitado"
grep -q '^<<<<<<<' bolo-de-cenoura.md || conta_falha "11: faltam marcadores de conflito"
reprova 11 "errado (merge pendente)" "ainda não foi concluído"
git add bolo-de-cenoura.md                     # commitou com os marcadores
git commit -q --no-edit
reprova 11 "errado (marcadores no commit)" "marcadores de conflito"
recomeca 11
git merge -q ajuste-preco 2>/dev/null || true
git merge --abort
[[ -z "$(git status --porcelain)" ]] || conta_falha "11: --abort deveria limpar a árvore"
reprova 11 "errado (só o --abort)" "ainda não foi integrada"
git merge -q ajuste-preco 2>/dev/null || true
git show ajuste-preco:bolo-de-cenoura.md > bolo-de-cenoura.md   # decide ficar com R$ 48,00
git add bolo-de-cenoura.md
git commit -q --no-edit
aprova 11 certo

# ---------------------------------------------------------------------------
passo "Desafio 12 — O colega invisível"
reprova 12 vazio "colega.sh 12"
cd "$(lab_dir 12)"
echo "- Quinta: mousse de maracujá" >> cardapio.md
git commit -q -am "Adiciona a quinta ao cardápio"
reprova 12 "errado (commit local, sem colega nem push)" "colega.sh 12"
colega.sh 12 >/dev/null
colega.sh 12 | grep -q 'já publicou' && conta_ok "12 colega.sh é idempotente" \
  || conta_falha "12 colega.sh publicou duas vezes"
git push -q 2>/dev/null && conta_falha "12: o push deveria ter sido rejeitado"
reprova 12 "errado (push rejeitado, sem pull)" "1 à frente e 1 atrás"
git pull -q                                    # pull.rebase=false vindo do setup.sh
reprova 12 "errado (pull sem push)" "à frente"
git push -q
aprova 12 certo

# ---------------------------------------------------------------------------
passo "Desafio 13 — Conflito com o colega"
reprova 13 vazio "colega.sh 13"
cd "$(lab_dir 13)"
sed -i 's/R\$ 40,00/R$ 50,00/' bolo-de-cenoura.md
git commit -q -am "Atualiza preço do bolo para R\$ 50,00"
colega.sh 13 >/dev/null
git fetch -q
[[ "$(git log --oneline main..origin/main | wc -l)" == "1" ]] || conta_falha "13: main..origin/main deveria ter 1 commit"
git pull -q 2>/dev/null && conta_falha "13: o pull deveria ter conflitado"
git add bolo-de-cenoura.md && git commit -q --no-edit      # marcadores commitados
reprova 13 "errado (marcadores no commit)" "marcadores de conflito"
git show main~1:bolo-de-cenoura.md > bolo-de-cenoura.md    # conserta, fica com R$ 50,00
git commit -q -am "Remove marcadores"
reprova 13 "errado (resolvido, sem push)" "à frente"
git push -q
aprova 13 "certo (resolvido em dois commits)"
recomeca 13
sed -i 's/R\$ 40,00/R$ 50,00/' bolo-de-cenoura.md
git commit -q -am "Atualiza preço do bolo para R\$ 50,00"
colega.sh 13 >/dev/null
git pull -q 2>/dev/null || true
git show main:bolo-de-cenoura.md > bolo-de-cenoura.md
git add bolo-de-cenoura.md && git commit -q --no-edit
git push -q
aprova 13 certo

# ---------------------------------------------------------------------------
passo "Desafios 14 e 15 — com um bare local no papel do GitHub"
SIM="$(mktemp -d)"
git init -q --bare -b main "$SIM/github.git"   # "New repository", vazio
cd "$(lab_dir 14)"

reprova 14 vazio "aprendizados.md não está commitado"
printf '# Aprendizados\n\n- staging area\n- commits pequenos\n- branches\n' > aprendizados.md
git add aprendizados.md && git commit -q -m "Adiciona meus aprendizados do curso"
reprova 14 "errado (commit, sem remoto)" "não tem um remoto chamado origin"
git remote add origin "$SIM/github.git"
reprova 14 "errado (remoto ligado, sem push)" "ainda não tem a branch main"
git push -q origin main                        # esqueceu o -u
reprova 14 "errado (push sem -u)" "sem upstream"
git push -q -u origin main
aprova 14 certo

reprova 15 vazio "esperava pelo menos 2"
git switch -q -c mais-um-aprendizado
echo "- pull requests" >> aprendizados.md
git commit -q -am "Adiciona um quarto aprendizado"
git push -q -u origin mais-um-aprendizado 2>/dev/null
git switch -q main
reprova 15 "errado (PR ainda não foi feito o merge)" "ainda não foram integradas"
# "Merge pull request" feito na web: simulado com outro clone
git clone -q "$SIM/github.git" "$SIM/web"
git -C "$SIM/web" merge -q --no-ff -m "Merge pull request #1 from aluno/mais-um-aprendizado" origin/mais-um-aprendizado
git -C "$SIM/web" push -q origin main
reprova 15 "errado (merge na web, sem pull local)" "está diferente da origin/main"
git pull -q
reprova 15 "errado (não apagou a branch local)" "apague-as"
git branch -d -q mais-um-aprendizado
aprova 15 certo

# ---------------------------------------------------------------------------
passo "Utilitários"
cd "$(lab_dir 13)"
check.sh >/dev/null && conta_ok "check.sh sem argumento detecta o desafio pela pasta" \
  || conta_falha "check.sh sem argumento não detectou o desafio"
cd "$CURSO_DIR"
setup.sh | grep -q '0 laboratório(s) gerado(s), 14 mantido(s)' && conta_ok "setup.sh é idempotente" \
  || conta_falha "setup.sh regenerou labs existentes"
check.sh 13 >/dev/null && conta_ok "setup.sh não apagou o trabalho" || conta_falha "setup.sh apagou o trabalho"
check.sh 99 >/dev/null 2>&1 && conta_falha "check.sh 99 deveria falhar" || conta_ok "check.sh rejeita número inválido"
colega.sh 05 >/dev/null 2>&1 && conta_falha "colega.sh 05 deveria falhar" || conta_ok "colega.sh só aceita 12 e 13"

# ---------------------------------------------------------------------------
passo "Resultado"
if (( FALHOU == 0 )); then
  ok "$OKS/$TOTAL verificações passaram."
else
  erro "$OKS/$TOTAL verificações passaram."
  exit 1
fi

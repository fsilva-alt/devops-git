# Desafio 1 — Meu primeiro repositório

⏱ 6 minutos · Módulo 1: Fundamentos

## Objetivo

Transformar uma pasta comum num repositório Git e fazer o primeiro commit. Você vai acompanhar os arquivos desde o estado **não rastreado**, passando pela **staging area**, até serem **registrados no commit**.

## Onde

```bash
cd ~/labs/01-meu-primeiro-repositorio
```

## Estado inicial

Uma pasta com três receitas (`bolo-de-cenoura.md`, `brigadeiro.md` e `pao-de-queijo.md`). Ainda **não** é um repositório; ao executar `git status`, você verá uma mensagem informando isso.

## Tarefa

1. Inicie o repositório:

   ```bash
   git init
   ```

2. Veja como o Git enxerga a pasta agora. Os três arquivos aparecem como *untracked* (não rastreados):

   ```bash
   git status
   ```

3. Adicione **um** arquivo à staging area e rode `git status` de novo. Repare que ele mudou de seção:

   ```bash
   git add bolo-de-cenoura.md
   git status
   ```

4. Adicione os outros dois e faça o primeiro commit:

   ```bash
   git add .
   git commit -m "Cria o livro de receitas"
   ```

5. Confira que a árvore de trabalho ficou limpa e que o commit existe:

   ```bash
   git status
   git log
   ```

## Verificação

```bash
check.sh 01
```

## Missão extra

Rode `ls -a` e observe a pasta `.git` criada pelo `git init`. Ela guarda os dados do repositório; apagá-la deixa apenas os arquivos da pasta, sem o histórico Git. Mantenha-a para continuar o exercício.

# Desafio 4 — Ignorando o que não importa

⏱ 5 minutos · Módulo 2b: Staging seletivo · pode ficar para depois da aula

## Objetivo

Dizer ao Git quais arquivos **nunca** devem entrar no repositório: logs, resultados de build e segredos.

## Onde

```bash
cd ~/labs/04-ignorando-o-que-nao-importa
```

## Estado inicial

`git status` lista estes arquivos não rastreados:

- `debug.log` e `erros.log`: logs gerados por uma ferramenta;
- `build/livro.html`: resultado de uma conversão, pode ser regenerado;
- `.env`: contém uma chave secreta que **jamais** deveria ir para o GitHub.

## Tarefa

1. Crie um arquivo chamado `.gitignore` na raiz do repositório com um padrão por linha:

   ```gitignore
   *.log
   build/
   .env
   ```

2. Rode `git status`. Os arquivos sumiram da lista; só o `.gitignore` aparece.

3. Confirme **qual regra** está ignorando cada arquivo:

   ```bash
   git check-ignore -v debug.log build/livro.html .env
   ```

4. O `.gitignore` faz parte do projeto, então ele **é** versionado:

   ```bash
   git add .gitignore
   git commit -m "Ignora logs, build e segredos"
   ```

## Verificação

```bash
check.sh 04
```

## Missão extra

Repare que `antigo.log` **não** sumiu do `git ls-files`, mesmo com `*.log` no `.gitignore`. O `.gitignore` só vale para arquivos que o Git ainda não rastreia. Para parar de rastrear um arquivo sem apagá-lo do disco:

```bash
git rm --cached antigo.log
git commit -m "Para de rastrear antigo.log"
ls antigo.log     # continua aqui
```

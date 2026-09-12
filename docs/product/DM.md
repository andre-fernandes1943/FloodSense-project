# Modelagem de Dados — FloodSense

## 1. Objetivo da modelagem

A modelagem de dados do FloodSense tem como objetivo estruturar as informações necessárias para o funcionamento do sistema, permitindo o cadastro de usuários, registro de ocorrências, armazenamento de imagens e localizações, análise das ocorrências por Inteligência Artificial e registro do encaminhamento de situações consideradas relevantes.

---

## 2. Entidades identificadas

A partir dos requisitos funcionais e do levantamento de classes, foram identificadas as seguintes entidades principais:

* Usuário
* Ocorrência
* Imagem
* Análise IA
* Encaminhamento

A classe Câmera não será representada como uma tabela no banco de dados, pois corresponde a uma funcionalidade do aplicativo. A câmera será utilizada para capturar a imagem, enquanto apenas as informações da imagem serão armazenadas no banco.

---

# 3. Modelo Conceitual

## Entidade: Usuário

Representa a pessoa que utiliza o aplicativo FloodSense.

### Atributos

* idUsuario
* nome
* email
* senha

### Chave primária

**idUsuario**

### Regras

O e-mail deverá ser único para cada usuário.

Um usuário poderá registrar várias ocorrências.

---

## Entidade: Ocorrência

Representa uma situação de possível alagamento, enchente ou risco registrada pelo usuário.

### Atributos

* idOcorrencia
* descricao
* dataHora
* latitude
* longitude
* status
* idUsuario

### Chave primária

**idOcorrencia**

### Chave estrangeira

**idUsuario**

A chave estrangeira identifica qual usuário realizou o registro da ocorrência.

### Possíveis valores de status

* Registrada
* Analisada
* Relevante
* Encaminhada

---

## Entidade: Imagem

Representa a imagem capturada pelo usuário durante o registro de uma ocorrência.

### Atributos

* idImagem
* caminhoImagem
* dataCaptura
* idOcorrencia

### Chave primária

**idImagem**

### Chave estrangeira

**idOcorrencia**

O campo `caminhoImagem` pode armazenar uma URL ou o caminho do arquivo da imagem.

---

## Entidade: AnaliseIA

Representa o resultado da análise realizada pela Inteligência Artificial sobre uma ocorrência.

### Atributos

* idAnalise
* resultado
* classificacao
* nivelConfianca
* dataAnalise
* idOcorrencia

### Chave primária

**idAnalise**

### Chave estrangeira

**idOcorrencia**

### Exemplos de resultado

* Possível alagamento
* Possível enchente
* Situação normal
* Situação de risco

### Exemplos de classificação

* Baixo risco
* Médio risco
* Alto risco

O atributo `nivelConfianca` poderá armazenar a porcentagem de confiança da Inteligência Artificial no resultado.

Exemplo:

**92,5%**

---

## Entidade: Encaminhamento

Representa a simulação de envio de uma ocorrência considerada relevante para um órgão responsável.

### Atributos

* idEncaminhamento
* orgaoResponsavel
* dataHoraEncaminhamento
* statusEncaminhamento
* idOcorrencia

### Chave primária

**idEncaminhamento**

### Chave estrangeira

**idOcorrencia**

### Exemplo de órgão responsável

* Defesa Civil
* Prefeitura
* Corpo de Bombeiros

Como o encaminhamento será inicialmente apenas uma simulação, o nome do órgão responsável poderá ser armazenado diretamente nessa entidade.

---

# 4. Relacionamentos

## Usuário — Ocorrência

Um usuário pode registrar nenhuma ou várias ocorrências.

Cada ocorrência pertence obrigatoriamente a um único usuário.

**Cardinalidade:**

**USUÁRIO 1 : N OCORRÊNCIA**

Representação:

```text
USUÁRIO
   1
   |
   |
   N
OCORRÊNCIA
```

---

## Ocorrência — Imagem

Uma ocorrência poderá possuir uma ou mais imagens.

Cada imagem pertence a apenas uma ocorrência.

**Cardinalidade:**

**OCORRÊNCIA 1 : N IMAGEM**

Representação:

```text
OCORRÊNCIA
   1
   |
   |
   N
 IMAGEM
```

Essa estrutura permite que futuramente o usuário envie mais de uma fotografia da mesma situação.

---

## Ocorrência — Análise IA

Cada ocorrência enviada para análise poderá possuir uma análise realizada pela Inteligência Artificial.

Cada análise está relacionada a apenas uma ocorrência.

**Cardinalidade:**

**OCORRÊNCIA 1 : 0..1 ANÁLISE IA**

Representação:

```text
OCORRÊNCIA
   1
   |
   |
  0..1
ANÁLISE IA
```

O relacionamento é opcional porque uma ocorrência pode estar apenas registrada e ainda não ter sido analisada.

---

## Ocorrência — Encaminhamento

Uma ocorrência poderá não ser encaminhada ou poderá possuir um encaminhamento.

Cada encaminhamento pertence a uma ocorrência.

**Cardinalidade:**

**OCORRÊNCIA 1 : 0..1 ENCAMINHAMENTO**

Representação:

```text
OCORRÊNCIA
   1
   |
   |
  0..1
ENCAMINHAMENTO
```

Uma ocorrência só deverá ser encaminhada quando for considerada relevante.

---

# 5. DER simplificado

```text
┌─────────────────┐
│     USUARIO     │
├─────────────────┤
│ PK id_usuario   │
│ nome            │
│ email           │
│ senha           │
└────────┬────────┘
         │
         │ 1
         │
         │ N
┌────────▼───────────┐
│     OCORRENCIA     │
├────────────────────┤
│ PK id_ocorrencia   │
│ FK id_usuario      │
│ descricao          │
│ data_hora          │
│ latitude           │
│ longitude          │
│ status             │
└──────┬──────┬──────┘
       │      │
       │      │
       │      └──────────────────┐
       │                         │
       │                         │
       ▼                         ▼
┌────────────────┐       ┌────────────────────┐
│     IMAGEM     │       │     ANALISE_IA     │
├────────────────┤       ├────────────────────┤
│ PK id_imagem   │       │ PK id_analise      │
│ FK id_ocorr.   │       │ FK id_ocorrencia   │
│ caminho_imagem │       │ resultado          │
│ data_captura   │       │ classificacao      │
└────────────────┘       │ nivel_confianca    │
                         │ data_analise        │
                         └────────────────────┘

             OCORRENCIA
                  │
                  │ 1
                  │
                0..1
                  │
                  ▼
        ┌──────────────────────┐
        │    ENCAMINHAMENTO    │
        ├──────────────────────┤
        │ PK id_encaminhamento │
        │ FK id_ocorrencia     │
        │ orgao_responsavel    │
        │ data_hora            │
        │ status               │
        └──────────────────────┘
```

---

# 6. Modelo Lógico

## USUARIO

| Campo      | Tipo         | Restrição          |
| ---------- | ------------ | ------------------ |
| id_usuario | INT          | PK, AUTO_INCREMENT |
| nome       | VARCHAR(100) | NOT NULL           |
| email      | VARCHAR(150) | NOT NULL, UNIQUE   |
| senha      | VARCHAR(255) | NOT NULL           |

---

## OCORRENCIA

| Campo         | Tipo          | Restrição          |
| ------------- | ------------- | ------------------ |
| id_ocorrencia | INT           | PK, AUTO_INCREMENT |
| id_usuario    | INT           | FK, NOT NULL       |
| descricao     | VARCHAR(500)  |                    |
| data_hora     | DATETIME      | NOT NULL           |
| latitude      | DECIMAL(10,8) | NOT NULL           |
| longitude     | DECIMAL(11,8) | NOT NULL           |
| status        | VARCHAR(30)   | NOT NULL           |

Chave estrangeira:

`id_usuario → usuario.id_usuario`

---

## IMAGEM

| Campo          | Tipo         | Restrição          |
| -------------- | ------------ | ------------------ |
| id_imagem      | INT          | PK, AUTO_INCREMENT |
| id_ocorrencia  | INT          | FK, NOT NULL       |
| caminho_imagem | VARCHAR(500) | NOT NULL           |
| data_captura   | DATETIME     | NOT NULL           |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

---

## ANALISE_IA

| Campo           | Tipo         | Restrição            |
| --------------- | ------------ | -------------------- |
| id_analise      | INT          | PK, AUTO_INCREMENT   |
| id_ocorrencia   | INT          | FK, NOT NULL, UNIQUE |
| resultado       | VARCHAR(150) | NOT NULL             |
| classificacao   | VARCHAR(50)  | NOT NULL             |
| nivel_confianca | DECIMAL(5,2) |                      |
| data_analise    | DATETIME     | NOT NULL             |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

---

## ENCAMINHAMENTO

| Campo                    | Tipo         | Restrição            |
| ------------------------ | ------------ | -------------------- |
| id_encaminhamento        | INT          | PK, AUTO_INCREMENT   |
| id_ocorrencia            | INT          | FK, NOT NULL, UNIQUE |
| orgao_responsavel        | VARCHAR(150) | NOT NULL             |
| data_hora_encaminhamento | DATETIME     | NOT NULL             |
| status_encaminhamento    | VARCHAR(50)  | NOT NULL             |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

---

# 7. Regras de Negócio

1. Para registrar uma ocorrência, o usuário deverá estar autenticado no sistema.

2. Cada ocorrência deverá estar associada ao usuário responsável pelo registro.

3. A localização e a data/hora deverão ser registradas automaticamente pelo sistema.

4. Uma ocorrência poderá possuir uma ou mais imagens.

5. A análise da Inteligência Artificial somente poderá ser realizada quando existir uma imagem associada à ocorrência.

6. Após a análise da IA, a ocorrência deverá receber um resultado e uma classificação.

7. Uma ocorrência considerada relevante poderá ser encaminhada para um órgão responsável.

8. O encaminhamento deverá registrar a data, o órgão responsável e seu status.

9. O status da ocorrência deverá ser atualizado de acordo com seu progresso.

Fluxo esperado:

```text
Registrada
     ↓
Analisada
     ↓
Relevante
     ↓
Encaminhada
```

10. O usuário poderá consultar somente as ocorrências relacionadas à sua conta.

---

# 8. Relação entre os requisitos funcionais e as tabelas

### Usuário

Atende principalmente aos requisitos:

RF01 — Cadastro de usuário
RF02 — Login e logout
RF15 — Associação da ocorrência ao usuário
RF16 — Histórico de ocorrências
RF17 — Detalhes da ocorrência

### Ocorrência

Atende principalmente aos requisitos:

RF03 — Registro da ocorrência
RF05 — Descrição
RF06 — Localização
RF07 — Data e hora
RF08 — Envio para análise
RF13 — Armazenamento
RF15 — Associação ao usuário
RF16 — Histórico
RF17 — Visualização dos detalhes
RF19 — Atualização de status

### Imagem

Atende principalmente aos requisitos:

RF04 — Captura da imagem
RF09 — Análise da imagem
RF14 — Armazenamento da imagem

### Análise IA

Atende principalmente aos requisitos:

RF09 — Analisar a imagem
RF10 — Identificar situação de risco
RF11 — Classificar a ocorrência
RF12 — Mostrar resultado ao usuário
RF14 — Armazenar resultado da IA

### Encaminhamento

Atende principalmente aos requisitos:

RF18 — Simular encaminhamento
RF19 — Registrar encaminhamento

---

# 9. Resumo da modelagem

O banco de dados do FloodSense será composto principalmente por cinco tabelas:

```text
USUARIO
OCORRENCIA
IMAGEM
ANALISE_IA
ENCAMINHAMENTO
```

A entidade central do sistema é **OCORRENCIA**, pois é por meio dela que são relacionadas as informações do usuário, da imagem, da localização, do resultado da Inteligência Artificial e do possível encaminhamento para um órgão responsável.

A estrutura permite armazenar o histórico das ocorrências e acompanhar todas as etapas do processo, desde o registro realizado pelo usuário até a possível identificação de uma situação de risco e seu encaminhamento.


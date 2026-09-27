# Modelagem de Dados — FloodSense

## 1. Objetivo da modelagem

A modelagem de dados do FloodSense tem como objetivo estruturar as informações necessárias para o funcionamento do sistema, permitindo o cadastro de usuários, registro de ocorrências, armazenamento de imagens e localizações, análise das ocorrências por Inteligência Artificial e registro do encaminhamento de situações consideradas relevantes.

Para o desenvolvimento do projeto será utilizado o **Supabase**, utilizando o **PostgreSQL** como banco de dados relacional.

O Supabase também será utilizado para autenticação dos usuários por meio do **Supabase Auth** e para armazenamento das imagens por meio do **Supabase Storage**.

---

## 2. Entidades identificadas

A partir dos requisitos funcionais e do levantamento de classes, foram identificadas as seguintes entidades principais:

* Usuário
* Ocorrência
* Imagem
* Análise IA
* Encaminhamento

A classe Câmera não será representada como uma tabela no banco de dados, pois corresponde a uma funcionalidade do aplicativo. A câmera será utilizada para capturar a imagem, enquanto as informações relacionadas à imagem serão armazenadas no banco.

A imagem será armazenada no **Supabase Storage**, enquanto sua referência será registrada no PostgreSQL.

---

# 3. Modelo Conceitual

## Entidade: Usuário

Representa a pessoa que utiliza o aplicativo FloodSense.

A autenticação será realizada utilizando o **Supabase Auth**. Por esse motivo, a senha do usuário não será armazenada diretamente na tabela de usuário do FloodSense.

### Atributos

* idUsuario
* nome
* email
* dataCadastro

### Chave primária

**idUsuario**

O identificador do usuário utilizará o tipo **UUID**, permitindo a associação com o usuário autenticado pelo Supabase Auth.

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

A chave estrangeira identifica qual usuário autenticado realizou o registro da ocorrência.

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

O campo `caminhoImagem` armazenará a referência da imagem salva no **Supabase Storage**, evitando armazenar diretamente o arquivo da imagem dentro da tabela PostgreSQL.

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
┌────────────────────┐
│      USUARIO       │
├────────────────────┤
│ PK id_usuario UUID │
│ nome               │
│ email              │
│ data_cadastro      │
└─────────┬──────────┘
          │
          │ 1
          │
          │ N
┌─────────▼──────────┐
│     OCORRENCIA     │
├────────────────────┤
│ PK id_ocorrencia   │
│ FK id_usuario UUID │
│ descricao          │
│ data_hora          │
│ latitude           │
│ longitude          │
│ status             │
└──────┬──────┬──────┘
       │      │
       │      └──────────────────┐
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

| Campo | Tipo | Restrição |
|---|---|---|
| id_usuario | UUID | PK, FK AUTH.USERS |
| nome | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | NOT NULL, UNIQUE |
| data_cadastro | TIMESTAMPTZ | NOT NULL |

O `id_usuario` será associado ao identificador criado pelo **Supabase Auth**.

A senha não será armazenada nesta tabela, pois a autenticação será responsabilidade do Supabase Auth.

---

## OCORRENCIA

| Campo | Tipo | Restrição |
|---|---|---|
| id_ocorrencia | BIGINT | PK, IDENTITY |
| id_usuario | UUID | FK, NOT NULL |
| descricao | TEXT | |
| data_hora | TIMESTAMPTZ | NOT NULL |
| latitude | DECIMAL(10,8) | NOT NULL |
| longitude | DECIMAL(11,8) | NOT NULL |
| status | VARCHAR(30) | NOT NULL |

Chave estrangeira:

`id_usuario → usuario.id_usuario`

---

## IMAGEM

| Campo | Tipo | Restrição |
|---|---|---|
| id_imagem | BIGINT | PK, IDENTITY |
| id_ocorrencia | BIGINT | FK, NOT NULL |
| caminho_imagem | TEXT | NOT NULL |
| data_captura | TIMESTAMPTZ | NOT NULL |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

O arquivo da imagem será armazenado no **Supabase Storage** e o campo `caminho_imagem` guardará sua referência.

---

## ANALISE_IA

| Campo | Tipo | Restrição |
|---|---|---|
| id_analise | BIGINT | PK, IDENTITY |
| id_ocorrencia | BIGINT | FK, NOT NULL, UNIQUE |
| resultado | VARCHAR(150) | NOT NULL |
| classificacao | VARCHAR(50) | NOT NULL |
| nivel_confianca | DECIMAL(5,2) | |
| data_analise | TIMESTAMPTZ | NOT NULL |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

---

## ENCAMINHAMENTO

| Campo | Tipo | Restrição |
|---|---|---|
| id_encaminhamento | BIGINT | PK, IDENTITY |
| id_ocorrencia | BIGINT | FK, NOT NULL, UNIQUE |
| orgao_responsavel | VARCHAR(150) | NOT NULL |
| data_hora_encaminhamento | TIMESTAMPTZ | NOT NULL |
| status_encaminhamento | VARCHAR(50) | NOT NULL |

Chave estrangeira:

`id_ocorrencia → ocorrencia.id_ocorrencia`

---

# 7. Regras de Negócio

1. Para registrar uma ocorrência, o usuário deverá estar autenticado no sistema através do Supabase Auth.

2. Cada ocorrência deverá estar associada ao usuário responsável pelo registro.

3. A localização e a data/hora deverão ser registradas automaticamente pelo sistema.

4. Uma ocorrência poderá possuir uma ou mais imagens.

5. As imagens serão armazenadas no Supabase Storage e suas referências serão registradas no banco PostgreSQL.

6. A análise da Inteligência Artificial somente poderá ser realizada quando existir uma imagem associada à ocorrência.

7. Após a análise da IA, a ocorrência deverá receber um resultado e uma classificação.

8. Uma ocorrência considerada relevante poderá ser encaminhada para um órgão responsável.

9. O encaminhamento deverá registrar a data, o órgão responsável e seu status.

10. O status da ocorrência deverá ser atualizado de acordo com seu progresso.

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

11. O usuário poderá consultar somente as ocorrências relacionadas à sua conta.

---

# 8. Relação entre os requisitos funcionais e as tabelas

### Usuário

Atende principalmente aos requisitos:

RF01 — Cadastro de usuário  
RF02 — Login e logout  
RF15 — Associação da ocorrência ao usuário  
RF16 — Histórico de ocorrências  
RF17 — Detalhes da ocorrência

O cadastro e login serão realizados com auxílio do **Supabase Auth**.

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

As imagens serão armazenadas no **Supabase Storage**.

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

O banco de dados do FloodSense utilizará **PostgreSQL através do Supabase** e será composto principalmente por cinco tabelas:

```text
USUARIO
OCORRENCIA
IMAGEM
ANALISE_IA
ENCAMINHAMENTO
```

A autenticação dos usuários será realizada utilizando o **Supabase Auth**, enquanto as imagens das ocorrências serão armazenadas utilizando o **Supabase Storage**.

A entidade central do sistema é **OCORRENCIA**, pois é por meio dela que são relacionadas as informações do usuário, da imagem, da localização, do resultado da Inteligência Artificial e do possível encaminhamento para um órgão responsável.

A estrutura permite armazenar o histórico das ocorrências e acompanhar todas as etapas do processo, desde o registro realizado pelo usuário até a possível identificação de uma situação de risco e seu encaminhamento.

---

# 10. Tecnologias utilizadas no banco de dados

Para implementação da modelagem serão utilizadas:

* **Supabase** — plataforma utilizada para os serviços de backend;
* **PostgreSQL** — banco de dados relacional;
* **Supabase Auth** — cadastro, login e autenticação dos usuários;
* **Supabase Storage** — armazenamento das imagens das ocorrências;
* **Flutter/Dart** — desenvolvimento da aplicação que acessará os dados;
* **GitHub** — versionamento do código e dos arquivos relacionados à estrutura do banco.

A utilização do PostgreSQL foi escolhida por se adequar aos relacionamentos existentes entre usuários, ocorrências, imagens, análises e encaminhamentos. O Supabase facilita sua integração com Flutter/Dart e disponibiliza autenticação e armazenamento de arquivos para o desenvolvimento do FloodSense.

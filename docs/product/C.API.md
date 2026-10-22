# FloodSense — Contrato de comunicação Flutter ↔ Backend/API

**Versão:** 1.0 (proposta para validação da equipe)  
**Tecnologias:** Flutter/Dart, HTTP, JSON, Backend/API, Supabase (Auth, PostgreSQL e Storage).  
**Objetivo:** definir como o aplicativo envia e recebe informações do Backend, mantendo compatibilidade com o banco existente.

> **Atenção:** este documento propõe um contrato. Não significa que as rotas já foram implementadas. Antes de desenvolver, o time Flutter e o time Backend devem confirmar rotas, autenticação, upload, autorização e regras de negócio.

## 1. Funcionalidades que precisam de comunicação

| Funcionalidade | Operação | Observações |
|---|---|---|
| Cadastro e login | Criar conta/autenticar | Validar se Flutter utiliza Supabase Auth diretamente ou API própria. |
| Visualizar perfil | Consultar usuário autenticado | Dados da tabela `usuario`. |
| Registrar ocorrência | Cadastrar relato, descrição e coordenadas | Foto pode ser enviada em etapa separada. |
| Enviar imagem | Associar foto à ocorrência | Salvar arquivo no Storage e metadados na tabela `imagem`. |
| Consultar ocorrências | Listar e detalhar registros | Somente conforme permissões aprovadas. |
| Consultar análise da IA | Recuperar classificação e confiança | A análise pode não existir imediatamente. |
| Acompanhar encaminhamento | Consultar destino e andamento | Dados da tabela `encaminhamento`. |
| Sair da conta | Encerrar sessão | Dependente da arquitetura de autenticação. |

## 2. Convenções gerais

- **URL base (exemplo):** `https://api.exemplo.com/v1` — substituir pelo endereço real.
- **Transporte:** HTTPS obrigatório em produção.
- **Formato:** requisições e respostas JSON com `Content-Type: application/json`, exceto upload de imagem (`multipart/form-data`).
- **Autenticação:** nas rotas protegidas, `Authorization: Bearer <token_de_acesso>`. O Backend deve validar assinatura, expiração e permissões; não confiar no ID enviado pelo cliente.
- **Identificadores:** `id_usuario` é UUID; `id_ocorrencia`, `id_imagem`, `id_analise`, `id_encaminhamento` são BIGINT. IDs BIGINT são apresentados como números JSON apenas se dentro do intervalo seguro do cliente; a equipe pode padronizar strings para evitar perda de precisão em outros consumidores.
- **Datas:** ISO 8601 com fuso (exemplo: `2026-10-14T20:00:00-03:00` ou UTC com `Z`).
- **Coordenadas:** números decimais, latitude entre -90 e 90 e longitude entre -180 e 180.
- **Campos internos:** IDs gerados pelo banco, `id_usuario` de propriedade, `status`, `resultado`, `confianca`, `nivel_agua` e timestamps de servidor não devem ser aceitos arbitrariamente do usuário durante a criação da ocorrência.
- **Paginação:** exemplos abaixo sem paginação; para produção, definir `limit` e `offset` ou cursor.

### Respostas e erros

- `200 OK`: consulta ou atualização bem-sucedida.
- `201 Created`: recurso criado.
- `202 Accepted`: processamento assíncrono aceito, caso implementado.
- `400 Bad Request`: dados inválidos.
- `401 Unauthorized`: token ausente/inválido.
- `403 Forbidden`: usuário sem permissão.
- `404 Not Found`: registro não localizado ou indisponível ao usuário.
- `409 Conflict`: conflito de cadastro/regra.
- `413 Payload Too Large`: imagem maior que o limite definido.
- `500 Internal Server Error`: erro inesperado.

Modelo proposto de erro:

```json
{
  "erro": {
    "codigo": "DADOS_INVALIDOS",
    "mensagem": "Latitude deve estar entre -90 e 90."
  }
}
```

## 3. Rotas propostas

| Método | Rota | Objetivo | Autenticação |
|---|---|---|---|
| POST | `/auth/cadastro` | Cadastrar conta e perfil | Não |
| POST | `/auth/login` | Autenticar e receber sessão | Não |
| GET | `/usuarios/me` | Consultar perfil | Sim |
| POST | `/ocorrencias` | Registrar ocorrência | Sim |
| GET | `/ocorrencias` | Listar ocorrências visíveis ao usuário | Sim |
| GET | `/ocorrencias/{id}` | Detalhar ocorrência | Sim |
| POST | `/ocorrencias/{id}/imagens` | Enviar foto associada | Sim |
| GET | `/ocorrencias/{id}/analise` | Consultar análise de IA | Sim |
| GET | `/ocorrencias/{id}/encaminhamentos` | Consultar encaminhamentos | Sim |

**Decisão de arquitetura pendente:** se o Flutter autenticar diretamente usando o SDK do Supabase Auth, as rotas `/auth/cadastro` e `/auth/login` não serão necessárias na API própria, mas o contrato de sessão/token e o provisionamento do perfil `usuario` ainda devem ser definidos. Não criar duas fontes de autenticação independentes.

## 4. Exemplos de requisições e respostas

### 4.1 Cadastro — `POST /auth/cadastro` (caso use Backend como intermediário)

**Flutter envia:**

```json
{
  "nome": "Maria Silva",
  "email": "maria@exemplo.com",
  "senha": "SenhaDeExemplo123!"
}
```

**Backend retorna (201; exemplo para conta pronta para uso):**

```json
{
  "id_usuario": "7e5e6184-369d-4ce5-a56d-efcd3e7f42d1",
  "nome": "Maria Silva",
  "email": "maria@exemplo.com",
  "data_cadastro": "2026-10-14T23:00:00Z"
}
```

**Regras:** conta de autenticação gerida pelo Supabase Auth, associada ao perfil `usuario.id_usuario = auth.users.id`; **nunca** armazenar senha na tabela `usuario`. Se confirmação de e-mail for exigida, definir resposta de cadastro pendente em vez de supor sessão ativa.

### 4.2 Login — `POST /auth/login` (caso use Backend como intermediário)

**Flutter envia:**

```json
{
  "email": "maria@exemplo.com",
  "senha": "SenhaDeExemplo123!"
}
```

**Backend retorna (200, formato a validar com Supabase Auth):**

```json
{
  "access_token": "<token_valido_emitido_pelo_provedor>",
  "token_type": "bearer",
  "expires_in": 3600,
  "usuario": {
    "id_usuario": "7e5e6184-369d-4ce5-a56d-efcd3e7f42d1",
    "nome": "Maria Silva",
    "email": "maria@exemplo.com"
  }
}
```

**Regras:** tokens reais são emitidos pelo sistema de autenticação; `expires_in` é ilustrativo. Definir com a equipe renovação e encerramento de sessão. Não registrar senha nem token em logs.

### 4.3 Consultar meu perfil — `GET /usuarios/me`

**Flutter envia:** token no cabeçalho; nenhum corpo.

**Backend retorna (200):**

```json
{
  "id_usuario": "7e5e6184-369d-4ce5-a56d-efcd3e7f42d1",
  "nome": "Maria Silva",
  "email": "maria@exemplo.com",
  "data_cadastro": "2026-10-14T23:00:00Z"
}
```

### 4.4 Registrar ocorrência — `POST /ocorrencias`

**Flutter envia:**

```json
{
  "descricao": "Água acumulada na rua após chuva forte.",
  "latitude": -23.5505,
  "longitude": -46.6333
}
```

**Backend retorna (201):**

```json
{
  "id_ocorrencia": 101,
  "id_usuario": "7e5e6184-369d-4ce5-a56d-efcd3e7f42d1",
  "descricao": "Água acumulada na rua após chuva forte.",
  "latitude": -23.5505,
  "longitude": -46.6333,
  "data_hora": "2026-10-14T23:05:00Z",
  "status": "REGISTRADA"
}
```

**Regras:** descrição pode ser omitida ou `null`; a equipe deve definir obrigatoriedade de coordenadas. Backend identifica `id_usuario` pelo token, define `data_hora` e mantém o status padrão `REGISTRADA`. O nível da água não entra no cadastro da ocorrência, pois no modelo atual pertence a `analise_ia`.

### 4.5 Listar ocorrências — `GET /ocorrencias`

**Flutter envia:** cabeçalho de autenticação, sem corpo. Na proposta inicial, listar as ocorrências do próprio usuário; mudar apenas após alinhamento das regras de visibilidade.

**Backend retorna (200):**

```json
{
  "ocorrencias": [
    {
      "id_ocorrencia": 101,
      "descricao": "Água acumulada na rua após chuva forte.",
      "latitude": -23.5505,
      "longitude": -46.6333,
      "data_hora": "2026-10-14T23:05:00Z",
      "status": "REGISTRADA"
    }
  ]
}
```

### 4.6 Detalhar ocorrência — `GET /ocorrencias/{id}`

**Exemplo:** `GET /ocorrencias/101`. Sem corpo.

**Backend retorna (200):**

```json
{
  "id_ocorrencia": 101,
  "id_usuario": "7e5e6184-369d-4ce5-a56d-efcd3e7f42d1",
  "descricao": "Água acumulada na rua após chuva forte.",
  "latitude": -23.5505,
  "longitude": -46.6333,
  "data_hora": "2026-10-14T23:05:00Z",
  "status": "REGISTRADA",
  "imagens": [
    {
      "id_imagem": 301,
      "url": "https://exemplo.com/imagens/301.jpg",
      "data_upload": "2026-10-14T23:07:00Z"
    }
  ]
}
```

**Regras:** a lista `imagens` é um agrupamento montado pela API a partir da tabela `imagem`; não é coluna de `ocorrencia`. URL deve respeitar a política de acesso (URL assinada quando necessário).

### 4.7 Enviar imagem — `POST /ocorrencias/{id}/imagens`

**Exemplo:** `POST /ocorrencias/101/imagens`.

**Flutter envia:** `multipart/form-data` com campo `arquivo` contendo JPG/PNG ou tipo acordado. **Não é JSON**. O token vai no cabeçalho.

**Backend retorna (201):**

```json
{
  "id_imagem": 301,
  "id_ocorrencia": 101,
  "url": "https://exemplo.com/imagens/301.jpg",
  "data_upload": "2026-10-14T23:07:00Z"
}
```

**Regras:** validar existência e permissão sobre ocorrência, formato e tamanho; enviar arquivo para Supabase Storage; gravar metadados na tabela `imagem`. Não presumir que o banco PostgreSQL guarde a foto binária.

### 4.8 Consultar análise IA — `GET /ocorrencias/{id}/analise`

**Exemplo:** `GET /ocorrencias/101/analise`.

**Backend retorna (200, quando houver análise):**

```json
{
  "id_analise": 501,
  "id_ocorrencia": 101,
  "resultado": "GRAVE",
  "nivel_agua": 0.85,
  "confianca": 0.92,
  "data_analise": "2026-10-14T23:10:00Z"
}
```

**Quando não houver análise:** proposta de `200` com `{ "analise": null }` (alternativa: `404`); padronizar uma opção com a equipe. Os rótulos possíveis e a unidade de `nivel_agua` **precisam ser definidos**. O valor acima é fictício e não deve ser interpretado como medição real.

### 4.9 Consultar encaminhamentos — `GET /ocorrencias/{id}/encaminhamentos`

**Exemplo:** `GET /ocorrencias/101/encaminhamentos`.

**Backend retorna (200):**

```json
{
  "encaminhamentos": [
    {
      "id_encaminhamento": 701,
      "id_ocorrencia": 101,
      "destino": "Defesa Civil",
      "data_envio": "2026-10-14T23:15:00Z",
      "status": "ENVIADO"
    }
  ]
}
```

**Regras:** encaminhamento e status são geridos pelo Backend/processo autorizado, não enviados livremente pelo Flutter. Em caso de nenhum encaminhamento, retornar `{"encaminhamentos": []}`.

## 5. Conferência com as tabelas existentes

| Tabela | Campos existentes | Rotas relacionadas |
|---|---|---|
| `usuario` | `id_usuario` UUID PK/FK `auth.users.id`, `data_cadastro` TIMESTAMPTZ, `nome` VARCHAR, `email` VARCHAR UNIQUE | Cadastro, perfil e autenticação |
| `ocorrencia` | `id_ocorrencia` BIGINT PK/Identity, `data_hora` TIMESTAMPTZ, `id_usuario` UUID FK, `descricao` TEXT opcional, `latitude` NUMERIC, `longitude` NUMERIC, `status` VARCHAR com padrão `REGISTRADA` | Criar, listar, detalhar ocorrência |
| `imagem` | `id_imagem` BIGINT PK/Identity, `id_ocorrencia` BIGINT FK, `url` TEXT, `data_upload` TIMESTAMPTZ | Enviar imagem e detalhar ocorrência |
| `analise_ia` | `id_analise` BIGINT PK/Identity, `id_ocorrencia` BIGINT FK, `resultado` VARCHAR, `nivel_agua` NUMERIC, `confianca` NUMERIC, `data_analise` TIMESTAMPTZ | Consultar análise |
| `encaminhamento` | `id_encaminhamento` BIGINT PK/Identity, `id_ocorrencia` BIGINT FK, `destino` VARCHAR, `data_envio` TIMESTAMPTZ, `status` VARCHAR | Consultar encaminhamentos |

Os campos mostrados nos exemplos de JSON refletem as colunas existentes, exceto campos agregados pela API (como `imagens` e `ocorrencias`) e os retornos da autenticação (`access_token`, `expires_in`), que não são colunas dessas tabelas.

## 6. Decisões pendentes para revisão conjunta

- [ ] Confirmar funcionalidades que constam do escopo efetivo e telas do Flutter.
- [ ] Confirmar se o Flutter usa Supabase Auth diretamente ou via Backend e como ocorre o cadastro do perfil.
- [ ] Validar nomes, prefixo `/v1` e existência das rotas.
- [ ] Validar uso de Bearer token e autorização (inclusive RLS no Supabase conforme arquitetura).
- [ ] Definir quem pode ver ocorrências de outros usuários.
- [ ] Definir limites, tipos aceitos e acesso às imagens.
- [ ] Definir se haverá múltiplas análises da IA por ocorrência e qual delas a API devolve.
- [ ] Definir domínio de `resultado`, escala e unidade de `nivel_agua`, e escala de `confianca`.
- [ ] Definir possíveis status da ocorrência e encaminhamento.
- [ ] Definir resposta padronizada para análise ainda não disponível.
- [ ] Definir paginação, filtros e datas registradas pelo servidor.
- [ ] Revisar exemplos e obter aprovação dos responsáveis por Flutter e Backend.

## 7. Checklist da tarefa do GitHub

- [x] Levantar uma proposta inicial das funcionalidades que precisarão da API (pendente confirmar com o grupo).
- [x] Definir proposta das principais rotas da API.
- [x] Definir o método HTTP de cada rota.
- [x] Definir quais dados o Flutter enviará.
- [x] Definir quais dados o Backend retornará.
- [x] Definir formato de informações em JSON (com exceção de upload binário).
- [x] Criar exemplos de requisições e respostas.
- [x] Conferir os dados propostos com o modelo do banco conhecido.
- [x] Registrar o contrato em arquivo `.md`.
- [ ] Revisar e aprovar a definição com os responsáveis pelo Flutter e Backend.

**Status:** documentação inicial pronta; contrato sujeito à validação do grupo, especialmente decisões indicadas na seção 6.
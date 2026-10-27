# FloodSense API — Análise visual de ocorrências urbanas

API em Node.js/Express que recebe uma imagem e utiliza a API Gemini para produzir uma classificação visual em JSON.

## Requisitos

- Node.js LTS instalado
- Uma chave da Gemini API: https://aistudio.google.com/apikey
- Conexão com a internet para consultar a IA

## Configuração

1. Extraia a pasta `FloodSense-API`.
2. Dentro dela, copie `.env.example` para um arquivo chamado `.env`.
3. Abra `.env` e substitua `COLOQUE_SUA_CHAVE_AQUI` pela sua chave real.
4. Abra o terminal dentro da pasta e execute:

```bash
npm install
npm start
```

O servidor deve mostrar `FloodSense API disponível na porta 3000`.

## Teste de status

Abra no navegador:

`http://localhost:3000/`

Resposta esperada:

```json
{
  "projeto": "FloodSense",
  "status": "online",
  "versao": "1.0.0",
  "endpoints": {
    "status": "GET /",
    "analisarImagem": "POST /api/analisar"
  }
}
```

## Teste de análise de imagem

Use Postman, Insomnia ou outro cliente HTTP.

- Método: `POST`
- URL: `http://localhost:3000/api/analisar`
- Body: `form-data`
- Campo: `imagem`
- Tipo do campo: `File`
- Valor: selecione uma imagem JPG, PNG ou WEBP de até 5 MB.

Alternativamente, com `curl` e uma imagem chamada `foto.jpg` no diretório atual:

```bash
curl -X POST -F "imagem=@foto.jpg" http://localhost:3000/api/analisar
```

## Exemplo de resposta

Os valores são ilustrativos; o resultado real depende da imagem analisada.

```json
{
  "sucesso": true,
  "projeto": "FloodSense",
  "analise": {
    "categoria": "buraco",
    "descricao": "Depressão visível no pavimento.",
    "confianca": 88,
    "imagem_adequada": true,
    "evidencias_visuais": ["Pavimento irregular"],
    "revisao_humana": true
  },
  "status_denuncia": "apta_para_revisao",
  "exige_revisao_humana": true,
  "mensagem": "Há indícios visuais. Revise antes de registrar a ocorrência."
}
```

## Categorias

- `buraco`
- `entulho`
- `poste apagado`
- `alagamento`
- `outro problema urbano`
- `nenhum problema identificável`
- `inconclusivo`

## Endpoints

| Método | Rota | Descrição |
|---|---|---|
| GET | `/` | Verifica se a API está online |
| POST | `/api/analisar` | Recebe a foto no campo `imagem` e devolve a análise |

## Segurança e limites

- A chave Gemini fica no servidor, dentro do `.env`; não a coloque no HTML, CSS ou JavaScript público.
- O `.gitignore` exclui `.env` e `node_modules`.
- O upload limita arquivos a 5 MB e aceita somente JPG, PNG e WEBP.
- Esta versão é um protótipo. Antes de publicar na internet, implemente autenticação, limite de requisições, monitoramento e política de privacidade.
- A análise visual não prova que uma denúncia é verdadeira, não confirma endereço e não substitui revisão humana.
- O endpoint ainda não salva nem envia denúncias para um banco de dados.

## Documentação

- Gemini API — compreensão de imagens: https://ai.google.dev/gemini-api/docs/image-understanding
- Gemini API — geração de conteúdo: https://ai.google.dev/api/generate-content

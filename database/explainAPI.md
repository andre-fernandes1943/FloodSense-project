# Entendendo a API de Análise da IA

Este documento explica o funcionamento da nossa **API de Inteligência Artificial** (Supabase Edge Function), responsável por analisar as fotos enviadas pelo aplicativo **FloodSense**.

## O que é esta API?

A nossa API é uma **função que roda na nuvem do Supabase** (uma *Edge Function*). Ela funciona como um "intermediário seguro" entre o aplicativo Flutter e a IA do Google (Gemini 1.5 Flash).

* **Onde ela fica?** Direto no servidor do Supabase (não precisa de nenhum computador ligado).

* **Qual a função dela?** Receber a foto enviada pelo usuário, perguntar para a IA se é um alagamento de verdade e devolve a resposta para o celular.

## O Passo a Passo do Código (Como a mágica acontece)

O código executa apenas **5 passos principais**:

1. ###  Receber a Imagem do Celular

O aplicativo em Flutter envia a foto tirada pelo usuário convertida em texto (formato `Base64`). A API recebe esse dado e verifica se a foto realmente chegou.

2. ### Buscar a Chave de Segurança

Para conversar com a IA do Google, é necessária uma chave secreta (`GEMINI_API_KEY`). A API busca essa chave salva nos cofres seguros do Supabase (*Secrets*).

**Segurança:** Como a chave fica no servidor, ninguém consegue roubá-la pelo aplicativo.

3. ### Fazer a Pergunta para o Gemini

A API envia a foto para o **Gemini 1.5 Flash** junto com uma instrução estrita (o *prompt*):

> *"Analise esta imagem e me diga se ela mostra um alagamento, buraco, entulho ou outro problema urbano. Responda apenas em formato JSON."*

4. ### Ler e Organizar a Resposta da IA

O Gemini analisa os pixels da imagem em segundos e responde com o nome da categoria encontrada. A nossa API limpa o texto recebido e identifica se a palavra retornada foi exatamente **`alagamento`**.

5. ### Devolver o Resultado para o Aplicativo

A API responde para o celular uma mensagem simples contendo:

* `ehAlagamento`: **`true`** (se for alagamento) ou **`false`** (se não for).

* `categoria`: O nome do problema identificado pela IA.

## Resumo do Fluxo em 1 Minuto

```
📱 Celular/App (Flutter) ──[1. Envia Foto]──> ☁️ Supabase Edge Function
                                                 │
                                         [2. Pega a Chave Secreta]
                                                 │
                                         [3. Pergunta se é Alagamento]
                                                 ▼
                                           🤖 Google Gemini IA
                                                 │
                                         [4. Analisa a Imagem]
                                                 ▼
📱 Celular (Flutter) <──[5. Responde True/False]── ☁️ Supabase Edge Function


```

## 🎯 Por que usamos essa abordagem?

1. **Mais Rápido:** O modelo Gemini 1.5 Flash responde em poucos segundos.

2. **Sem Custos:** Utiliza a cota gratuita oficial do Google AI Studio.

3. **Seguro:** A chave da IA nunca sai do servidor.

4. **Prático:** Não precisamos deixar nenhum servidor local rodando no computador e não compromente o computador e credenciais de ninguem envolvido com o projeto.
import express from "express";
import multer from "multer";
import dotenv from "dotenv";
import { GoogleGenAI } from "@google/genai";

dotenv.config();

const app = express();
const PORT = Number(process.env.PORT) || 3000;

if (!process.env.GEMINI_API_KEY) {
  throw new Error(
    "GEMINI_API_KEY não configurada. Crie um arquivo .env usando .env.example."
  );
}

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY
});

const categoriasPermitidas = [
  "buraco",
  "entulho",
  "poste apagado",
  "alagamento",
  "outro problema urbano",
  "nenhum problema identificável",
  "inconclusivo"
];

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (req, file, callback) => {
    const formatosPermitidos = [
      "image/jpeg",
      "image/png",
      "image/webp"
    ];

    if (!formatosPermitidos.includes(file.mimetype)) {
      return callback(
        new Error("Formato não permitido. Envie uma imagem JPG, PNG ou WEBP.")
      );
    }

    callback(null, true);
  }
});

app.get("/", (req, res) => {
  res.json({
    projeto: "FloodSense",
    status: "online",
    versao: "1.0.0",
    endpoints: {
      status: "GET /",
      analisarImagem: "POST /api/analisar"
    }
  });
});

app.post("/api/analisar", upload.single("imagem"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({
      sucesso: false,
      erro: "Envie uma imagem no campo 'imagem'."
    });
  }

  try {
    const prompt = `
Você é o sistema de visão computacional do projeto FloodSense.
Analise a fotografia e classifique somente o problema urbano que
for visualmente sustentado pela imagem.

Escolha uma categoria exatamente desta lista:
${categoriasPermitidas.map((categoria) => `- ${categoria}`).join("\n")}

Regras:
- Não invente evidências nem localização.
- Uma fotografia não comprova que uma denúncia é verdadeira.
- Não diga que um poste está apagado apenas porque ele parece escuro;
  a imagem pode não ter sido tirada à noite ou não mostrar seu estado.
- Se a imagem estiver borrada, escura, fora do tema ou não permitir
  uma conclusão segura, use a categoria "inconclusivo".
- "confianca" é uma estimativa de confiança visual, de 0 a 100,
  e não uma probabilidade de a denúncia ser verdadeira.
- Marque "revisao_humana" como true sempre que houver dúvida.
- Retorne apenas os campos solicitados no formato JSON.
`;

    const resultado = await ai.models.generateContent({
      model: "gemini-3.8-flash",
      contents: [
        {
          role: "user",
          parts: [
            {
              inlineData: {
                mimeType: req.file.mimetype,
                data: req.file.buffer.toString("base64")
              }
            },
            { text: prompt }
          ]
        }
      ],
      config: {
        responseMimeType: "application/json",
        responseSchema: {
          type: "OBJECT",
          properties: {
            categoria: {
              type: "STRING",
              enum: categoriasPermitidas
            },
            descricao: { type: "STRING" },
            confianca: { type: "INTEGER" },
            imagem_adequada: { type: "BOOLEAN" },
            evidencias_visuais: {
              type: "ARRAY",
              items: { type: "STRING" }
            },
            revisao_humana: { type: "BOOLEAN" }
          },
          required: [
            "categoria",
            "descricao",
            "confianca",
            "imagem_adequada",
            "evidencias_visuais",
            "revisao_humana"
          ],
          propertyOrdering: [
            "categoria",
            "descricao",
            "confianca",
            "imagem_adequada",
            "evidencias_visuais",
            "revisao_humana"
          ]
        }
      }
    });

    if (!resultado.text) {
      throw new Error("A IA não retornou conteúdo.");
    }

    const analise = JSON.parse(resultado.text);

    const respostaValida =
      categoriasPermitidas.includes(analise.categoria) &&
      typeof analise.descricao === "string" &&
      Number.isInteger(analise.confianca) &&
      analise.confianca >= 0 &&
      analise.confianca <= 100 &&
      typeof analise.imagem_adequada === "boolean" &&
      typeof analise.revisao_humana === "boolean" &&
      Array.isArray(analise.evidencias_visuais) &&
      analise.evidencias_visuais.every((item) => typeof item === "string");

    if (!respostaValida) {
      throw new Error("A resposta da IA não passou pela validação.");
    }

    const aptaParaRevisao =
      analise.imagem_adequada &&
      analise.categoria !== "nenhum problema identificável" &&
      analise.categoria !== "inconclusivo" &&
      analise.confianca >= 75;

    const exigeRevisaoHumana =
      analise.revisao_humana || !aptaParaRevisao;

    return res.json({
      sucesso: true,
      projeto: "FloodSense",
      analise,
      status_denuncia: aptaParaRevisao
        ? "apta_para_revisao"
        : "revisao_manual",
      exige_revisao_humana: exigeRevisaoHumana,
      mensagem: aptaParaRevisao
        ? "Há indícios visuais. Revise antes de registrar a ocorrência."
        : "A imagem precisa de verificação adicional."
    });
  } catch (erro) {
    console.error("Erro na análise Gemini:", erro.message);

    return res.status(502).json({
      sucesso: false,
      erro: "Não foi possível concluir a análise com a IA. Tente novamente."
    });
  }
});

app.use((erro, req, res, next) => {
  if (res.headersSent) return next(erro);

  const status = erro instanceof multer.MulterError ? 400 : 400;
  return res.status(status).json({
    sucesso: false,
    erro: erro.message || "Erro ao receber a imagem."
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`FloodSense API disponível na porta ${PORT}`);
  console.log(`Teste o status em http://localhost:${PORT}/`);
});

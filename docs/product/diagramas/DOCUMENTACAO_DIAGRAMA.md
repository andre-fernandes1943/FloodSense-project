# FloodSense — Documentação do Diagrama de Classes

## 1. Objetivo

Este documento explica o diagrama de classes atual do sistema FloodSense. O diagrama representa as principais entidades do sistema, seus atributos, métodos e os relacionamentos entre elas.

O FloodSense foi estruturado para permitir o registro de ocorrências, coleta de localização e imagens, análise por inteligência artificial e, quando necessário, encaminhamento da ocorrência para um órgão responsável.

> **Observação:** esta é a versão atual do diagrama. Algumas classes, atributos, métodos e relacionamentos poderão ser alterados nos próximos diagramas conforme o projeto evoluir.

## 2. Classes

### Usuario

Representa a pessoa que utiliza o sistema.

**Atributos**
- `idUsuario`
- `nome`
- `email`
- `senha`

**Métodos**
- `cadastrar()`
- `realizarLogin()`
- `encerrarSessao()`
- `visualizarHistorico()`
- `visualizarOcorrencia()`

**Responsabilidade:** realizar o cadastro e login, encerrar a sessão e consultar o histórico e as ocorrências registradas.

### Ocorrencia

Representa uma ocorrência registrada no FloodSense.

**Atributos**
- `idOcorrencia`
- `descricao`
- `imagem`
- `dataHora`
- `localizacao`
- `resultadoIA`
- `classificacao`
- `status`

**Métodos**
- `registrarOcorrencia()`
- `adicionarDescricao()`
- `registrarLocalizacao()`
- `registrarDataHora()`
- `enviarParaAnalise()`
- `armazenarOcorrencia()`
- `atualizarStatus()`

**Responsabilidade:** concentrar as informações da ocorrência e controlar seu registro, armazenamento, análise e atualização de status.

### Localizacao

Representa a localização geográfica da ocorrência.

**Atributos**
- `latitude`
- `longitude`
- `endereco`

**Métodos**
- `obterLocalizacao()`
- `atualizarLocalizacao()`

**Responsabilidade:** obter e manter os dados que identificam onde a ocorrência aconteceu.

### Camera

Representa o recurso utilizado para capturar a imagem da ocorrência.

**Atributos**
- `idCamera`
- `imagemCapturada`

**Métodos**
- `abrirCamera()`
- `capturarImagem()`
- `salvarImagem()`

**Responsabilidade:** abrir a câmera, capturar uma imagem e disponibilizá-la para o registro da ocorrência.

### AnaliseIA

Representa o módulo de inteligência artificial responsável pela análise da ocorrência/imagem.

**Atributos**
- `idAnalise`
- `resultado`
- `classificacao`
- `confianca`

**Métodos**
- `analisarImagem()`
- `identificarSituacao()`
- `classificarOcorrencia()`
- `gerarResultado()`

**Responsabilidade:** analisar a imagem, identificar a situação, classificar a ocorrência e gerar um resultado com nível de confiança.

### Encaminhamento

Representa o processo de encaminhamento de uma ocorrência relevante.

**Atributos**
- `idEncaminhamento`
- `dataHoraEncaminhamento`
- `orgaoResponsavel`
- `statusEncaminhamento`

**Métodos**
- `verificarRelevancia()`
- `encaminharOcorrencia()`
- `registrarEncaminhamento()`
- `atualizarStatus()`

**Responsabilidade:** verificar a relevância da ocorrência, encaminhá-la ao órgão responsável e acompanhar o status desse encaminhamento.

## 3. Relacionamentos

- **Usuario → Ocorrencia:** o usuário registra ocorrências no sistema.
- **Ocorrencia → Localizacao:** a ocorrência possui uma localização associada.
- **Ocorrencia → Camera:** a ocorrência utiliza uma imagem capturada pela câmera.
- **Ocorrencia → AnaliseIA:** a ocorrência é submetida à análise de inteligência artificial.
- **Ocorrencia → Encaminhamento:** uma ocorrência pode gerar um encaminhamento quando for considerada relevante.

## 4. Fluxo geral

1. O usuário acessa o sistema.
2. O usuário registra uma ocorrência.
3. A ocorrência recebe descrição, data/hora e localização.
4. Uma imagem pode ser capturada pela câmera.
5. Os dados são enviados para análise da IA.
6. A IA identifica a situação e classifica a ocorrência.
7. O resultado e o status da ocorrência são armazenados.
8. Se a ocorrência for relevante, ela pode ser encaminhada para um órgão responsável.
9. O sistema registra e atualiza o status do encaminhamento.

## 5. Evolução do diagrama

O diagrama apresentado corresponde ao estado atual do projeto. Durante o desenvolvimento, algumas informações poderão ser modificadas ou novas classes poderão ser adicionadas. Por isso, os próximos diagramas deverão ser considerados versões atualizadas da modelagem.

## 6. Arquivo da imagem

A imagem do diagrama está disponível no arquivo:

- [Levantamento das Classes — FloodSense.png](/docs/product/diagramas/Levantamento%20das%20Classes%20%E2%80%94%20FloodSense.png)

Levantamento das Classes — FloodSense
1. Usuário

A classe Usuário representa a pessoa que utiliza o aplicativo FloodSense. Ela é responsável por realizar o cadastro, entrar e sair da sua conta e também acessar as informações das ocorrências registradas.

Atributos:

idUsuario
nome
email
senha

Métodos:

cadastrar()
realizarLogin()
encerrarSessao()
visualizarHistorico()
visualizarOcorrencia()

Requisitos relacionados: RF01, RF02, RF15, RF16 e RF17.

2. Ocorrência

A classe Ocorrência é uma das principais do sistema, pois representa um alagamento, enchente ou outra situação de risco identificada e registrada pelo usuário. Ela reúne as principais informações da ocorrência, como imagem, localização, data e resultado da análise.

Atributos:

idOcorrencia
descricao
imagem
dataHora
localizacao
resultadoIA
classificacao
status

Métodos:

registrarOcorrencia()
adicionarDescricao()
registrarLocalizacao()
registrarDataHora()
enviarParaAnalise()
armazenarOcorrencia()
atualizarStatus()

Requisitos relacionados: RF03, RF05, RF06, RF07, RF08, RF13, RF14, RF15, RF16, RF17, RF18 e RF19.

3. Câmera

A classe Câmera é responsável por utilizar a câmera do celular para registrar a imagem de uma possível ocorrência. Depois da captura, a imagem pode ser salva para ser utilizada na análise.

Atributos:

idCamera
imagemCapturada

Métodos:

abrirCamera()
capturarImagem()
salvarImagem()

Requisito relacionado: RF04.

4. Localização

A classe Localização representa o local onde a ocorrência aconteceu. Ela permite registrar informações geográficas para que seja possível identificar exatamente a região afetada.

Atributos:

latitude
longitude
endereco

Métodos:

obterLocalizacao()
atualizarLocalizacao()

Requisito relacionado: RF06.

5. AnáliseIA

A classe AnáliseIA é responsável por analisar a imagem enviada pelo usuário. A partir dessa análise, o sistema pode identificar a situação apresentada, classificá-la e gerar um resultado indicando o possível nível de risco.

Atributos:

idAnalise
resultado
classificacao
confianca

Métodos:

analisarImagem()
identificarSituacao()
classificarOcorrencia()
gerarResultado()

Requisitos relacionados: RF09, RF10, RF11 e RF12.

6. Encaminhamento

A classe Encaminhamento representa o processo de enviar uma ocorrência considerada relevante para o órgão responsável. Ela também permite registrar quando o encaminhamento foi realizado e acompanhar seu status.

Atributos:

idEncaminhamento
dataHoraEncaminhamento
orgaoResponsavel
statusEncaminhamento

Métodos:

verificarRelevancia()
encaminharOcorrencia()
registrarEncaminhamento()
atualizarStatus()

Requisitos relacionados: RF18 e RF19.

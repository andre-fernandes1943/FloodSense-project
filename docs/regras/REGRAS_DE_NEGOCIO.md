# Regras de Negócio - FloodSense

## RN01 - Cadastro de usuário
O sistema deve permitir o cadastro de usuários mediante o preenchimento dos dados obrigatórios necessários para criação da conta.

## RN02 - Acesso ao sistema
O usuário deverá informar e-mail e senha cadastrados para realizar o login no sistema.

## RN03 - Registro de ocorrência
Somente usuários autenticados poderão registrar ocorrências no FloodSense.

## RN04 - Informações obrigatórias da ocorrência
Para registrar uma ocorrência, o usuário deverá fornecer as informações obrigatórias definidas pelo sistema, incluindo imagem, descrição e localização quando disponíveis.

## RN05 - Captura de imagem
O sistema deverá solicitar permissão de acesso à câmera do dispositivo antes de permitir a captura de uma imagem.

## RN06 - Negação de acesso à câmera
Caso o usuário negue o acesso à câmera, o sistema deverá informar que a permissão é necessária para realizar a captura da imagem.

## RN07 - Localização da ocorrência
A ocorrência deverá possuir a localização geográfica do local onde foi registrada, quando a permissão de localização estiver disponível.

## RN08 - Data e hora
A data e o horário da ocorrência deverão ser registrados automaticamente pelo sistema no momento de sua criação.

## RN09 - Análise por Inteligência Artificial
A imagem enviada pelo usuário deverá ser processada pela Inteligência Artificial para identificar possíveis sinais de alagamento, enchente ou situação de risco.

## RN10 - Resultado da análise
O sistema deverá apresentar ao usuário o resultado obtido pela análise da Inteligência Artificial.

## RN11 - Classificação da ocorrência
A ocorrência deverá receber uma classificação de acordo com o resultado da análise realizada pela Inteligência Artificial.

## RN12 - Falha no envio para análise
Caso a imagem não possa ser enviada ou analisada pela Inteligência Artificial, o sistema deverá informar o usuário e permitir que ele tente realizar o procedimento novamente.

## RN13 - Armazenamento da ocorrência
Após o registro, os dados da ocorrência deverão ser armazenados para consulta posterior.

## RN14 - Associação ao usuário
Cada ocorrência deverá ser associada automaticamente ao usuário autenticado que realizou o registro.

## RN15 - Histórico de ocorrências
O usuário poderá visualizar somente as ocorrências associadas à sua própria conta.

## RN16 - Detalhes da ocorrência
Ao selecionar uma ocorrência no histórico, o sistema deverá apresentar seus dados registrados, incluindo imagem, localização, data, horário e resultado da análise.

## RN17 - Encaminhamento de ocorrência
Uma ocorrência considerada relevante poderá ser encaminhada de forma simulada ao órgão responsável, conforme os critérios definidos pelo sistema.

## RN18 - Status da ocorrência
O sistema deverá atualizar o status da ocorrência conforme seu fluxo de processamento.

Exemplo:

Registrada → Analisada → Considerada relevante → Encaminhada.

## RN19 - Exclusão de conta
A exclusão da conta do usuário não será considerada uma funcionalidade obrigatória do MVP, podendo ser implementada futuramente.

## RN20 - Escopo do MVP
As funcionalidades do sistema deverão priorizar o registro, análise, classificação, armazenamento e consulta de ocorrências relacionadas a possíveis alagamentos, enchentes e situações de risco.

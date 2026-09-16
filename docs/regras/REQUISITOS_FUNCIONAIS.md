# Requisitos Funcionais - FloodSense

## RF01 - Cadastro de usuário

O sistema deve permitir que o usuário realize seu cadastro para ter acesso às funcionalidades do FloodSense.

O usuário deverá informar os dados necessários para a criação da conta.

## RF02 - Login e sair do login

O sistema deve permitir que o usuário realize login para acessar sua conta.

O usuário deverá informar seu e-mail e senha cadastrados.

O sistema também deverá permitir que o usuário encerre sua sessão.

## RF03 - Registro de ocorrência

O sistema deve permitir que o usuário registre uma nova ocorrência relacionada a possíveis alagamentos, enchentes ou situações de risco.

## RF04 - Tirar foto pela câmera

O sistema deve permitir que o usuário capture uma imagem utilizando a câmera do dispositivo.

## RF05 - Adicionar descrição da ocorrência

O sistema deve permitir que o usuário adicione uma descrição à ocorrência.

O usuário poderá inserir informações adicionais sobre a situação observada, como condições do local e intensidade aparente da água.

## RF06 - Captura da localização

O sistema deve capturar a localização geográfica da ocorrência, obtendo a posição aproximada do local onde a ocorrência foi registrada.

## RF07 - Registrar data e hora

O sistema deve registrar automaticamente a data e o horário em que a ocorrência foi criada.

## RF08 - Envio da ocorrência para análise

O sistema deve permitir que o usuário envie uma ocorrência registrada para análise, após o preenchimento das informações obrigatórias.

## RF09 - IA analisar a imagem

A Inteligência Artificial deverá processar a imagem enviada pelo usuário e identificar características visuais que possam indicar a presença de alagamento, enchente ou situação de risco.

## RF10 - Identificar possível alagamento, enchente ou situação de risco

O sistema deve identificar, a partir da análise da imagem, possíveis situações de alagamento, enchente ou situação de risco.

## RF11 - Classificação da ocorrência

Após a análise da imagem, o sistema deverá atribuir à ocorrência uma categoria correspondente ao resultado identificado.

## RF12 - Mostrar resultado da análise ao usuário

O sistema deve apresentar ao usuário o resultado da análise realizada sobre a imagem.

**Exemplo:**

**Resultado:** Possível alagamento  
**Classificação:** Situação de risco

## RF13 - Armazenar a ocorrência

Após o registro, os dados da ocorrência deverão ser armazenados em uma estrutura de persistência, permitindo que sejam consultados posteriormente.

## RF14 - Armazenar imagem, localização, data/hora e resultado da IA

O sistema deve armazenar a imagem, localização, data, horário e resultado da análise da Inteligência Artificial associados à ocorrência.

## RF15 - Associar ocorrência ao usuário

O sistema deverá associar cada ocorrência ao usuário que realizou o registro.

Ao criar uma ocorrência, o sistema deverá identificar automaticamente o usuário autenticado e vincular o registro à sua conta.

## RF16 - Visualizar histórico de ocorrências

O sistema deverá permitir que o usuário visualize seu histórico de ocorrências registradas.

## RF17 - Visualizar detalhes de uma ocorrência

O sistema deverá permitir que o usuário visualize os detalhes de uma ocorrência registrada.

Ao selecionar uma ocorrência no histórico, o sistema deverá apresentar as informações relacionadas ao registro.

## RF18 - Simular encaminhamento de ocorrências relevantes ao órgão responsável

O sistema deve simular o encaminhamento de ocorrências consideradas relevantes ao órgão responsável.

Quando uma ocorrência for considerada relevante de acordo com os critérios definidos, o sistema deverá permitir a simulação do seu encaminhamento.

## RF19 - Registrar que a ocorrência foi encaminhada

Após a simulação do encaminhamento, o sistema deverá atualizar o status da ocorrência e registrar as informações relacionadas ao encaminhamento.

**Exemplo de fluxo de status:**

**Registrada → Analisada → Considerada relevante → Encaminhada**

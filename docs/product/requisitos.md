01 - Cadastro de usuário.<br>
—————————————<br>
O sistema permitir que o usuário realize seu cadastro para ter acesso às funcionalidades do FloodSense.
O usuário deverá informar os dados necessários para criação da conta.

2 - Login e sair do login.<br>
—————————————<br>
O sistema permitir que o usuário realize login para acessar sua conta.
O usuário deverá informar seu e-mail e senha cadastrados.

3 - Registro de ocorrência.<br>
—————————————<br>
O sistema deve permitir que o usuário registre uma nova ocorrência relacionada a possíveis alagamentos, enchentes ou situações de risco.

4 - Tirar foto pela câmera.<br>
—————————————<br>
O sistema permitira que o usuário capture uma imagem utilizando a câmera do dispositivo.

5 - Adicionar descrição da ocorrência.<br>
—————————————<br>
O sistema deve permitir que o usuário adicione uma descrição à ocorrência.
O usuário poderá inserir informações adicionais sobre a situação observada, como condições do local, intensidade aparente da água. 

6 - Captura da localização.<br>
—————————————<br>
O sistema deve capturar a localização geográfica da ocorrência, para obter a posição aproximada do local onde a ocorrência foi registrada.

7- Registrar data e hora .<br>
—————————————<br>
O sistema deve registrar automaticamente a data e o horário em que a ocorrência foi criada.

8  -Envio da ocorrência para análise.<br>
—————————————<br>
O sistema deve permitir que o usuário envie uma ocorrência registrada para análise, após o preenchimento das informações obrigatórias. 

9 - IA analisar a imagem.<br>
—————————————<br>
IA deverá processar a imagem enviada pelo usuário e identificar características visuais que possam indicar a presença de alagamento, enchente ou situação de risco.

10 - Identificar possível alagamento enchentes ou situação de risco.<br>
—————————————<br>
O sistema deve identificar, a partir da análise da imagem, possíveis situações de alagamento, enchente ou alto risco. 

11 - Classificação da ocorrência.<br>
—————————————<br>
Após a análise da imagem, o sistema deverá atribuir à ocorrência em uma categoria correspondente ao resultado identificado.
 
12 - Mostrar resultado da análise ao usuário.<br>
—————————————<br>
O sistema deve apresentar ao usuário o resultado da análise realizada pela imagem.

Exemplo:
Resultado: Possível alagamento
Classificação: Situação de risco

13 - Armazenar a ocorrência.<br>
—————————————<br>
Após o registro, os dados deverão ser armazenados em uma estrutura de persistência, permitindo que sejam consultados posteriormente. 
  
14 - Armazenar imagem, localização, data/hora e resultado da IA.<br>
—————————————<br>
O sistema deve armazenar a localização, data, horário e resultado da análise da IA associados á ocorrência.

15 - Associar ocorrência ao usuário.<br>
—————————————<br>
O sistema vai associar cada ocorrência ao usuário que realizou o registro.
Ao criar uma ocorrência, o sistema deverá identificar automaticamente o usuário autenticado e vincular o registro à sua conta.

16 - Visualizar histórico de ocorrências.<br>
—————————————<br>
O sistema vai permitir que o usuário visualize seu histórico de ocorrências registradas.

17 - Visualizar detalhes de uma ocorrência.<br>
—————————————<br>
O sistema  permitira que o usuário visualize os detalhes de uma ocorrência registrada.
Ao selecionar uma ocorrência no histórico, o sistema deverá apresentar as informações relacionadas ao registro.

18 - Simular encaminhamento de ocorrência relevantes ao órgão responsável.<br>
—————————————<br>
Descrição:
O sistema deve simular o encaminhamento de ocorrências consideradas relevantes ao órgão responsável , quando uma 
ocorrência for considerada relevante de acordo com os critérios definidos ,o sistema permitirá  a simulação do seu encaminhamento.

19 - Registrar que a ocorrência foi encaminhada. <br>
—————————————<br>
Após a simulação do encaminhamento, o sistema deverá atualizar o status da ocorrência e registrar as informações relacionadas ao encaminhamento.
Exemplo de status:<br>
—————————————<br>
Registrada → Analisada → Considerada relevante → Encaminhada.

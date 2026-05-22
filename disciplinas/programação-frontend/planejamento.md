# JavaScript - FloodSense

Os arquivos JavaScript  são responsáveis pelas funcionalidades dinâmicas do site daFloodSense.

O código foi desenvolvido para auxiliar no funcionamento da área de cadastro da plataforma, permitindo a validação de informações e o preenchimento automático de dados através da integração com uma API externa.

---

# Funcionalidades

- Validação de CEP
- Consulta automática de endereço
- Integração com API externa
- Preenchimento automático de rua, bairro e cidade
- Manipulação de elementos HTML
- Comunicação entre formulário e sistema

---

# API Utilizada

O projeto utiliza a API pública do ViaCEP para realizar consultas de endereço a partir do CEP informado pelo usuário.

## Site da API
https://viacep.com.br/

## Exemplo de requisição
```javascript
https://viacep.com.br/ws/01001000/json/

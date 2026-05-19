document.addEventListener("DOMContentLoaded", () => { // Espera o carregamento completo do HTML

    // Dados salvos
    const rua = localStorage.getItem("rua"); // Recupera a rua salva no localStorage
    const bairro = localStorage.getItem("bairro"); // Recupera o bairro salvo
    const cidade = localStorage.getItem("cidade"); // Recupera a cidade salva

    // Mostrar endereço
    document.getElementById("endereco").innerText =
        `${rua}, ${bairro} - ${cidade}`; // Exibe o endereço na página

    // Nível fictício da água
    const nivel = Math.floor(Math.random() * 101); // Gera um número aleatório entre 0 e 100

    document.getElementById("nivelAgua").innerText =
        nivel + "%"; // Mostra o nível da água na página

    // Situação fictícia
    let situacao = ""; // Cria uma variável para armazenar a situação

    if (nivel < 30) { // Verifica se o nível é menor que 30
        situacao = "NORMAL"; // Define situação como NORMAL
    }
    else if (nivel < 70) {  // Verifica se o nível é menor que 70
        situacao = "PERIGO";  // Define situação como PERIGO
    }
    else { // Caso o nível seja 70 ou mais
        situacao = "GRAVE"; // Define situação como GRAVE
    }

    document.getElementById("status").innerText =
        situacao;  // Mostra a situação na página

const status = document.getElementById("status"); // Pega o elemento status

if (nivel < 30) { // Se o nível for menor que 30 
    status.innerText = "NORMAL";  // Exibe NORMAL
    status.style.color = "green";} // Muda a cor para verde

else if (nivel < 70) { // Se o nível estiver entre 30 e 69   
    status.innerText = "PERIGO"; // Exibe PERIGO
    status.style.color = "orange";} // Muda a cor para laranja
    
else { // Se o nível for 70 ou maior        
    status.innerText = "GRAVE"; // Exibe GRAVE    
    status.style.color = "red";} // Muda a cor para vermelho


});
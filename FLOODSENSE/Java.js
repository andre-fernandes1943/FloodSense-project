   function pesquisacep(valor) {
        console.log(valor);

        //Nova variável "cep" somente com dígitos.
        var cep = valor.replace(/\D/g, '');

        //Verifica se campo cep possui valor informado.
        if (cep != "") {

            //Expressão regular para validar o CEP.
            var validacep = /^[0-9]{8}$/;

            //Valida o formato do CEP.
            if(validacep.test(cep)) {

                //Preenche os campos com "..." enquanto consulta webservice.
                document.getElementById('rua').value="...";
                document.getElementById('bairro').value="...";
                document.getElementById('cidade').value="...";

                //Cria um elemento javascript.
                var script = document.createElement('script');

                //Sincroniza com o callback.
                script.src = 'https://viacep.com.br/ws/'+ cep + '/json/?callback=meu_callback';

                //Insere script no documento e carrega o conteúdo.
                document.body.appendChild(script);

            } //end if.
            else {
                //cep é inválido.
                limpa_formulario_cep();
                alert("Formato de CEP inválido.");
            }
        } //end if.
        else {
            //cep sem valor, limpa formulário.
            limpa_formulario_cep();
        }
    };
     function limpa_formulario_cep() {
            //Limpa valores do formulário de cep.
            document.getElementById('rua').value=("");
            document.getElementById('bairro').value=("");
            document.getElementById('cidade').value=("");
    }
     function meu_callback(conteudo) {
        if (!("erro" in conteudo)) {
            //Atualiza os campos com os valores.
            document.getElementById('rua').value=(conteudo.logradouro);
            document.getElementById('bairro').value=(conteudo.bairro);
            document.getElementById('cidade').value=(conteudo.localidade);
        } //end if.
        else {
            //CEP não Encontrado.
            limpa_formulario_cep();
            alert("CEP não encontrado.");
        }
    }
document.addEventListener("DOMContentLoaded", () => { // Espera todo o HTML carregar antes de executar o JavaScript

    console.log("JS carregado"); // Mostra no console que o JS foi carregado

    const formulario = document.getElementById("formulario"); // Pega o formulário pelo id "formulario"

    console.log(formulario); // Mostra o formulário encontrado 

    formulario.addEventListener("submit", function(event){  // Cria um evento para quando o formulário for enviado

        event.preventDefault(); //impede o recarregamento automatico da página

        const rua = document.getElementById("rua").value; //pega o valor digitado no campo rua
        const bairro = document.getElementById("bairro").value; // pega o valor digitado no campo bairro
        const cidade = document.getElementById("cidade").value; // pega o valor digitado no campo cidade

        console.log(rua); // mostra a rua
        console.log(bairro); // mostra o bairro
        console.log(cidade);  // mostra a cidade

        localStorage.setItem("rua", rua); // salva a rua no armazenamento local
        localStorage.setItem("bairro", bairro); // salva a bairro no armazenamento local
        localStorage.setItem("cidade", cidade); // salva a cidade no armazenamento local

window.open("Floodsense.html", "_blank"); // Abre a página "Floodsense.html" em uma nova aba
    });

});
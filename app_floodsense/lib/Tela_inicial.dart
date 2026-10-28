import 'package:flutter/material.dart';
import 'Tela_cadastro.dart';
import 'Tela_ocorrencia.dart';

const corAzulEscuro = Color(0xFF0A4B8C);
const corAzulMedio = Color(0xFF2576D7);
const corAzulClaro = Color.fromARGB(255, 84, 162, 231);
const corLaranja = Color(0xFFFF7A20);
const corFundo = Color(0xFFF0F7FF);

// Tela de login do App(Substitui o StatelessWidget pelo StatefulWidget para o Aplicativo realmente começar a funcionar(obs: André))
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar exatamente o que o usuário digitar nos campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Permite que o usuário esconda ou não a senha que tá digitando.
  bool _ocultarSenha = true; 
  bool _carregando = false;  

  // Limpa o cache/memoria que estava sendo usada quando fechar o App
  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o e-mail e a senha.')),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // (Obs: André) Aqui é o local onde você tem que colocar as requisições e envios de dados para o Supabase Webert.
      
      // Exemplo do que você pode fazer aqui:
      // final resposta = await Supabase.instance.client.auth.signInWithPassword(
      //   email: email,
      //   password: senha,
      // );
      
      // Simulando o tempo de resposta do servidor 
      await Future.delayed(const Duration(seconds: 2)); // <--- (REMOVA ISSO QUANDO conectar O SUPABASE)

      // Se o login der certo, a execução continua aqui e enviamos para a tela de ocorrência
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TelaOcorrencia(),
          ),
        );
      }
    } catch (erro) {
      // Se o login falhar (senha errada e tudo mais), cai neste bloco de baixo.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail ou senha incorretos. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A4B8C), Color(0xFFB3D8F5), Color(0xFFF0F7FF)],
            stops: [0.0, 0.35, 0.7],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo do App
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2), // Cor branca com transparência suave
                        blurRadius: 50.0,
                        spreadRadius: 1.0, 
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'lib/assets/logo_floodsense.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'FloodSense',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: corAzulEscuro,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'Tecnologia para prevenir\ne proteger vidas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: corAzulEscuro,
                    height: 1.3,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 40),
                const Text(
                  'Bem-vindo(a)!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: corAzulEscuro,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Faça seu login para continuar\nno FloodSense.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF444444),
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 32),

                // Email
                TextField(
                  controller: _emailController, // Conectado para capturar o texto
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: corAzulMedio,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: corAzulClaro),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: corAzulClaro),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // campo da senha
                TextField(
                  controller: _senhaController, // Conectado para capturar o texto
                  obscureText: _ocultarSenha,   // Esconde a senha conforme o estado da variável
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: corAzulMedio,
                    ),
                    suffixIcon: IconButton(
                      // Muda o ícone dependendo se a senha está oculta ou não
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: corAzulMedio,
                      ),
                      onPressed: () {
                        // Inverte o estado da variável para mostrar/esconder a senha
                        setState(() {
                          _ocultarSenha = !_ocultarSenha;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: corAzulClaro),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: corAzulClaro),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Botão "Esqueci asenha" (Não vamos adicionar essa feature agora, mas deixei para caso a gente faça isso futuramente)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueci minha senha?',
                      style: TextStyle(
                        color: corLaranja,
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                // botão para ir para a tela inicial.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(237, 255, 121, 32),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    // Se estiver carregando, desativa o botão, senão chama a função de login
                    onPressed: _carregando ? null : _fazerLogin,
                    // Mostra o "loading" se estiver conectando, ou os textos normais se não estiver
                    child: _carregando
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // ==========================================
                // DIVISOR E RODAPÉ
                // ==========================================
                const Row(
                  children: [
                    Expanded(child: Divider(color: corAzulClaro)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Ainda não tem uma conta?',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: corAzulClaro)),
                  ],
                ),

                const SizedBox(height: 16),

                // Botão Criar cadastro
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: corAzulMedio, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaCadastro(),
                        ),
                      );
                    },
                    child: const Text(
                      'Criar cadastro',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: corAzulEscuro,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Imagem da cidade no rodapé
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1577945740737-64f462f503e8?w=800&q=80',
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'Tela_ocorrencia.dart';

const azulEscuro = Color(0xFF064A98);
const azulMedio = Color(0xFF159FE0);
const azulClaro = Color(0xFFE8F7FF);
const laranja = Color(0xFFFF7A20);
const cinzaTexto = Color(0xFF526581);

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // deixa a senha escondida ou não.
  bool ocultarSenha = true;
  bool ocultarConfirmacao = true;
  bool _carregando = false;

  // é isso aqui que vai pegar os dados digitados e mandar para o backend.
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
  // Validador do cadastro.
  Future<void> _realizarCadastro() async {
    // 1. Extração dos dados.
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;
    final confirmarSenha = confirmarSenhaController.text;

    // 2. Validação simples no próprio App.
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // (Obs: André) É aqui que voce faz a requisição para o backend Webert!
      // é nesse local que voce tem que colocar as resquisições e envios de dados
      // código logo a baixo.
      // =====================================================================
      
      // Exemplo do que você deve fazer aqui usando o Supabase:
      // final AuthResponse res = await Supabase.instance.client.auth.signUp(
      //   email: email,
      //   password: senha,
      //   data: {'nome_completo': nome}, // Enviando o nome para os metadados do usuário
      // );
      
      await Future.delayed(const Duration(seconds: 2)); // Não esqueça de tirar qaundo conectar o Supabase.

      // Se o cadastro for bem-sucedido, mostramos a mensagem e vamos para a tela inicial
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TelaOcorrencia(),
          ),
        );
      }
    } catch (erro) {
      // Se ocorrer um erro no cadastro (ex: email já existe), mostramos o erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar: $erro'),
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
      backgroundColor: azulClaro,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF7FCFF),
                Color(0xFFE5F7FF),
                Color(0xFFD5F2FF),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                const FloodSenseLogo(),
                const SizedBox(height: 10),
                const Text(
                  'Crie sua conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azulEscuro,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cadastre-se para começar\na usar o FloodSense.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cinzaTexto,
                    fontSize: 18,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      CampoCadastro(
                        controller: nomeController,
                        hint: 'Nome completo',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      CampoCadastro(
                        controller: emailController,
                        hint: 'E-mail',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      CampoCadastro(
                        controller: senhaController,
                        hint: 'Senha',
                        icon: Icons.lock_outline,
                        obscureText: ocultarSenha,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ocultarSenha = !ocultarSenha;
                            });
                          },
                          icon: Icon(
                            ocultarSenha
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: azulEscuro,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CampoCadastro(
                        controller: confirmarSenhaController,
                        hint: 'Confirmar senha',
                        icon: Icons.lock_outline,
                        obscureText: ocultarConfirmacao,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ocultarConfirmacao = !ocultarConfirmacao;
                            });
                          },
                          icon: Icon(
                            ocultarConfirmacao
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: azulEscuro,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      
                      // Botão de realizar cadastro
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _realizarCadastro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: laranja,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _carregando 
                              ? const SizedBox(
                                  height: 28, 
                                  width: 28, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Criar cadastro',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 18),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 28,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFFB9D6E7),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Já possui uma conta?',
                              style: TextStyle(
                                color: cinzaTexto,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFFB9D6E7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      
                      // Aqui é o botão "Entrar" ele faz voltar para a tela de login.
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context); 
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: azulEscuro,
                            side: const BorderSide(
                              color: azulMedio,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                const FundoCidade(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET: CAMPO DE TEXTO PADRONIZADO
// ==========================================
class CampoCadastro extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const CampoCadastro({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: azulEscuro,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF7488A3),
        ),
        prefixIcon: Icon(
          icon,
          color: azulEscuro,
          size: 28,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.75),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFBCD6E5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: azulMedio,
            width: 2,
          ),
        ),
      ),
    );
  }
}

// Img da logo no topo da tela.
class FloodSenseLogo extends StatelessWidget {
  const FloodSenseLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/logo_floodsense.png',
          width: 118,
          height: 118,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flood',
              style: TextStyle(
                color: azulEscuro,
                fontSize: 35,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Sense',
              style: TextStyle(
                color: azulMedio,
                fontSize: 35,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const Text(
          'Tecnologia para prevenir\ne proteger vidas.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: azulEscuro,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

// decoração de fundo com os predio.
class FundoCidade extends StatelessWidget {
  const FundoCidade({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8FDCFF),
            Color(0xFF159FE0),
            Color(0xFF064A98),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70),
          topRight: Radius.circular(70),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 25,
            top: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Predio(28, 55),
                Predio(35, 85),
                Predio(25, 65),
                Predio(42, 105),
                Predio(30, 72),
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Predio(25, 60),
                Predio(40, 100),
                Predio(30, 72),
                Predio(35, 88),
              ],
            ),
          ),
          Positioned(
            left: 35,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 5,
                  decoration: BoxDecoration(
                    color: laranja,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cidades mais seguras,\npessoas mais protegidas.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 210,
              height: 65,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: laranja,
                    width: 6,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Predio extends StatelessWidget {
  final double largura;
  final double altura;

  const Predio(
    this.largura,
    this.altura, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: azulEscuro.withValues(alpha: 0.80),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(3),
        ),
      ),
    );
  }
}
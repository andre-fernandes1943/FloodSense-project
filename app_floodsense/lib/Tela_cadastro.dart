import 'package:flutter/material.dart';
import 'Tela_ocorrencia.dart';

// CORES DO FLOODSENSE
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
  bool ocultarSenha = true;
  bool ocultarConfirmacao = true;

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

                // LOGO
                const FloodSenseLogo(),

                const SizedBox(height: 10),

                // TÍTULO
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
                              ocultarConfirmacao =
                                  !ocultarConfirmacao;
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

                      // BOTÃO CRIAR CADASTRO
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cadastro realizado com sucesso!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: laranja,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
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

                      // JÁ POSSUI CONTA
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

                      // BOTÃO ENTRAR
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TelaOcorrencia(),
                              ),
                            );
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

                // PARTE INFERIOR DECORATIVA
                const FundoCidade(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CAMPOS
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

// LOGO FEITO NO PRÓPRIO FLUTTER
class FloodSenseLogo extends StatelessWidget {
  const FloodSenseLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 118,
          height: 118,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            border: Border.all(
              color: azulEscuro,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(34),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 12,
                child: Icon(
                  Icons.wifi,
                  color: azulMedio,
                  size: 42,
                ),
              ),
              const Positioned(
                top: 45,
                child: Icon(
                  Icons.water_drop,
                  color: azulMedio,
                  size: 55,
                ),
              ),
              Positioned(
                bottom: 7,
                child: SizedBox(
                  width: 82,
                  child: Column(
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: azulEscuro,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 3,
                        width: 62,
                        decoration: BoxDecoration(
                          color: azulMedio,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

// DECORAÇÃO INFERIOR
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
              children: [
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
              children: [
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

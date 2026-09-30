import 'package:flutter/material.dart';

// Cores exatas da sua imagem
const corAzulEscuro = Color(0xFF0A4B8C);
const corAzulMedio = Color(0xFF2576D7);
const corAzulClaro = Color(0xFFE0EFFC);
const corLaranja = Color(0xFFFF7A20);
const corFundo = Color(0xFFF0F7FF);

void main() {
  runApp(const FloodSenseApp());
}

class FloodSenseApp extends StatelessWidget {
  const FloodSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloodSense 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔵 FUNDO COM GRADIENTE AZUL IGUAL A IMAGEM
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A4B8C), // azul escuro no canto superior
              Color(0xFFB3D8F5), // azul mais claro
              Color(0xFFF0F7FF), // bem claro embaixo
            ],
            stops: [0.0, 0.35, 0.7],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                const SizedBox(height: 20),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: corAzulMedio.withValues(alpha: 0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi, color: corAzulEscuro, size: 22),
                      const SizedBox(height: 4),
                      Icon(Icons.water_drop, color: corAzulMedio, size: 34),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Título
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(
                        text: 'Flood',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: corAzulEscuro,
                        ),
                      ),
                      TextSpan(
                        text: 'Sense',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: corAzulMedio,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: ColoredBox(
                            color: corLaranja,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: Text(
                                '2.0',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  ),
                ),
                const SizedBox(height: 40),

                // Bem-vindo
                const Text(
                  'Bem-vindo(a)!',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: corAzulEscuro,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Faça seu login para continuar\nno FloodSense 2.0.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
                ),
                const SizedBox(height: 32),

                // Campo E-mail
                TextField(
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined, color: corAzulMedio),
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Campo Senha
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outlined, color: corAzulMedio),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_outlined, color: corAzulMedio),
                      onPressed: () {},
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
                  obscureText: true,
                ),
                const SizedBox(height: 8),

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueci minha senha?',
                      style: TextStyle(color: corLaranja, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corLaranja,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divisor + Criar conta
                const Row(
                  children: [
                    Expanded(child: Divider(color: corAzulClaro)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Ainda não tem uma conta?',
                        style: TextStyle(color: Colors.grey),
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
                    onPressed: () {},
                    child: const Text(
                      'Criar cadastro',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: corAzulEscuro,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🌆 IMAGEM DA CIDADE NO RODAPÉ
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
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

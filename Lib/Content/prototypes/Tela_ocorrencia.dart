import 'package:flutter/material.dart';

void main() {
  runApp(const FloodSenseApp());
}

class FloodSenseApp extends StatelessWidget {
  const FloodSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FloodSense',
      theme: ThemeData(
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  static const azulEscuro = Color(0xFF064A98);
  static const azulClaro = Color(0xFFE8F7FF);
  static const laranja = Color(0xFFFF8A22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulClaro,
      body: SafeArea(
        child: Stack(
          children: [
            // FUNDO DECORATIVO
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFF0875C9),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: -50,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xFFB9E9FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: -120,
              right: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFF80D8F7),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // LINHA LARANJA DECORATIVA
            Positioned(
              top: 25,
              left: 0,
              child: Container(
                width: 150,
                height: 5,
                decoration: const BoxDecoration(
                  color: laranja,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                ),
              ),
            ),

            // CONTEÚDO
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // LOGO
                  const Icon(
                    Icons.water_drop,
                    color: Color(0xFF168DE2),
                    size: 60,
                  ),

                  const Text(
                    'FloodSense',
                    style: TextStyle(
                      color: azulEscuro,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    'Tecnologia para prevenir e proteger vidas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azulEscuro,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // OLÁ JÉSSICA
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Olá, Jéssica! 👋',
                      style: TextStyle(
                        color: azulEscuro,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'O que deseja fazer hoje?',
                      style: TextStyle(
                        color: Color(0xFF53627A),
                        fontSize: 21,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // REGISTRAR OCORRÊNCIA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFA12A),
                          Color(0xFFFF6B18),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                          size: 48,
                        ),

                        SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registrar ocorrência',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Envie fotos, descreva o problema\ne ajude a sua cidade.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 32,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // MINHAS OCORRÊNCIAS
                  const CardMenu(
                    icone: Icons.assignment_outlined,
                    titulo: 'Minhas ocorrências',
                    descricao:
                        'Acompanhe o status das\nsuas solicitações.',
                  ),

                  const SizedBox(height: 18),

                  // MAPA
                  const CardMenu(
                    icone: Icons.location_on_outlined,
                    titulo: 'Mapa',
                    descricao:
                        'Visualize ocorrências na\nsua região.',
                  ),

                  const SizedBox(height: 45),

                  // PARTE INFERIOR
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: azulEscuro,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Divider(
                            color: laranja,
                            thickness: 5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cidades mais seguras,\npessoas mais protegidas.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CARD DAS OPÇÕES
class CardMenu extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const CardMenu({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFDDF3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: const Color(0xFF064A98),
              size: 40,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF064A98),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  descricao,
                  style: const TextStyle(
                    color: Color(0xFF53627A),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward,
            color: Color(0xFF064A98),
            size: 30,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'Tela_inicial.dart'; 

void main() {
  runApp(const FloodSenseApp());
}

class FloodSenseApp extends StatelessWidget {
  const FloodSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FloodSense 2.0',
      theme: ThemeData(
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const LoginPage(), // <- Aqui você coloca a classe da tela inicial Jessica, eu não fiz isso porque não aprendi sobre o seu codigo ainda(obs feita por: André)
    );
  }
}
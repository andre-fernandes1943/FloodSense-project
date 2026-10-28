// linha 3 Importa o pacote principal do Flutter que tem os componentes visuais.
// linha 4 Conecta a interface de login que é o "Tela_inicial.dart" com o arquivo de inicialização do App, que é o "main.dart".
import 'package:flutter/material.dart';
import 'Tela_inicial.dart';

// A função main() é a primeira coisa que o celular executa quando abre o App.
// 'runApp' diz ao Flutter para rodar a classe principal 'FloodSenseApp'.
void main() {
  runApp(const FloodSenseApp());
}

class FloodSenseApp extends StatelessWidget {
  const FloodSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloodSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        fontFamily: 'Roboto'
      ),
      home: const LoginPage(), //conecta a tela de login com o arquivo main.dart que é o arquivo "Tela_inicial.dart".
    );
  }
}
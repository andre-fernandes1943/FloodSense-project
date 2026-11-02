// Importação do pacote principal do Flutter para a interface visual
import 'package:flutter/material.dart';

// Importação do pacote oficial do Supabase para conectar com o banco de dados
import 'package:supabase_flutter/supabase_flutter.dart';

// Conecta a interface de login ("Tela_inicial.dart") com o "main.dart"
import 'Tela_inicial.dart';

// =========================================================================
// ATALHO GLOBAL DO SUPABASE
// Permite usar o comando 'supabase' em qualquer tela do app de forma simples
// =========================================================================
final supabase = Supabase.instance.client;

// A função main() é a primeira coisa que o celular executa quando abre o App.
// O 'async' permite que o app espere o Supabase conectar antes de desenhar a tela.
Future<void> main() async {
  // Garante a inicialização dos componentes nativos do Flutter antes de ligar o banco
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a conexão com o servidor do Supabase
  await Supabase.initialize(
    url: 'https://ntmvcluauovtxvbissku.supabase.co',      // URl que conecta o app ao banco de dados do Supabase
    publishableKey: 'sb_publishable_GxRL1O1fCQD0T0q19i0T-w_uzF68kOa', // chave publica de identificação do app no Supabase
  );

  // 'runApp' diz ao Flutter para rodar a classe principal 'FloodSenseApp'
  runApp(const FloodSenseApp());
}

// ==========================================
// CLASSE PRINCIPAL DO APLICATIVO
// ==========================================
class FloodSenseApp extends StatelessWidget {
  const FloodSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloodSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        fontFamily: 'Roboto',
      ),
      // Conecta a tela de login como a página inicial do aplicativo
      home: const LoginPage(), 
    );
  }
}
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  // Garante que o Flutter está pronto antes de rodar o app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Agora arrancamos o aplicativo direto, sem o AppDatabase!
  runApp(const CatequeseApp());
}

class CatequeseApp extends StatelessWidget {
  const CatequeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Catequese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[800]!),
        useMaterial3: true,
      ),
      // O LoginScreen agora é chamado sozinho, sem o parâmetro database
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
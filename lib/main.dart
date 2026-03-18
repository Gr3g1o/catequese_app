import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // IMPORTAMOS AGORA O HOME SCREEN
import 'database/app_database.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final database = AppDatabase();
  
  runApp(CatequeseApp(database: database));
}

class CatequeseApp extends StatelessWidget {
  final AppDatabase database;
  
  const CatequeseApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Catequese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[800]!),
        useMaterial3: true,
      ),
      // MUDANÇA AQUI: Agora arranca com o HomeScreen
      home: HomeScreen(database: database),
      debugShowCheckedModeBanner: false,
    );
  }
}
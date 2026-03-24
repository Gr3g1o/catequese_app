import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeController.text = prefs.getString('userName') ?? '';
      _emailController.text = prefs.getString('userEmail') ?? '';
    });
  }

  Future<void> _salvarAlteracoes() async {
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os campos não podem ficar vazios.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    bool sucesso = await ApiService.atualizarMeuPerfil(_nomeController.text.trim(), _emailController.text.trim());
    
    setState(() => _isLoading = false);

    if (sucesso) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Volta pra Home avisando que atualizou
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar perfil.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmarInativacaoConta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Conta?'),
        content: const Text(
          'Ao inativar sua conta, você perderá o acesso ao aplicativo temporariamente.\n\n'
          'Seus dados e fichas continuarão salvos na paróquia, mas você precisará que um Administrador reative seu acesso para entrar novamente.\n\n'
          'Deseja continuar?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancelar')
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // Fecha o dialog
              setState(() => _isLoading = true);
              
              await ApiService.inativarMinhaConta();
              await ApiService.logout();
              
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sim, inativar', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nome de Usuário', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text('E-mail (Login)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), foregroundColor: Colors.white),
                      onPressed: _salvarAlteracoes,
                      child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 20),
                  
                  const Text('Zona de Perigo', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                      icon: const Icon(Icons.warning_amber_rounded),
                      label: const Text('Desativar Minha Conta'),
                      onPressed: _confirmarInativacaoConta,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
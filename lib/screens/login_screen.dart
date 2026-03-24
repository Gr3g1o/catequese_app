import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isInternal = false; 
  bool _codigoEnviado = false; 
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _codigoController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  void _exibirEULA(BuildContext context) {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _mostrarErro('Digite um e-mail válido antes de continuar.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso e Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Ao prosseguir, você concorda que:\n\n'
            '1. Coleta de Dados: Coletaremos seu e-mail para identificação da ficha de catequese.\n'
            '2. Uso: Seus dados serão usados exclusivamente para fins paroquiais.\n'
            '3. Segurança: Em caso de falhas de segurança de terceiros, a Paróquia São José Operário fica isenta de responsabilidade civil.\n'
            '4. Exclusão: Você pode solicitar a inativação da sua conta a qualquer momento.',
            style: TextStyle(fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('REJEITAR', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
              _pedirCodigo(); 
            },
            child: const Text('ACEITAR E ENTRAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _pedirCodigo() async {
    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus(); 

    bool sucesso = await ApiService.solicitarCodigoEmail(_emailController.text);
    setState(() => _isLoading = false);

    if (sucesso) {
      setState(() => _codigoEnviado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código enviado! Verifique seu e-mail.'), backgroundColor: Colors.green),
      );
    } else {
      _mostrarErro('Erro ao enviar o código. Tente novamente mais tarde.');
    }
  }

  // --- NOVO: FORÇAR DIGITAÇÃO DO NOME ---
  Future<void> _pedirNomeObrigatorio(String emailSalvo) async {
    final nomeCtrl = TextEditingController();
    
    await showDialog(
      context: context,
      barrierDismissible: false, // Não deixa fechar clicando fora
      builder: (context) => AlertDialog(
        title: const Text('Bem-vindo!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Como este é o seu primeiro acesso, por favor, informe seu Nome e Sobrenome para identificação:'),
            const SizedBox(height: 15),
            TextField(
              controller: nomeCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nome e Sobrenome',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (nomeCtrl.text.trim().split(' ').length < 2) {
                _mostrarErro('Por favor, digite nome e sobrenome.');
                return;
              }
              // Atualiza o perfil no banco e no app
              await ApiService.atualizarMeuPerfil(nomeCtrl.text.trim(), emailSalvo);
              Navigator.pop(context); // Fecha o dialog
            },
            child: const Text('Salvar e Continuar'),
          ),
        ],
      ),
    );
    
    // Após preencher, vai para a Home
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<void> _validarCodigo() async {
    if (_codigoController.text.trim().length != 6) {
      _mostrarErro('O código deve ter 6 números.');
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final result = await ApiService.validarCodigoEmail(
      _emailController.text,
      _codigoController.text,
    );

    setState(() => _isLoading = false);

    if (result['sucesso'] == true && mounted) {
      // Se for o primeiro acesso, o nome será "Usuário"
      if (result['nome'] == 'Usuário' || result['nome'] == null) {
        await _pedirNomeObrigatorio(result['email'] ?? _emailController.text);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } else {
      _mostrarErro('Código inválido ou expirado.');
    }
  }

  Future<void> _loginInterno() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      _mostrarErro('Preencha usuário e senha.');
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final result = await ApiService.loginInterno(_userController.text, _passController.text);

    setState(() => _isLoading = false);

    if (result['sucesso'] == true && mounted) {
      if (result['nome'] == 'Usuário' || result['nome'] == null) {
        await _pedirNomeObrigatorio(result['email'] ?? '');
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } else {
      _mostrarErro('Usuário ou senha incorretos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 20),
              const Text(
                'Paróquia São José Operário',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 40),

              if (_isLoading)
                const CircularProgressIndicator()
              else if (!_isInternal) ...[
                // --- FLUXO PARA PAIS (E-MAIL) ---
                if (!_codigoEnviado) ...[
                  const Text('Acesse sua ficha de catequese', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Digite seu E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _botaoLogin(
                    label: 'Receber Código de Acesso',
                    icon: Icons.send,
                    color: Colors.blue[800]!,
                    onTap: () => _exibirEULA(context),
                  ),
                ] else ...[
                  Text('Código enviado para:\n${_emailController.text}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _codigoController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 8),
                    decoration: const InputDecoration(
                      labelText: 'Código de 6 dígitos',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _botaoLogin(
                    label: 'Validar e Entrar',
                    icon: Icons.check_circle,
                    color: Colors.green[700]!,
                    onTap: _validarCodigo,
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _codigoEnviado = false;
                      _codigoController.clear();
                    }),
                    child: const Text('Alterar E-mail / Reenviar Código'),
                  )
                ],

                const SizedBox(height: 30),
                if (!_codigoEnviado)
                  TextButton(
                    onPressed: () => setState(() => _isInternal = true),
                    child: const Text('Sou Catequista / Admin', style: TextStyle(color: Colors.grey)),
                  )
              ] else ...[
                // --- FORMULÁRIO PARA CATEQUISTAS/ADMIN ---
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                _botaoLogin(
                  label: 'Entrar no Sistema',
                  icon: Icons.admin_panel_settings,
                  color: const Color(0xFF0D47A1),
                  onTap: _loginInterno,
                ),
                TextButton(
                  onPressed: () => setState(() => _isInternal = false),
                  child: const Text('Acesso para Pais (E-mail)'),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoLogin({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  // Variáveis de Controle de Filtros e Busca
  bool _isSearching = false;
  String _buscaText = '';
  final TextEditingController _searchController = TextEditingController();
  
  String _filtroRole = 'todos'; // todos, admin, superuser, user
  String _ordenacao = 'nome_az'; // nome_az, nome_za, data_recente, data_antigo

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() => _isLoading = true);
    try {
      final users = await ApiService.getUsers();
      setState(() => _users = users);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao carregar usuários')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- LÓGICA DE FILTRAGEM E ORDENAÇÃO ---
  List<dynamic> _filtrarEOrdenarUsuarios() {
    // 1. Filtrar por Busca e Role
    List<dynamic> filtrados = _users.where((user) {
      final nome = (user['nome'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final bateBusca = nome.contains(_buscaText.toLowerCase()) || email.contains(_buscaText.toLowerCase());
      
      final bateRole = _filtroRole == 'todos' || user['role'] == _filtroRole;

      return bateBusca && bateRole;
    }).toList();

    // 2. Ordenar
    switch (_ordenacao) {
      case 'nome_az':
        filtrados.sort((a, b) => (a['nome'] ?? '').toLowerCase().compareTo((b['nome'] ?? '').toLowerCase()));
        break;
      case 'nome_za':
        filtrados.sort((a, b) => (b['nome'] ?? '').toLowerCase().compareTo((a['nome'] ?? '').toLowerCase()));
        break;
      case 'data_recente':
        filtrados.sort((a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));
        break;
      case 'data_antigo':
        filtrados.sort((a, b) => (a['createdAt'] ?? '').compareTo(b['createdAt'] ?? ''));
        break;
    }
    return filtrados;
  }

  // --- MÉTODOS DE CRUD (MANTIDOS) ---
  Future<void> _deletarUsuario(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Usuário?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteUser(id);
        _carregarUsuarios();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao excluir')));
      }
    }
  }

  void _abrirFormularioUsuario({Map<String, dynamic>? user}) {
    final isEditing = user != null;
    final nomeCtrl = TextEditingController(text: user?['nome'] ?? '');
    final emailCtrl = TextEditingController(text: user?['email'] ?? '');
    final usernameCtrl = TextEditingController(text: user?['username'] ?? '');
    final passwordCtrl = TextEditingController();
    String roleSelecionado = user?['role'] ?? 'user';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEditing ? 'Editar Usuário' : 'Novo Usuário'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'E-mail')),
                  TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Username (Admin/SuperUser)')),
                  TextField(
                    controller: passwordCtrl, 
                    decoration: InputDecoration(labelText: isEditing ? 'Nova Senha (deixe em branco para manter)' : 'Senha'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: roleSelecionado,
                    decoration: const InputDecoration(labelText: 'Nível de Acesso'),
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('Usuário Comum (Pai/Mãe)')),
                      DropdownMenuItem(value: 'superuser', child: Text('Catequista (SuperUser)')),
                      DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                    ],
                    onChanged: (val) => setDialogState(() => roleSelecionado = val!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () async {
                  final dados = {
                    'nome': nomeCtrl.text,
                    'email': emailCtrl.text,
                    'username': usernameCtrl.text,
                    'role': roleSelecionado,
                  };
                  if (passwordCtrl.text.isNotEmpty) dados['password'] = passwordCtrl.text;

                  try {
                    if (isEditing) {
                      await ApiService.updateUser(user['_id'], dados);
                    } else {
                      await ApiService.createUser(dados);
                    }
                    Navigator.pop(context);
                    _carregarUsuarios();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listagem = _filtrarEOrdenarUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Buscar usuário...', border: InputBorder.none),
              onChanged: (v) => setState(() => _buscaText = v),
            )
          : const Text('Gerenciar Usuários'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _buscaText = '';
                _searchController.clear();
              }
            }),
          ),
          // Botão de Filtro por Role
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (val) => setState(() => _filtroRole = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos os Perfis')),
              const PopupMenuItem(value: 'admin', child: Text('Apenas Admins')),
              const PopupMenuItem(value: 'superuser', child: Text('Apenas Catequistas')),
              const PopupMenuItem(value: 'user', child: Text('Apenas Pais/Mães')),
            ],
          ),
          // Botão de Ordenação
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_by_alpha),
            onSelected: (val) => setState(() => _ordenacao = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'nome_az', child: Text('A - Z')),
              const PopupMenuItem(value: 'nome_za', child: Text('Z - A')),
              const PopupMenuItem(value: 'data_recente', child: Text('Mais Recentes')),
              const PopupMenuItem(value: 'data_antigo', child: Text('Mais Antigos')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : listagem.isEmpty
              ? const Center(child: Text("Nenhum usuário encontrado."))
              : ListView.builder(
                  itemCount: listagem.length,
                  itemBuilder: (context, index) {
                    final user = listagem[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user['role'] == 'admin' ? Colors.red : (user['role'] == 'superuser' ? Colors.blue : Colors.grey),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(user['nome'] ?? 'Sem nome'),
                      subtitle: Text("${user['email']}\nPerfil: ${user['role'].toUpperCase()}"),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormularioUsuario(user: user)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deletarUsuario(user['_id'])),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioUsuario(),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
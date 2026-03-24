import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // --- VARIÁVEIS DE PAGINAÇÃO ---
  List<dynamic> _users = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  // --- VARIÁVEIS DE CONTROLE DE FILTROS E BUSCA ---
  bool _isSearching = false;
  String _buscaText = '';
  final TextEditingController _searchController = TextEditingController();
  
  String _filtroRole = 'todos'; // todos, admin, superuser, user
  String _filtroStatus = 'todos'; // todos, ativos, inativos
  String _ordenacao = 'nome_az'; // nome_az, nome_za, data_recente, data_antigo

  @override
  void initState() {
    super.initState();
    _carregarUsuarios(isRefresh: true);

    // Listener para o Scroll Infinito
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore && _hasMore) {
        _carregarMaisUsuarios();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE BUSCA (COM PAGINAÇÃO) ---
  Future<void> _carregarUsuarios({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() { _isLoading = true; _currentPage = 1; _hasMore = true; _users.clear(); });
    }
    try {
      final novosUsers = await ApiService.getUsers(page: _currentPage, limit: 10);
      setState(() {
        if (novosUsers.length < 10) _hasMore = false; // Acabou a lista
        _users.addAll(novosUsers);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao carregar usuários')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _carregarMaisUsuarios() async {
    setState(() => _isLoadingMore = true);
    _currentPage++;
    await _carregarUsuarios();
    setState(() => _isLoadingMore = false);
  }

  // --- LÓGICA DE FILTRAGEM E ORDENAÇÃO ---
  List<dynamic> _filtrarEOrdenarUsuarios() {
    // 1. Filtrar
    List<dynamic> filtrados = _users.where((user) {
      final nome = (user['nome'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final bateBusca = nome.contains(_buscaText.toLowerCase()) || email.contains(_buscaText.toLowerCase());
      
      final bateRole = _filtroRole == 'todos' || user['role'] == _filtroRole;

      bool isActive = user['isAtivo'] ?? true; // Se não tiver o campo, assume true
      final bateStatus = _filtroStatus == 'todos' || 
                         (_filtroStatus == 'ativos' && isActive) || 
                         (_filtroStatus == 'inativos' && !isActive);

      return bateBusca && bateRole && bateStatus;
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

  // --- MÉTODOS DE CRUD ---
  Future<void> _deletarUsuario(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Usuário permanentemente?'),
        content: const Text('Esta ação não pode ser desfeita. Para apenas suspender o acesso, use a opção "Inativar" editando o usuário.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteUser(id);
        _carregarUsuarios(isRefresh: true);
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
    bool isActiveSelecionado = user?['isAtivo'] ?? true;

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
                    decoration: InputDecoration(labelText: isEditing ? 'Nova Senha (vazio mantém)' : 'Senha'),
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
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Conta Ativa'),
                    subtitle: Text(isActiveSelecionado ? 'O usuário pode logar' : 'Acesso bloqueado', style: TextStyle(color: isActiveSelecionado ? Colors.green : Colors.red)),
                    value: isActiveSelecionado,
                    onChanged: (val) => setDialogState(() => isActiveSelecionado = val),
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
                    'isAtivo': isActiveSelecionado, // Envia o novo status
                  };
                  if (passwordCtrl.text.isNotEmpty) dados['password'] = passwordCtrl.text;

                  try {
                    if (isEditing) {
                      await ApiService.updateUser(user['_id'], dados);
                    } else {
                      await ApiService.createUser(dados);
                    }
                    Navigator.pop(context);
                    _carregarUsuarios(isRefresh: true);
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
          // --- BOTÃO DE REFRESH ADICIONADO AQUI ---
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Usuários',
            onPressed: () => _carregarUsuarios(isRefresh: true),
          ),
          // ----------------------------------------
          // Botão de Filtro por Status (Ativo/Inativo)
          PopupMenuButton<String>(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Filtrar por Status',
            onSelected: (val) => setState(() => _filtroStatus = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos os Status')),
              const PopupMenuItem(value: 'ativos', child: Text('Somente Ativos', style: TextStyle(color: Colors.green))),
              const PopupMenuItem(value: 'inativos', child: Text('Somente Inativos', style: TextStyle(color: Colors.red))),
            ],
          ),
          // Botão de Filtro por Role
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Nível',
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
            tooltip: 'Ordenar',
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
      body: RefreshIndicator(
        onRefresh: () => _carregarUsuarios(isRefresh: true),
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : listagem.isEmpty
                ? SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), child: SizedBox(height: MediaQuery.of(context).size.height, child: const Center(child: Text("Nenhum usuário encontrado."))))
                : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: listagem.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == listagem.length) return const Center(child: Padding(padding: EdgeInsets.all(15), child: CircularProgressIndicator()));
                      
                      final user = listagem[index];
                      final bool isAtivo = user['isAtivo'] ?? true;
                      
                      return ListTile(
                        leading: CircleAvatar(
                          // Se estiver inativo, fica escuro para destacar que algo está errado
                          backgroundColor: !isAtivo ? Colors.grey[800] : (user['role'] == 'admin' ? Colors.red : (user['role'] == 'superuser' ? Colors.blue : Colors.grey)),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user['nome'] ?? 'Sem nome', 
                          style: TextStyle(
                            decoration: !isAtivo ? TextDecoration.lineThrough : null, // Risco no nome se inativo
                            color: !isAtivo ? Colors.grey : Colors.black,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(text: "${user['email']}\nPerfil: ${user['role'].toUpperCase()} "),
                              if (!isAtivo) const TextSpan(text: " [INATIVO]", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioUsuario(),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
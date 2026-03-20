import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ficha_model.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'details_screen.dart';
import 'login_screen.dart';
import 'admin_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Ficha> _fichas = [];
  bool _isLoading = true;
  String _userRole = 'user'; 

  // Filtros principais (Para SuperUser e Admin)
  String _statusFiltro = 'ativo'; 
  String _sacramentoFiltro = 'Todos'; 
  String _etapaSelecionada = 'Todas'; 
  String _catequistaSelecionado = 'Todos';
  
  // Nova variável para Ordenação
  String _ordenacao = 'nome_az'; // nome_az, nome_za, recente, antigo

  // Controle de Busca
  bool _isSearching = false;
  String _buscaNome = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarPerfilERecursos();
  }

  Future<void> _carregarPerfilERecursos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? 'user';
      if (_userRole == 'user') _statusFiltro = 'pendente';
    });
    _carregarFichasDaNuvem();
  }

  Future<void> _carregarFichasDaNuvem() async {
    setState(() => _isLoading = true);
    try {
      final fichasDaNuvem = await ApiService.getFichas();
      setState(() => _fichas = fichasDaNuvem);
    } catch (e) {
      debugPrint('Erro ao carregar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _fazerLogout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Color _obterCorStatus(String status) {
    switch (status) {
      case 'ativo': return Colors.green;
      case 'pendente': return Colors.orange;
      case 'arquivado': return Colors.grey;
      case 'arquivado concluído': return Colors.blue;
      default: return Colors.black;
    }
  }

  String _obterStatusPorIndex(int index) {
    const statusMap = ['ativo', 'pendente', 'arquivado', 'arquivado concluído'];
    return statusMap[index];
  }

  void _abrirFiltroCatequista(String sacramento, {String? etapa}) {
    List<String> todosCatequistas = _fichas.where((f) {
      bool isNoSacramento = false;
      if (sacramento == 'Batismo') isNoSacramento = f.inscricaoBatismo;
      else if (sacramento == 'Eucaristia') isNoSacramento = f.inscricaoEucaristia;
      else if (sacramento == 'Crisma') isNoSacramento = f.inscricaoCrisma;
      else if (sacramento == 'Pré-Catequese') isNoSacramento = f.inscricaoPreCatequese;
      if (etapa != null) return isNoSacramento && f.etapa == etapa;
      return isNoSacramento;
    }).map((f) => f.catequistaAtual ?? 'Sem Catequista').toSet().toList();

    showDialog(
      context: context,
      builder: (context) {
        String buscaCat = '';
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<String> filtrados = todosCatequistas
                .where((c) => c.toLowerCase().contains(buscaCat.toLowerCase()))
                .toList();
            return AlertDialog(
              title: Text(etapa != null ? '$sacramento - Etapa $etapa' : sacramento),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Buscar catequista...', prefixIcon: Icon(Icons.search)),
                      onChanged: (value) => setDialogState(() => buscaCat = value),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtrados.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filtrados[index]),
                            onTap: () {
                              setState(() {
                                _sacramentoFiltro = sacramento;
                                _etapaSelecionada = etapa ?? 'Todas';
                                _catequistaSelecionado = filtrados[index];
                                _isSearching = false;
                              });
                              Navigator.pop(context); Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() { _sacramentoFiltro = sacramento; _etapaSelecionada = etapa ?? 'Todas'; _catequistaSelecionado = 'Todos'; });
                    Navigator.pop(context); Navigator.pop(context);
                  },
                  child: const Text('Ver Todos'),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- LÓGICA DE FILTRAGEM ---
    final List<Ficha> fichasFiltradas = _fichas.where((ficha) {
      bool bateBusca = ficha.nome.toLowerCase().contains(_buscaNome.toLowerCase());
      if (_userRole == 'user') return bateBusca;

      bool bateStatus = ficha.status == _statusFiltro;
      bool bateSacramento = true;
      if (_sacramentoFiltro == 'Batismo') bateSacramento = ficha.inscricaoBatismo;
      else if (_sacramentoFiltro == 'Crisma') bateSacramento = ficha.inscricaoCrisma;
      else if (_sacramentoFiltro == 'Pré-Catequese') bateSacramento = ficha.inscricaoPreCatequese;
      else if (_sacramentoFiltro == 'Eucaristia') bateSacramento = ficha.inscricaoEucaristia;

      if (_sacramentoFiltro != 'Todos') {
        if (_etapaSelecionada != 'Todas' && ficha.etapa != _etapaSelecionada) bateSacramento = false;
        if (_catequistaSelecionado != 'Todos' && ficha.catequistaAtual != _catequistaSelecionado) bateSacramento = false;
      }
      return bateStatus && bateSacramento && bateBusca;
    }).toList();

    // --- LÓGICA DE ORDENAÇÃO ---
    switch (_ordenacao) {
      case 'nome_az':
        fichasFiltradas.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        break;
      case 'nome_za':
        fichasFiltradas.sort((a, b) => b.nome.toLowerCase().compareTo(a.nome.toLowerCase()));
        break;
      case 'recente':
        // Como o ID do MongoDB contém a data, podemos usar o ID como proxy se não tivermos a data formatada
        fichasFiltradas.sort((a, b) => (b.id ?? "").compareTo(a.id ?? ""));
        break;
      case 'antigo':
        fichasFiltradas.sort((a, b) => (a.id ?? "").compareTo(b.id ?? ""));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Pesquisar nome...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black54),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 18),
              onChanged: (value) => setState(() => _buscaNome = value),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_userRole == 'user' ? 'Minha Ficha' : (_sacramentoFiltro == 'Todos' ? 'Catequese' : _sacramentoFiltro)),
                if (_userRole != 'user' && _sacramentoFiltro != 'Todos' && (_etapaSelecionada != 'Todas' || _catequistaSelecionado != 'Todos'))
                  Text(
                    '${_etapaSelecionada != "Todas" ? "Etapa $_etapaSelecionada • " : ""}$_catequistaSelecionado',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
              ],
            ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _buscaNome = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Botão de Ordenação (Apenas para SuperUser/Admin)
          if (_userRole != 'user')
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_by_alpha),
              onSelected: (val) => setState(() => _ordenacao = val),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'nome_az', child: Text('A - Z')),
                const PopupMenuItem(value: 'nome_za', child: Text('Z - A')),
                const PopupMenuItem(value: 'recente', child: Text('Mais Recentes')),
                const PopupMenuItem(value: 'antigo', child: Text('Mais Antigos')),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _fazerLogout,
            tooltip: 'Sair',
          ),
        ],
      ),

      drawer: _userRole == 'user' ? null : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 10),
                  Text("Acesso: ${_userRole.toUpperCase()}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Todas as Fichas'),
              onTap: () {
                setState(() { _sacramentoFiltro = 'Todos'; _etapaSelecionada = 'Todas'; _catequistaSelecionado = 'Todos'; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.child_friendly),
              title: const Text('Pré-Catequese'),
              onTap: () => _abrirFiltroCatequista('Pré-Catequese'),
            ),
            ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text('Batismo'),
              onTap: () => _abrirFiltroCatequista('Batismo'),
            ),
            ExpansionTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Eucaristia'),
              children: [
                ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 1'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '1')),
                ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 2'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '2')),
                ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 3'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '3')),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Crisma'),
              onTap: () => _abrirFiltroCatequista('Crisma'),
            ),
            if (_userRole == 'admin') ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
                title: const Text('Gerenciar Usuários'),
                onTap: () { 
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminScreen()),
                  );
                },
              ),
            ]
          ],
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fichas.isEmpty 
            ? const Center(child: Text("Nenhuma ficha cadastrada."))
            : ListView.builder(
              itemCount: fichasFiltradas.length,
              itemBuilder: (context, index) {
                final ficha = fichasFiltradas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: _obterCorStatus(ficha.status), width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _obterCorStatus(ficha.status),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(ficha.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${ficha.etapa != '0' ? 'Nível ${ficha.etapa} • ' : ''}${ficha.catequistaAtual ?? 'Sem catequista'}"),
                    onTap: () async {
                      final refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsScreen(ficha: ficha)),
                      );
                      if (refresh == true) _carregarFichasDaNuvem();
                    },
                  ),
                );
              },
            ),

      bottomNavigationBar: _userRole == 'user' ? null : BottomNavigationBar(
        currentIndex: _statusFiltro == 'ativo' ? 0 : _statusFiltro == 'pendente' ? 1 : _statusFiltro == 'arquivado' ? 2 : 3,
        onTap: (index) => setState(() => _statusFiltro = _obterStatusPorIndex(index)),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _obterCorStatus(_statusFiltro),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Ativos'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Pendentes'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Arquivado'),
          BottomNavigationBarItem(icon: Icon(Icons.verified), label: 'Concluído'),
        ],
      ),

      floatingActionButton: (_userRole == 'user' && _fichas.isNotEmpty) 
          ? null 
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const FormScreen()));
                _carregarFichasDaNuvem();
              },
              backgroundColor: Colors.blue[900],
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
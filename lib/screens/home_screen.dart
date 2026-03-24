import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ficha_model.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'details_screen.dart';
import 'login_screen.dart';
import 'admin_screen.dart'; 
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Ficha> _fichas = [];
  bool _isLoading = true;
  String _userRole = 'user'; 
  String _userName = 'Carregando...';

  String _statusFiltro = 'ativo'; 
  String _sacramentoFiltro = 'Todos'; 
  String _etapaSelecionada = 'Todas'; 
  String _catequistaSelecionado = 'Todos';
  String _ordenacao = 'nome_az'; 

  bool _isSearching = false;
  String _buscaNome = '';
  final TextEditingController _searchController = TextEditingController();

  // LISTA DINÂMICA DE STATUS (Mostra inativo apenas para Admin)
  List<String> get _listaDeStatusPermitidos {
    if (_userRole == 'admin') {
      return ['ativo', 'pendente', 'arquivado', 'arquivado concluído', 'inativo'];
    }
    return ['ativo', 'pendente', 'arquivado', 'arquivado concluído'];
  }

  @override
  void initState() {
    super.initState();
    _carregarPerfilERecursos();
  }

  Future<void> _carregarPerfilERecursos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? 'user';
      _userName = prefs.getString('userName') ?? 'Usuário';
      if (_userRole == 'user') _statusFiltro = 'pendente';
    });
    _carregarFichasDaNuvem();
  }

  Future<void> _carregarFichasDaNuvem() async {
    setState(() => _isLoading = true);
    try {
      // Se for Admin, avisa a API para trazer as fichas inativas também
      final fichasDaNuvem = await ApiService.getFichas(incluirInativos: _userRole == 'admin');
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    }
  }

  Color _obterCorStatus(String status) {
    switch (status) {
      case 'ativo': return Colors.green;
      case 'pendente': return Colors.orange;
      case 'arquivado': return Colors.grey;
      case 'arquivado concluído': return Colors.blue;
      case 'inativo': return Colors.red;
      default: return Colors.black;
    }
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
            List<String> filtrados = todosCatequistas.where((c) => c.toLowerCase().contains(buscaCat.toLowerCase())).toList();
            return AlertDialog(
              title: Text(etapa != null ? '$sacramento - Etapa $etapa' : sacramento),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(decoration: const InputDecoration(hintText: 'Buscar catequista...', prefixIcon: Icon(Icons.search)), onChanged: (value) => setDialogState(() => buscaCat = value)),
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
    // --- LÓGICA DE FILTRAGEM ATUALIZADA ---
    final List<Ficha> fichasFiltradas = _fichas.where((ficha) {
      bool bateBusca = ficha.nome.toLowerCase().contains(_buscaNome.toLowerCase());
      
      // Se for usuário comum (pais), só vê o que for dele e o que estiver ativo
      if (_userRole == 'user') return bateBusca && ficha.isAtivo;

      bool bateStatus = false;
      if (_statusFiltro == 'inativo') {
        bateStatus = !ficha.isAtivo; // Se quer inativos, pega isAtivo == false
      } else {
        bateStatus = ficha.status == _statusFiltro && ficha.isAtivo; // Se quer o resto, pega isAtivo == true
      }

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
      case 'nome_az': fichasFiltradas.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase())); break;
      case 'nome_za': fichasFiltradas.sort((a, b) => b.nome.toLowerCase().compareTo(a.nome.toLowerCase())); break;
      case 'recente': fichasFiltradas.sort((a, b) => (b.id ?? "").compareTo(a.id ?? "")); break;
      case 'antigo': fichasFiltradas.sort((a, b) => (a.id ?? "").compareTo(b.id ?? "")); break;
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Pesquisar nome...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.black54)),
              style: const TextStyle(color: Colors.black, fontSize: 18),
              onChanged: (value) => setState(() => _buscaNome = value),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_userRole == 'user' ? 'Minha Ficha' : (_sacramentoFiltro == 'Todos' ? 'Catequese' : _sacramentoFiltro)),
                if (_userRole != 'user' && _sacramentoFiltro != 'Todos' && (_etapaSelecionada != 'Todas' || _catequistaSelecionado != 'Todos'))
                  Text('${_etapaSelecionada != "Todas" ? "Etapa $_etapaSelecionada • " : ""}$_catequistaSelecionado', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
              ],
            ),
        actions: [
          // --- BOTÃO DE REFRESH ---
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Lista',
            onPressed: _carregarFichasDaNuvem,
          ),
          // ----------------------------------------
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) { _buscaNome = ''; _searchController.clear(); }
            }),
          ),
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
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                Navigator.pop(context); 
                final atualizou = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                if (atualizou == true) _carregarPerfilERecursos();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                color: const Color(0xFF1550A6),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(backgroundColor: Colors.white, radius: 30, child: Icon(Icons.person, color: Color(0xFF1550A6), size: 40)),
                        const SizedBox(height: 15),
                        Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    const Positioned(top: 0, right: 0, child: Icon(Icons.settings_outlined, color: Colors.white, size: 28)),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (_userRole != 'user') ...[
                    ListTile(leading: const Icon(Icons.dashboard), title: const Text('Todas as Fichas'), onTap: () { setState(() { _sacramentoFiltro = 'Todos'; _etapaSelecionada = 'Todas'; _catequistaSelecionado = 'Todos'; }); Navigator.pop(context); }),
                    ListTile(leading: const Icon(Icons.child_friendly), title: const Text('Pré-Catequese'), onTap: () => _abrirFiltroCatequista('Pré-Catequese')),
                    ListTile(leading: const Icon(Icons.water_drop), title: const Text('Batismo'), onTap: () => _abrirFiltroCatequista('Batismo')),
                    ExpansionTile(
                      leading: const Icon(Icons.restaurant_menu), title: const Text('Eucaristia'),
                      children: [
                        ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 1'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '1')),
                        ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 2'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '2')),
                        ListTile(contentPadding: const EdgeInsets.only(left: 40), title: const Text('Etapa 3'), onTap: () => _abrirFiltroCatequista('Eucaristia', etapa: '3')),
                      ],
                    ),
                    ListTile(leading: const Icon(Icons.local_fire_department), title: const Text('Crisma'), onTap: () => _abrirFiltroCatequista('Crisma')),
                    if (_userRole == 'admin') ...[
                      const Divider(),
                      ListTile(leading: const Icon(Icons.admin_panel_settings, color: Colors.red), title: const Text('Gerenciar Usuários'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen())); }),
                    ]
                  ] else ...[
                    const Padding(padding: EdgeInsets.all(20.0), child: Text('Bem-vindo ao app da catequese. Use o botão + para criar a ficha e o menu superior azul para editar seu perfil.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)))
                  ]
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Sair do Aplicativo', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), onTap: _fazerLogout),
            const SizedBox(height: 10),
          ],
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fichas.isEmpty 
            ? const Center(child: Text("Nenhuma ficha encontrada."))
            : ListView.builder(
              itemCount: fichasFiltradas.length,
              itemBuilder: (context, index) {
                final ficha = fichasFiltradas[index];
                final corStatus = _obterCorStatus(!ficha.isAtivo ? 'inativo' : ficha.status);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(side: BorderSide(color: corStatus, width: 1.5), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: corStatus, child: const Icon(Icons.person, color: Colors.white)),
                    title: Text(
                      ficha.nome, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: !ficha.isAtivo ? TextDecoration.lineThrough : null, // Risca o nome se inativo
                        color: !ficha.isAtivo ? Colors.grey : Colors.black,
                      )
                    ),
                    subtitle: Text("${ficha.etapa != '0' ? 'Nível ${ficha.etapa} • ' : ''}${ficha.catequistaAtual ?? 'Sem catequista'}"),
                    onTap: () async {
                      final refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(ficha: ficha)));
                      if (refresh == true) _carregarFichasDaNuvem();
                    },
                  ),
                );
              },
            ),

      // --- BARRA INFERIOR DINÂMICA ---
      bottomNavigationBar: _userRole == 'user' ? null : BottomNavigationBar(
        currentIndex: _listaDeStatusPermitidos.indexOf(_statusFiltro) == -1 ? 0 : _listaDeStatusPermitidos.indexOf(_statusFiltro),
        onTap: (index) => setState(() => _statusFiltro = _listaDeStatusPermitidos[index]),
        type: BottomNavigationBarType.fixed, // Fixed obriga os textos a aparecerem
        selectedItemColor: _obterCorStatus(_statusFiltro),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Ativos'),
          const BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Pendentes'),
          const BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Arquivado'),
          const BottomNavigationBarItem(icon: Icon(Icons.verified), label: 'Concluído'),
          // 5º BOTÃO: APENAS ADMIN
          if (_userRole == 'admin')
            const BottomNavigationBarItem(icon: Icon(Icons.block), label: 'Inativas'),
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
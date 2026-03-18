import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'form_screen.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase database;

  const HomeScreen({super.key, required this.database});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variáveis de controle de estado
  String _searchQuery = '';
  String _sortOrder = 'RECANTE'; // 'RECANTE', 'AZ', 'ZA'
  int _limit = 15; // Quantidade inicial que cabe na tela
  
  // Controlador para monitorar a rolagem da lista
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Adiciona o "espião" na rolagem
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Função disparada toda vez que o usuário rola a tela
  void _onScroll() {
    // Se chegou quase no fim da lista atual, pede mais 10 para o banco
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _limit += 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Catequese'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ==========================================
          // BARRA DE PESQUISA E ORDENAÇÃO
          // ==========================================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por nome...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _limit = 15; // Reseta a paginação ao buscar algo novo
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                // Botão de Filtro/Ordenação
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sortOrder,
                      icon: const Icon(Icons.sort),
                      items: const [
                        DropdownMenuItem(value: 'RECANTE', child: Text('Mais Recente')),
                        DropdownMenuItem(value: 'AZ', child: Text('A - Z')),
                        DropdownMenuItem(value: 'ZA', child: Text('Z - A')),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          _sortOrder = newValue!;
                          _limit = 15; // Reseta a paginação ao mudar a ordem
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // ==========================================
          // LISTA COM LAZY LOADING
          // ==========================================
          Expanded(
            child: StreamBuilder<List<Ficha>>(
              // Passamos os filtros para a nossa nova função!
              stream: widget.database.watchFilteredFichas(_searchQuery, _sortOrder, _limit),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
                }

                final fichas = snapshot.data ?? [];

                if (fichas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty 
                            ? 'Nenhum catequizando registrado.' 
                            : 'Nenhum resultado para "$_searchQuery".',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController, // Vincula o nosso "espião" de rolagem
                  itemCount: fichas.length,
                  itemBuilder: (context, index) {
                    final ficha = fichas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            ficha.nome.isNotEmpty ? ficha.nome[0].toUpperCase() : '?',
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                        ),
                        title: Text(ficha.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Paróquia: ${ficha.paroquiaAtual}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(ficha: ficha, database: widget.database),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormScreen(database: widget.database),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Ficha'),
      ),
    );
  }
}
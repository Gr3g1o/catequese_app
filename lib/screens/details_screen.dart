import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NECESSÁRIO PARA LER A ROLE
import '../models/ficha_model.dart';
import '../services/api_service.dart'; 
import 'form_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Ficha ficha;

  const DetailsScreen({super.key, required this.ficha});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Ficha _fichaAtual;
  String _userRole = 'user';

  @override
  void initState() {
    super.initState();
    _fichaAtual = widget.ficha;
    _carregarRole();
  }

  Future<void> _carregarRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? 'user';
    });
  }

  // --- FUNÇÃO PARA MUDAR O STATUS DA FICHA (Arquivar/Pendente/Etc) ---
  Future<void> _mudarStatus(String novoStatus) async {
    final fichaEditada = Ficha(
      id: _fichaAtual.id, nome: _fichaAtual.nome, dataNascimento: _fichaAtual.dataNascimento,
      cidadeNascimento: _fichaAtual.cidadeNascimento, ufNascimento: _fichaAtual.ufNascimento,
      nomePai: _fichaAtual.nomePai, celularPai: _fichaAtual.celularPai, foneFixoPai: _fichaAtual.foneFixoPai,
      nomeMae: _fichaAtual.nomeMae, celularMae: _fichaAtual.celularMae, foneFixoMae: _fichaAtual.foneFixoMae,
      cep: _fichaAtual.cep, rua: _fichaAtual.rua, numero: _fichaAtual.numero, bairro: _fichaAtual.bairro,
      paroquiaAtual: _fichaAtual.paroquiaAtual, catequistaAtual: _fichaAtual.catequistaAtual,
      paisCasados: _fichaAtual.paisCasados, paroquiaCasamento: _fichaAtual.paroquiaCasamento,
      isBatizado: _fichaAtual.isBatizado, dataBatismo: _fichaAtual.dataBatismo, paroquiaBatismo: _fichaAtual.paroquiaBatismo,
      cidadeBatismo: _fichaAtual.cidadeBatismo, ufBatismo: _fichaAtual.ufBatismo, assinaturaBase64: _fichaAtual.assinaturaBase64,
      inscricaoBatismo: _fichaAtual.inscricaoBatismo, inscricaoEucaristia: _fichaAtual.inscricaoEucaristia,
      inscricaoCrisma: _fichaAtual.inscricaoCrisma, inscricaoPreCatequese: _fichaAtual.inscricaoPreCatequese,
      etapa: _fichaAtual.etapa,
      status: novoStatus, // Status alterado
      isAtivo: _fichaAtual.isAtivo,
    );

    bool sucesso = await ApiService.atualizarFicha(fichaEditada);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status alterado para: ${novoStatus.toUpperCase()}')));
      Navigator.pop(context, true); 
    }
  }

  // --- NOVA FUNÇÃO: INATIVAR / REATIVAR FICHA ---
  Future<void> _inativarFicha(bool novoStatusDeAtividade) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(novoStatusDeAtividade ? 'Reativar Ficha?' : 'Inativar Ficha?'),
        content: Text(novoStatusDeAtividade 
          ? 'A ficha voltará a aparecer nas listas normais.' 
          : 'A ficha será ocultada, mas não será excluída do banco de dados.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: Text(novoStatusDeAtividade ? 'Reativar' : 'Inativar', style: TextStyle(color: novoStatusDeAtividade ? Colors.green : Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      final fichaEditada = Ficha(
        id: _fichaAtual.id, nome: _fichaAtual.nome, dataNascimento: _fichaAtual.dataNascimento,
        cidadeNascimento: _fichaAtual.cidadeNascimento, ufNascimento: _fichaAtual.ufNascimento,
        nomePai: _fichaAtual.nomePai, celularPai: _fichaAtual.celularPai, foneFixoPai: _fichaAtual.foneFixoPai,
        nomeMae: _fichaAtual.nomeMae, celularMae: _fichaAtual.celularMae, foneFixoMae: _fichaAtual.foneFixoMae,
        cep: _fichaAtual.cep, rua: _fichaAtual.rua, numero: _fichaAtual.numero, bairro: _fichaAtual.bairro,
        paroquiaAtual: _fichaAtual.paroquiaAtual, catequistaAtual: _fichaAtual.catequistaAtual,
        paisCasados: _fichaAtual.paisCasados, paroquiaCasamento: _fichaAtual.paroquiaCasamento,
        isBatizado: _fichaAtual.isBatizado, dataBatismo: _fichaAtual.dataBatismo, paroquiaBatismo: _fichaAtual.paroquiaBatismo,
        cidadeBatismo: _fichaAtual.cidadeBatismo, ufBatismo: _fichaAtual.ufBatismo, assinaturaBase64: _fichaAtual.assinaturaBase64,
        inscricaoBatismo: _fichaAtual.inscricaoBatismo, inscricaoEucaristia: _fichaAtual.inscricaoEucaristia,
        inscricaoCrisma: _fichaAtual.inscricaoCrisma, inscricaoPreCatequese: _fichaAtual.inscricaoPreCatequese,
        etapa: _fichaAtual.etapa, status: _fichaAtual.status,
        isAtivo: novoStatusDeAtividade, // Alternando o IsAtivo
      );

      bool sucesso = await ApiService.atualizarFicha(fichaEditada);
      if (sucesso && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status de atividade atualizado.')));
        Navigator.pop(context, true); 
      }
    }
  }

  // --- NOVA FUNÇÃO: DELETAR FICHA (Apenas Admin) ---
  Future<void> _deletarFicha() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Ficha Permanentemente?'),
        content: const Text('CUIDADO: Esta ação apagará a ficha do banco de dados e NÃO PODE SER DESFEITA.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('EXCLUIR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm == true) {
      if (_fichaAtual.id != null) {
        bool sucesso = await ApiService.deletarFicha(_fichaAtual.id!);
        if (sucesso && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ficha apagada definitivamente.')));
          Navigator.pop(context, true);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao apagar ficha.'), backgroundColor: Colors.red));
        }
      }
    }
  }

  // --- FUNÇÕES DE AUXÍLIO VISUAL ---
  String _traduzirEtapa(String? etapa) {
    switch (etapa) {
      case '0': return 'Não se aplica';
      case '1': return 'Primeira Etapa';
      case '2': return 'Segunda Etapa';
      case '3': return 'Terceira Etapa';
      case '4': return 'Crisma';
      default: return 'Não definida';
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

  Future<void> _imprimirFicha() async {
    final pdf = pw.Document();
    // [COLE A SUA LÓGICA DE PDF AQUI DENTRO MANTENDO COMO ESTAVA ANTES]
    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Center(child: pw.Text('Ficha de ${_fichaAtual.nome}'))));
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: '${_fichaAtual.nome}.pdf');
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text((value == null || value.isEmpty) ? 'Não informado' : value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> sacramentos = [];
    if (_fichaAtual.inscricaoBatismo) sacramentos.add('Batismo');
    if (_fichaAtual.inscricaoEucaristia) sacramentos.add('Eucaristia');
    if (_fichaAtual.inscricaoCrisma) sacramentos.add('Crisma');
    if (_fichaAtual.inscricaoPreCatequese) sacramentos.add('Pré-Catequese');
    String sacramentosStr = sacramentos.isEmpty ? 'Nenhum' : sacramentos.join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Ficha'),
        actions: [
          IconButton(icon: const Icon(Icons.print), tooltip: 'Imprimir', onPressed: _imprimirFicha),
          
          // --- MOSTRA O BOTÃO DE STATUS APENAS SE NÃO FOR 'USER' ---
          if (_userRole != 'user')
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              tooltip: 'Mudar Status',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(padding: EdgeInsets.all(16.0), child: Text('Mover Ficha para:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                      ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: const Text('Ativo'), onTap: () => _mudarStatus('ativo')),
                      ListTile(leading: const Icon(Icons.pending, color: Colors.orange), title: const Text('Pendente'), onTap: () => _mudarStatus('pendente')),
                      ListTile(leading: const Icon(Icons.history, color: Colors.grey), title: const Text('Arquivar (Interrompido)'), onTap: () => _mudarStatus('arquivado')),
                      ListTile(leading: const Icon(Icons.verified, color: Colors.blue), title: const Text('Arquivar como Concluído'), onTap: () => _mudarStatus('arquivado concluído')),
                    ],
                  ),
                );
              },
            ),
          
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Ficha',
            onPressed: () async {
              final precisaRecarregar = await Navigator.push(context, MaterialPageRoute(builder: (context) => FormScreen(initialFicha: _fichaAtual)));
              if (precisaRecarregar == true && mounted) Navigator.pop(context, true); 
            },
          ),

          // --- BOTÃO DE INATIVAR (PROIBIDO) PARA ADMIN E SUPERUSER ---
          if (_userRole != 'user')
            IconButton(
              icon: Icon(_fichaAtual.isAtivo ? Icons.block : Icons.restore, color: _fichaAtual.isAtivo ? Colors.orange : Colors.green),
              tooltip: _fichaAtual.isAtivo ? 'Inativar Ficha' : 'Reativar Ficha',
              onPressed: () => _inativarFicha(!_fichaAtual.isAtivo),
            ),

          // --- BOTÃO DE DELETAR PERMANENTEMENTE (APENAS ADMIN) ---
          if (_userRole == 'admin')
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              tooltip: 'Excluir Ficha',
              onPressed: _deletarFicha,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARTÃO DE STATUS E INATIVIDADE
            Card(
              color: !_fichaAtual.isAtivo ? Colors.red.withOpacity(0.1) : _obterCorStatus(_fichaAtual.status).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: !_fichaAtual.isAtivo ? Colors.red : _obterCorStatus(_fichaAtual.status), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(!_fichaAtual.isAtivo ? Icons.warning : Icons.info_outline, color: !_fichaAtual.isAtivo ? Colors.red : _obterCorStatus(_fichaAtual.status)),
                    const SizedBox(width: 10),
                    Text(
                      !_fichaAtual.isAtivo ? 'STATUS: INATIVO' : 'STATUS: ${_fichaAtual.status.toUpperCase()}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: !_fichaAtual.isAtivo ? Colors.red : _obterCorStatus(_fichaAtual.status)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ... OS OUTROS CARDS CONTINUAM EXATAMENTE IGUAIS ...
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Inscrição', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), _buildInfoRow('Sacramentos', sacramentosStr), _buildInfoRow('Etapa', _traduzirEtapa(_fichaAtual.etapa))]))),
            const SizedBox(height: 10),
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Catequizando', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), _buildInfoRow('Nome', _fichaAtual.nome), _buildInfoRow('Nascimento', _fichaAtual.dataNascimento), _buildInfoRow('Cidade/UF Natal', '${_fichaAtual.cidadeNascimento ?? ''} / ${_fichaAtual.ufNascimento ?? ''}')]))),
            const SizedBox(height: 10),
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Família e Contato', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), _buildInfoRow('Nome do Pai', _fichaAtual.nomePai), Row(children: [Expanded(child: _buildInfoRow('Celular', _fichaAtual.celularPai)), Expanded(child: _buildInfoRow('Fixo', _fichaAtual.foneFixoPai))]), const SizedBox(height: 10), _buildInfoRow('Nome da Mãe', _fichaAtual.nomeMae), Row(children: [Expanded(child: _buildInfoRow('Celular', _fichaAtual.celularMae)), Expanded(child: _buildInfoRow('Fixo', _fichaAtual.foneFixoMae))])]))),
            const SizedBox(height: 10),
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Endereço', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), _buildInfoRow('CEP', _fichaAtual.cep), _buildInfoRow('Rua', _fichaAtual.rua), Row(children: [Expanded(flex: 2, child: _buildInfoRow('Número', _fichaAtual.numero)), Expanded(flex: 3, child: _buildInfoRow('Bairro', _fichaAtual.bairro))])]))),
            const SizedBox(height: 10),
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Vida Cristã', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), _buildInfoRow('Paróquia Atual', _fichaAtual.paroquiaAtual), _buildInfoRow('Catequista', _fichaAtual.catequistaAtual), const SizedBox(height: 10), _buildInfoRow('Pais casados na Igreja?', _fichaAtual.paisCasados), _buildInfoRow('Paróquia do Casamento', _fichaAtual.paroquiaCasamento), const SizedBox(height: 10), _buildInfoRow('É Batizado?', _fichaAtual.isBatizado), _buildInfoRow('Data do Batismo', _fichaAtual.dataBatismo), _buildInfoRow('Paróquia do Batismo', _fichaAtual.paroquiaBatismo), _buildInfoRow('Cidade/UF Batismo', '${_fichaAtual.cidadeBatismo ?? ''} / ${_fichaAtual.ufBatismo ?? ''}')]))),
            const SizedBox(height: 10),
            Card(elevation: 3, child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [const Text('Assinatura do Responsável', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)), const Divider(), const SizedBox(height: 10), if (_fichaAtual.assinaturaBase64 != null && _fichaAtual.assinaturaBase64!.isNotEmpty) Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey)), child: Image.memory(base64Decode(_fichaAtual.assinaturaBase64!), height: 100, fit: BoxFit.contain)) else const Text('Nenhuma assinatura registrada.', style: TextStyle(fontStyle: FontStyle.italic))]))),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NECESSÁRIO PARA LER A ROLE
import '../models/ficha_model.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

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
      id: _fichaAtual.id, nome: _fichaAtual.nome,
      dataNascimento: _fichaAtual.dataNascimento,
      cidadeNascimento: _fichaAtual.cidadeNascimento,
      ufNascimento: _fichaAtual.ufNascimento,
      nomePai: _fichaAtual.nomePai, celularPai: _fichaAtual.celularPai,
      foneFixoPai: _fichaAtual.foneFixoPai,
      nomeMae: _fichaAtual.nomeMae, celularMae: _fichaAtual.celularMae,
      foneFixoMae: _fichaAtual.foneFixoMae,
      cep: _fichaAtual.cep, rua: _fichaAtual.rua, numero: _fichaAtual.numero,
      bairro: _fichaAtual.bairro,
      paroquiaAtual: _fichaAtual.paroquiaAtual,
      catequistaAtual: _fichaAtual.catequistaAtual,
      paisCasados: _fichaAtual.paisCasados,
      paroquiaCasamento: _fichaAtual.paroquiaCasamento,
      isBatizado: _fichaAtual.isBatizado, dataBatismo: _fichaAtual.dataBatismo,
      paroquiaBatismo: _fichaAtual.paroquiaBatismo,
      cidadeBatismo: _fichaAtual.cidadeBatismo,
      ufBatismo: _fichaAtual.ufBatismo,
      assinaturaBase64: _fichaAtual.assinaturaBase64,
      inscricaoBatismo: _fichaAtual.inscricaoBatismo,
      inscricaoEucaristia: _fichaAtual.inscricaoEucaristia,
      inscricaoCrisma: _fichaAtual.inscricaoCrisma,
      inscricaoPreCatequese: _fichaAtual.inscricaoPreCatequese,
      inscricaoNoivos: _fichaAtual.inscricaoNoivos,
      inscricaoAdultos: _fichaAtual.inscricaoAdultos,
      etapa: _fichaAtual.etapa,
      status: novoStatus, // Status alterado
      isAtivo: _fichaAtual.isAtivo,
    );

    bool sucesso = await ApiService.atualizarFicha(fichaEditada);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status alterado para: ${novoStatus.toUpperCase()}')));
      Navigator.pop(context, true);
    }
  }

  // --- NOVA FUNÇÃO: INATIVAR / REATIVAR FICHA ---
  Future<void> _inativarFicha(bool novoStatusDeAtividade) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(novoStatusDeAtividade ? 'Reativar Ficha?' : 'Inativar Ficha?'),
        content: Text(novoStatusDeAtividade
            ? 'A ficha voltará a aparecer nas listas normais.'
            : 'A ficha será ocultada, mas não será excluída do banco de dados.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(novoStatusDeAtividade ? 'Reativar' : 'Inativar',
                  style: TextStyle(
                      color:
                          novoStatusDeAtividade ? Colors.green : Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final fichaEditada = Ficha(
        id: _fichaAtual.id, nome: _fichaAtual.nome,
        dataNascimento: _fichaAtual.dataNascimento,
        cidadeNascimento: _fichaAtual.cidadeNascimento,
        ufNascimento: _fichaAtual.ufNascimento,
        nomePai: _fichaAtual.nomePai, celularPai: _fichaAtual.celularPai,
        foneFixoPai: _fichaAtual.foneFixoPai,
        nomeMae: _fichaAtual.nomeMae, celularMae: _fichaAtual.celularMae,
        foneFixoMae: _fichaAtual.foneFixoMae,
        cep: _fichaAtual.cep, rua: _fichaAtual.rua, numero: _fichaAtual.numero,
        bairro: _fichaAtual.bairro,
        paroquiaAtual: _fichaAtual.paroquiaAtual,
        catequistaAtual: _fichaAtual.catequistaAtual,
        paisCasados: _fichaAtual.paisCasados,
        paroquiaCasamento: _fichaAtual.paroquiaCasamento,
        isBatizado: _fichaAtual.isBatizado,
        dataBatismo: _fichaAtual.dataBatismo,
        paroquiaBatismo: _fichaAtual.paroquiaBatismo,
        cidadeBatismo: _fichaAtual.cidadeBatismo,
        ufBatismo: _fichaAtual.ufBatismo,
        assinaturaBase64: _fichaAtual.assinaturaBase64,
        inscricaoBatismo: _fichaAtual.inscricaoBatismo,
        inscricaoEucaristia: _fichaAtual.inscricaoEucaristia,
        inscricaoCrisma: _fichaAtual.inscricaoCrisma,
        inscricaoPreCatequese: _fichaAtual.inscricaoPreCatequese,
        inscricaoNoivos: _fichaAtual.inscricaoNoivos,
        inscricaoAdultos: _fichaAtual.inscricaoAdultos,
        etapa: _fichaAtual.etapa, status: _fichaAtual.status,
        isAtivo: novoStatusDeAtividade, // Alternando o IsAtivo
      );

      bool sucesso = await ApiService.atualizarFicha(fichaEditada);
      if (sucesso && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status de atividade atualizado.')));
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
        content: const Text(
            'CUIDADO: Esta ação apagará a ficha do banco de dados e NÃO PODE SER DESFEITA.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('EXCLUIR',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm == true) {
      if (_fichaAtual.id != null) {
        bool sucesso = await ApiService.deletarFicha(_fichaAtual.id!);
        if (sucesso && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ficha apagada definitivamente.')));
          Navigator.pop(context, true);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Erro ao apagar ficha.'),
              backgroundColor: Colors.red));
        }
      }
    }
  }

  // --- FUNÇÕES DE AUXÍLIO VISUAL ---
  String _traduzirEtapa(String? etapa) {
    switch (etapa) {
      case '0':
        return 'Não se aplica';
      case '1':
        return 'Primeira Etapa';
      case '2':
        return 'Segunda Etapa';
      case '3':
        return 'Terceira Etapa';
      case '4':
        return 'Crisma';
      default:
        return 'Não definida';
    }
  }

  Color _obterCorStatus(String status) {
    switch (status) {
      case 'ativo':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'arquivado':
        return Colors.grey;
      case 'arquivado concluído':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

// --- NOVA FUNÇÃO: RECARREGAR FICHA ATUAL ---
  Future<void> _recarregarFichaAtual() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Sincronizando dados...')));
    try {
      // Busca todas as fichas (incluindo inativas, por garantia)
      final fichas = await ApiService.getFichas(incluirInativos: true);

      // Encontra a ficha atual na lista nova
      final fichaAtualizada = fichas.firstWhere((f) => f.id == _fichaAtual.id,
          orElse: () => _fichaAtual // Se não achar, mantém a que já estava
          );

      setState(() {
        _fichaAtual = fichaAtualizada;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao atualizar')));
    }
  }

// --- FUNÇÃO DE IMPRESSÃO ---
  Future<void> _imprimirFicha() async {
    final pdf = pw.Document();

    pw.MemoryImage? logoImagem;
    try {
      final logoData = await rootBundle.load('assets/logo.png');
      logoImagem = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Erro logo: $e');
    }

    pw.MemoryImage? assinaturaImagem;
    if (_fichaAtual.assinaturaBase64 != null &&
        _fichaAtual.assinaturaBase64!.isNotEmpty) {
      try {
        assinaturaImagem =
            pw.MemoryImage(base64Decode(_fichaAtual.assinaturaBase64!));
      } catch (e) {
        debugPrint('Erro assinatura: $e');
      }
    }

    pw.Widget checkBoxPdf(bool checked) {
      return pw.Container(
        width: 12,
        height: 12,
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
        child: checked
            ? pw.Center(
                child: pw.Text('X',
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)))
            : null,
      );
    }

    pw.Widget linhaPdf(String rotulo, String valor) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(rotulo,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(width: 5),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Text(valor, style: const pw.TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(42),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text('Paróquia São José Operário',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Diocese de Limeira',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            'Rua dos Corte, 155- Jd. Bela Vista (19) 3866-2699',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.Text('CONCHAL/SP',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (logoImagem != null)
                    pw.Image(logoImagem,
                        width: 80, height: 80, fit: pw.BoxFit.contain)
                  else
                    pw.SizedBox(width: 80, height: 80),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('FICHA PASTORAL CATEQUÉTICA:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(width: 15),
                    checkBoxPdf(_fichaAtual.inscricaoBatismo),
                    pw.SizedBox(width: 4),
                    pw.Text('Batismo', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 15),
                    checkBoxPdf(_fichaAtual.inscricaoEucaristia),
                    pw.SizedBox(width: 4),
                    pw.Text('Eucaristia',
                        style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 15),
                    checkBoxPdf(_fichaAtual.inscricaoCrisma),
                    pw.SizedBox(width: 4),
                    pw.Text('Crisma', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 15),
                    checkBoxPdf(_fichaAtual.inscricaoNoivos),
                    pw.SizedBox(width: 4),
                    pw.Text('Noivos', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 15),
                    checkBoxPdf(_fichaAtual.inscricaoAdultos),
                    pw.SizedBox(width: 4),
                    pw.Text('Adultos', style: const pw.TextStyle(fontSize: 11)),
                  ]),
              pw.SizedBox(height: 8),
              pw.Row(children: [
                pw.SizedBox(width: 200),
                checkBoxPdf(_fichaAtual.inscricaoPreCatequese),
                pw.SizedBox(width: 4),
                pw.Text('Pré-Catequese',
                    style: const pw.TextStyle(fontSize: 11)),
                pw.SizedBox(width: 25),
                pw.Text('Etapa:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Container(
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(_traduzirEtapa(_fichaAtual.etapa),
                        style: const pw.TextStyle(fontSize: 11)),
                  ),
                ),
              ]),
              pw.SizedBox(height: 15),
              linhaPdf('Nome:', _fichaAtual.nome),
              pw.Row(children: [
                pw.Expanded(
                    flex: 4,
                    child: linhaPdf('Data de nascimento:',
                        _fichaAtual.dataNascimento ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    flex: 4,
                    child: linhaPdf('Cidade onde nasceu:',
                        _fichaAtual.cidadeNascimento ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    flex: 1,
                    child: linhaPdf('UF:', _fichaAtual.ufNascimento ?? '')),
              ]),
              linhaPdf('Nome do Pai:', _fichaAtual.nomePai ?? ''),
              linhaPdf('Nome da Mãe:', _fichaAtual.nomeMae ?? ''),
              pw.Row(children: [
                pw.Expanded(
                    child: linhaPdf(
                        'Fone Fixo Pai:', _fichaAtual.foneFixoPai ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    child:
                        linhaPdf('Celular Pai:', _fichaAtual.celularPai ?? '')),
              ]),
              pw.Row(children: [
                pw.Expanded(
                    child: linhaPdf(
                        'Fone Fixo Mãe:', _fichaAtual.foneFixoMae ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    child:
                        linhaPdf('Celular Mãe:', _fichaAtual.celularMae ?? '')),
              ]),
              linhaPdf('CEP:', _fichaAtual.cep ?? ''),
              linhaPdf('Endereço Atual:', _fichaAtual.rua ?? ''),
              pw.Row(children: [
                pw.Expanded(
                    flex: 1, child: linhaPdf('nº:', _fichaAtual.numero ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    flex: 3,
                    child: linhaPdf('Bairro:', _fichaAtual.bairro ?? '')),
              ]),
              pw.SizedBox(height: 15),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Pais casados?',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(width: 10),
                    checkBoxPdf(_fichaAtual.paisCasados == 'Não'),
                    pw.SizedBox(width: 4),
                    pw.Text('Não', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 10),
                    checkBoxPdf(_fichaAtual.paisCasados == 'Sim'),
                    pw.SizedBox(width: 4),
                    pw.Text('Sim', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 25),
                    pw.Text('Qual Paróquia:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(width: 5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border:
                                pw.Border(bottom: pw.BorderSide(width: 0.5))),
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text(_fichaAtual.paroquiaCasamento ?? '',
                            style: const pw.TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Catequizando Batizado(a)?',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(width: 10),
                    checkBoxPdf(_fichaAtual.isBatizado == 'Sim'),
                    pw.SizedBox(width: 4),
                    pw.Text('Sim', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 10),
                    checkBoxPdf(_fichaAtual.isBatizado == 'Não'),
                    pw.SizedBox(width: 4),
                    pw.Text('Não', style: const pw.TextStyle(fontSize: 11)),
                    pw.SizedBox(width: 25),
                    pw.Text('Data de Batismo:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.SizedBox(width: 5),
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(
                            border:
                                pw.Border(bottom: pw.BorderSide(width: 0.5))),
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text(_fichaAtual.dataBatismo ?? '',
                            style: const pw.TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ),
              linhaPdf(
                  'Paróquia de Batismo:', _fichaAtual.paroquiaBatismo ?? ''),
              pw.Row(children: [
                pw.Expanded(
                    flex: 3,
                    child:
                        linhaPdf('Cidade:', _fichaAtual.cidadeBatismo ?? '')),
                pw.SizedBox(width: 15),
                pw.Expanded(
                    flex: 1,
                    child: linhaPdf('UF:', _fichaAtual.ufBatismo ?? '')),
              ]),
              linhaPdf('Catequista atual:', _fichaAtual.catequistaAtual ?? ''),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (assinaturaImagem != null)
                      pw.Image(assinaturaImagem,
                          height: 40, width: 250, fit: pw.BoxFit.contain)
                    else
                      pw.SizedBox(height: 40),
                    pw.Container(
                      width: 280,
                      decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1))),
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text('Assinatura do Pai ou Responsável',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${_fichaAtual.nome}.pdf',
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
              child: Text(
                  (value == null || value.isEmpty) ? 'Não informado' : value,
                  style: const TextStyle(fontSize: 16))),
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
    if (_fichaAtual.inscricaoNoivos) sacramentos.add('Noivos');
    if (_fichaAtual.inscricaoAdultos) sacramentos.add('Adultos');
    String sacramentosStr =
        sacramentos.isEmpty ? 'Nenhum' : sacramentos.join(', ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Ficha'),
        actions: [
          IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Imprimir',
              onPressed: _imprimirFicha),

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
                      const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Mover Ficha para:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18))),
                      ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: const Text('Ativo'),
                          onTap: () => _mudarStatus('ativo')),
                      ListTile(
                          leading:
                              const Icon(Icons.pending, color: Colors.orange),
                          title: const Text('Pendente'),
                          onTap: () => _mudarStatus('pendente')),
                      ListTile(
                          leading:
                              const Icon(Icons.history, color: Colors.grey),
                          title: const Text('Arquivar (Interrompido)'),
                          onTap: () => _mudarStatus('arquivado')),
                      ListTile(
                          leading:
                              const Icon(Icons.verified, color: Colors.blue),
                          title: const Text('Arquivar como Concluído'),
                          onTap: () => _mudarStatus('arquivado concluído')),
                    ],
                  ),
                );
              },
            ),
          // --- BOTÃO DE REFRESH ADICIONADO AQUI ---
          IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Atualizar Ficha',
              onPressed: _recarregarFichaAtual),
          // ----------------------------------------
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Ficha',
            onPressed: () async {
              final precisaRecarregar = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FormScreen(initialFicha: _fichaAtual)));
              if (precisaRecarregar == true && mounted)
                Navigator.pop(context, true);
            },
          ),

          // --- BOTÃO DE INATIVAR (PROIBIDO) PARA ADMIN E SUPERUSER ---
          if (_userRole != 'user')
            IconButton(
              icon: Icon(_fichaAtual.isAtivo ? Icons.block : Icons.restore,
                  color: _fichaAtual.isAtivo ? Colors.orange : Colors.green),
              tooltip:
                  _fichaAtual.isAtivo ? 'Inativar Ficha' : 'Reativar Ficha',
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
              color: !_fichaAtual.isAtivo
                  ? Colors.red.withOpacity(0.1)
                  : _obterCorStatus(_fichaAtual.status).withOpacity(0.1),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: !_fichaAtual.isAtivo
                        ? Colors.red
                        : _obterCorStatus(_fichaAtual.status),
                    width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                        !_fichaAtual.isAtivo
                            ? Icons.warning
                            : Icons.info_outline,
                        color: !_fichaAtual.isAtivo
                            ? Colors.red
                            : _obterCorStatus(_fichaAtual.status)),
                    const SizedBox(width: 10),
                    Text(
                      !_fichaAtual.isAtivo
                          ? 'STATUS: INATIVO'
                          : 'STATUS: ${_fichaAtual.status.toUpperCase()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !_fichaAtual.isAtivo
                              ? Colors.red
                              : _obterCorStatus(_fichaAtual.status)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ... OS OUTROS CARDS CONTINUAM EXATAMENTE IGUAIS ...
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Inscrição',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildInfoRow('Sacramentos', sacramentosStr),
                          _buildInfoRow(
                              'Etapa', _traduzirEtapa(_fichaAtual.etapa))
                        ]))),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Catequizando',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildInfoRow('Nome', _fichaAtual.nome),
                          _buildInfoRow(
                              'Nascimento', _fichaAtual.dataNascimento),
                          _buildInfoRow('Cidade/UF Natal',
                              '${_fichaAtual.cidadeNascimento ?? ''} / ${_fichaAtual.ufNascimento ?? ''}')
                        ]))),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Família e Contato',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildInfoRow('Nome do Pai', _fichaAtual.nomePai),
                          Row(children: [
                            Expanded(
                                child: _buildInfoRow(
                                    'Celular', _fichaAtual.celularPai)),
                            Expanded(
                                child: _buildInfoRow(
                                    'Fixo', _fichaAtual.foneFixoPai))
                          ]),
                          const SizedBox(height: 10),
                          _buildInfoRow('Nome da Mãe', _fichaAtual.nomeMae),
                          Row(children: [
                            Expanded(
                                child: _buildInfoRow(
                                    'Celular', _fichaAtual.celularMae)),
                            Expanded(
                                child: _buildInfoRow(
                                    'Fixo', _fichaAtual.foneFixoMae))
                          ])
                        ]))),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Endereço',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildInfoRow('CEP', _fichaAtual.cep),
                          _buildInfoRow('Rua', _fichaAtual.rua),
                          Row(children: [
                            Expanded(
                                flex: 2,
                                child: _buildInfoRow(
                                    'Número', _fichaAtual.numero)),
                            Expanded(
                                flex: 3,
                                child:
                                    _buildInfoRow('Bairro', _fichaAtual.bairro))
                          ])
                        ]))),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vida Cristã',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildInfoRow(
                              'Paróquia Atual', _fichaAtual.paroquiaAtual),
                          _buildInfoRow(
                              'Catequista', _fichaAtual.catequistaAtual),
                          const SizedBox(height: 10),
                          _buildInfoRow('Pais casados na Igreja?',
                              _fichaAtual.paisCasados),
                          _buildInfoRow('Paróquia do Casamento',
                              _fichaAtual.paroquiaCasamento),
                          const SizedBox(height: 10),
                          _buildInfoRow('É Batizado?', _fichaAtual.isBatizado),
                          _buildInfoRow(
                              'Data do Batismo', _fichaAtual.dataBatismo),
                          _buildInfoRow('Paróquia do Batismo',
                              _fichaAtual.paroquiaBatismo),
                          _buildInfoRow('Cidade/UF Batismo',
                              '${_fichaAtual.cidadeBatismo ?? ''} / ${_fichaAtual.ufBatismo ?? ''}')
                        ]))),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Assinatura do Responsável',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 10),
                          if (_fichaAtual.assinaturaBase64 != null &&
                              _fichaAtual.assinaturaBase64!.isNotEmpty)
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Image.memory(
                                    base64Decode(_fichaAtual.assinaturaBase64!),
                                    height: 100,
                                    fit: BoxFit.contain))
                          else
                            const Text('Nenhuma assinatura registrada.',
                                style: TextStyle(fontStyle: FontStyle.italic))
                        ]))),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

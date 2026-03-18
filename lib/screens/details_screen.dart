import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; 
import 'package:flutter/services.dart' show rootBundle; 
import 'form_screen.dart';
import '../database/app_database.dart';

class DetailsScreen extends StatelessWidget {
  final Ficha ficha;
  final AppDatabase database;

  const DetailsScreen({super.key, required this.ficha, required this.database});

  Future<void> _imprimirFicha() async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    try {
      final logoData = await rootBundle.load('assets/logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Não foi possível carregar a logo localmente: $e');
    }

    Uint8List? assinaturaBytes;
    if (ficha.assinaturaBase64.isNotEmpty) {
      assinaturaBytes = base64Decode(ficha.assinaturaBase64);
    }

    pw.Widget linha(String rotulo, String valor) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(rotulo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(width: 4),
            pw.Expanded(
              child: pw.Container(
                decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
                child: pw.Text(valor, style: const pw.TextStyle(fontSize: 11)),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget checkbox(String texto, bool marcado) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 10,
            height: 10,
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
            child: marcado ? pw.Center(child: pw.Text('X', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))) : null,
          ),
          pw.SizedBox(width: 4),
          pw.Text(texto, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(width: 12),
        ]
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40), 
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) pw.SizedBox(width: 110),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('Paróquia São José Operário', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Diocese de Limeira', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Rua dos Corte, 155- Jd. Bela Vista (19) 3866-2699', style: const pw.TextStyle(fontSize: 11)),
                        pw.Text('CONCHAL/SP', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      ]
                    )
                  ),
                  if (logoImage != null) pw.Container(width: 110, height: 83, child: pw.Image(logoImage)),
                ]
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text('FICHA PASTORAL CATEQUÉTICA 2025:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.SizedBox(width: 10),
                  checkbox('Batismo', ficha.isBatizado == 'Sim'),
                  checkbox('Eucaristia', false),
                  checkbox('Crisma', false),
                ]
              ),
              pw.SizedBox(height: 4),
              pw.Row(children: [pw.SizedBox(width: 215), checkbox('Pré-Catequese', false)]),
              pw.SizedBox(height: 10),
              linha('Nome:', ficha.nome),
              pw.Row(
                children: [
                  pw.Expanded(flex: 4, child: linha('Data de nascimento:', ficha.dataNascimento)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 5, child: linha('Cidade onde nasceu:', ficha.cidadeNascimento)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 2, child: linha('UF:', ficha.ufNascimento)),
                ]
              ),
              pw.SizedBox(height: 10),
              linha('Nome do Pai:', ficha.nomePai),
              linha('Nome da Mãe:', ficha.nomeMae),
              pw.Row(
                children: [
                  pw.Expanded(child: linha('Fone Fixo Pai:', ficha.foneFixoPai ?? '')),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: linha('Celular Pai:', ficha.celularPai ?? '')),
                ]
              ),
              pw.Row(
                children: [
                  pw.Expanded(child: linha('Fone Fixo Mãe:', ficha.foneFixoMae ?? '')),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: linha('Celular Mãe:', ficha.celularMae ?? '')),
                ]
              ),
              pw.Row(
                children: [
                  pw.Expanded(flex: 6, child: linha('Endereço Atual:', ficha.rua)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 2, child: linha('nº:', ficha.numero)),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 4, child: linha('Bairro:', ficha.bairro)),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text('Pais casados?', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.SizedBox(width: 10),
                  checkbox('Não', ficha.paisCasados == 'Não'),
                  checkbox('Sim', ficha.paisCasados == 'Sim'),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: linha('Qual Paróquia:', ficha.paroquiaCasamento ?? '')),
                ]
              ),
              pw.SizedBox(height: 6),
              pw.Row(
                children: [
                  pw.Text('Catequizando Batizado(a)?', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.SizedBox(width: 10),
                  checkbox('Sim', ficha.isBatizado == 'Sim'),
                  checkbox('Não', ficha.isBatizado == 'Não'),
                  pw.SizedBox(width: 10),
                  pw.Expanded(child: linha('Data de Batismo:', ficha.dataBatismo ?? '')),
                ]
              ),
              linha('Paróquia de Batismo:', ficha.paroquiaBatismo ?? ''),
              pw.Row(
                children: [
                  pw.Expanded(flex: 7, child: linha('Cidade:', ficha.cidadeBatismo ?? '')),
                  pw.SizedBox(width: 10),
                  pw.Expanded(flex: 3, child: linha('UF:', ficha.ufBatismo ?? '')),
                ]
              ),
              linha('Catequista atual:', ficha.catequistaAtual),
              pw.Spacer(), 
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (assinaturaBytes != null) 
                      pw.Container(
                        height: 50,
                        child: pw.Image(pw.MemoryImage(assinaturaBytes)),
                      ),
                    pw.Text('_________________________________________'),
                    pw.SizedBox(height: 4),
                    pw.Text('Assinatura do Pai ou Responsável', style: const pw.TextStyle(fontSize: 10)),
                  ]
                )
              )
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ficha.nome),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _imprimirFicha(), 
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormScreen(
                    database: database,
                    initialFicha: ficha,
                  ),
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Suspender Ficha?'),
                  content: const Text('Esta ficha será removida da lista principal.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Suspender')),
                  ],
                ),
              );

              if (confirmar == true && context.mounted) {
                // Aqui chamamos o método do banco que já cuida dos drift.Value internamente
                await database.inactivateFicha(ficha.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: Text(ficha.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Nascido em: ${ficha.dataNascimento}\nParóquia Atual: ${ficha.paroquiaAtual}'),
            ),
          ),
        ],
      ),
    );
  }
}
import '../widgets/uf_autocomplete.dart';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../database/app_database.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http; // ADICIONE ESTA LINHA NO SEU PUBSPEC.YAML

class FormScreen extends StatefulWidget {
  final AppDatabase database;
  final Ficha? initialFicha;

  const FormScreen({super.key, required this.database, this.initialFicha});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLADORES ---
  final _nomeController = TextEditingController();
  final _nascimentoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _nomePaiController = TextEditingController();
  final _foneFixoPaiController = TextEditingController();
  final _celularPaiController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _foneFixoMaeController = TextEditingController();
  final _celularMaeController = TextEditingController();
  final _cepController = TextEditingController(); // Novo: CEP
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _paroquiaCasamentoController = TextEditingController();
  final _paroquiaAtualController = TextEditingController();
  final _catequistaAtualController = TextEditingController();
  final _dataBatismoController = TextEditingController();
  final _paroquiaBatismoController = TextEditingController();
  final _cidadeBatismoController = TextEditingController();
  final _ufBatismoController = TextEditingController();
  
  String _paisCasados = 'Não';
  String _isBatizado = 'Não';

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // --- MÁSCARAS ---
  var maskData = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var maskCelular = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskFixo = MaskTextInputFormatter(mask: '(##) ####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskCEP = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    if (widget.initialFicha != null) {
      final f = widget.initialFicha!;
      _nomeController.text = f.nome;
      _nascimentoController.text = f.dataNascimento;
      _cidadeController.text = f.cidadeNascimento;
      _ufController.text = f.ufNascimento;
      _nomePaiController.text = f.nomePai;
      _foneFixoPaiController.text = f.foneFixoPai ?? '';
      _celularPaiController.text = f.celularPai ?? '';
      _nomeMaeController.text = f.nomeMae;
      _foneFixoMaeController.text = f.foneFixoMae ?? '';
      _celularMaeController.text = f.celularMae ?? '';
      _paisCasados = f.paisCasados;
      _paroquiaCasamentoController.text = f.paroquiaCasamento ?? '';
      _ruaController.text = f.rua;
      _numeroController.text = f.numero;
      _bairroController.text = f.bairro;
      _paroquiaAtualController.text = f.paroquiaAtual;
      _catequistaAtualController.text = f.catequistaAtual;
      _isBatizado = f.isBatizado;
      _dataBatismoController.text = f.dataBatismo ?? '';
      _paroquiaBatismoController.text = f.paroquiaBatismo ?? '';
      _cidadeBatismoController.text = f.cidadeBatismo ?? '';
      _ufBatismoController.text = f.ufBatismo ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose(); _nascimentoController.dispose();
    _cidadeController.dispose(); _ufController.dispose();
    _nomePaiController.dispose(); _foneFixoPaiController.dispose();
    _celularPaiController.dispose(); _nomeMaeController.dispose();
    _foneFixoMaeController.dispose(); _celularMaeController.dispose();
    _cepController.dispose(); _ruaController.dispose(); 
    _numeroController.dispose(); _bairroController.dispose();
    _paroquiaCasamentoController.dispose(); _paroquiaAtualController.dispose();
    _catequistaAtualController.dispose(); _dataBatismoController.dispose();
    _paroquiaBatismoController.dispose(); _cidadeBatismoController.dispose();
    _ufBatismoController.dispose(); _signatureController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO BUSCA CEP ---
  Future<void> _buscarCEP(String cep) async {
    final cleanCep = cep.replaceAll('-', '');
    if (cleanCep.length != 8) return;

    final url = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) return;
        setState(() {
          _ruaController.text = data['logradouro'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _cidadeController.text = data['localidade'] ?? '';
          _ufController.text = data['uf'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar CEP: $e');
    }
  }

  Future<void> _salvar() async {
    String signatureBase64 = widget.initialFicha?.assinaturaBase64 ?? '';
    if (_signatureController.isNotEmpty) {
      final signatureBytes = await _signatureController.toPngBytes();
      if (signatureBytes != null) signatureBase64 = base64Encode(signatureBytes);
    }

    if (widget.initialFicha != null) {
      final fichaEditada = widget.initialFicha!.copyWith(
        nome: _nomeController.text,
        dataNascimento: _nascimentoController.text,
        cidadeNascimento: _cidadeController.text,
        ufNascimento: _ufController.text,
        nomePai: _nomePaiController.text,
        foneFixoPai: drift.Value(_foneFixoPaiController.text),
        celularPai: drift.Value(_celularPaiController.text),
        nomeMae: _nomeMaeController.text,
        foneFixoMae: drift.Value(_foneFixoMaeController.text),
        celularMae: drift.Value(_celularMaeController.text),
        paisCasados: _paisCasados,
        paroquiaCasamento: drift.Value(_paroquiaCasamentoController.text),
        rua: _ruaController.text,
        numero: _numeroController.text,
        bairro: _bairroController.text,
        paroquiaAtual: _paroquiaAtualController.text,
        catequistaAtual: _catequistaAtualController.text,
        isBatizado: _isBatizado,
        dataBatismo: drift.Value(_dataBatismoController.text),
        paroquiaBatismo: drift.Value(_paroquiaBatismoController.text),
        cidadeBatismo: drift.Value(_cidadeBatismoController.text),
        ufBatismo: drift.Value(_ufBatismoController.text),
        assinaturaBase64: signatureBase64,
      );
      await widget.database.updateFicha(fichaEditada);
    } else {
      await widget.database.into(widget.database.fichas).insert(
        FichasCompanion.insert(
          id: drift.Value(DateTime.now().millisecondsSinceEpoch.toString()),
          nome: _nomeController.text,
          dataNascimento: _nascimentoController.text,
          cidadeNascimento: _cidadeController.text,
          ufNascimento: _ufController.text,
          nomePai: _nomePaiController.text,
          foneFixoPai: drift.Value(_foneFixoPaiController.text),
          celularPai: drift.Value(_celularPaiController.text),
          nomeMae: _nomeMaeController.text,
          foneFixoMae: drift.Value(_foneFixoMaeController.text),
          celularMae: drift.Value(_celularMaeController.text),
          rua: _ruaController.text,
          numero: _numeroController.text,
          bairro: _bairroController.text,
          paroquiaCasamento: drift.Value(_paroquiaCasamentoController.text),
          paroquiaAtual: _paroquiaAtualController.text,
          catequistaAtual: _catequistaAtualController.text,
          isBatizado: _isBatizado,
          dataBatismo: drift.Value(_dataBatismoController.text),
          paroquiaBatismo: drift.Value(_paroquiaBatismoController.text),
          cidadeBatismo: drift.Value(_cidadeBatismoController.text),
          ufBatismo: drift.Value(_ufBatismoController.text),
          paisCasados: _paisCasados,
          assinaturaBase64: signatureBase64,
          dataCriacao: drift.Value(DateTime.now()),
        )
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialFicha != null ? 'Editar Ficha' : 'Nova Ficha')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            // CORREÇÃO: No primeiro passo, validamos apenas o necessário ou permitimos avançar
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              // Somente no último passo validamos o formulário INTEIRO antes de salvar
              if (_formKey.currentState!.validate()) {
                _salvar();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, preencha os campos obrigatórios nos passos anteriores.')),
                );
              }
            }
          },
          onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
          steps: [
            Step(
              title: const Text('Catequizando'),
              content: Column(children: [
                TextFormField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome Completo'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                TextFormField(controller: _nascimentoController, inputFormatters: [maskData], keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '00/00/0000', labelText: 'Data de Nascimento'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                Row(children: [
                  Expanded(child: TextFormField(controller: _cidadeController, decoration: const InputDecoration(labelText: 'Cidade Natal'))),
                  const SizedBox(width: 10),
                  Expanded(child: UFAutocomplete(controller: _ufController, label: 'UF')),
                ]),
              ]),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Família e Contato'),
              content: Column(children: [
                TextFormField(controller: _nomePaiController, decoration: const InputDecoration(labelText: 'Nome do Pai')),
                Row(children: [
                  Expanded(child: TextFormField(controller: _celularPaiController, keyboardType: TextInputType.phone, inputFormatters: [maskCelular], decoration: const InputDecoration(hintText: '(00) 00000-0000', labelText: 'Celular Pai'))),
                  const SizedBox(width: 10),
                  Expanded(child: TextFormField(controller: _foneFixoPaiController, keyboardType: TextInputType.phone, inputFormatters: [maskFixo], decoration: const InputDecoration(hintText: '(00) 0000-0000', labelText: 'Fixo Pai'))),
                ]),
                const Divider(height: 30),
                TextFormField(controller: _nomeMaeController, decoration: const InputDecoration(labelText: 'Nome da Mãe')),
                Row(children: [
                  Expanded(child: TextFormField(controller: _celularMaeController, keyboardType: TextInputType.phone, inputFormatters: [maskCelular], decoration: const InputDecoration(hintText: '(00) 00000-0000', labelText: 'Celular Mãe'))),
                  const SizedBox(width: 10),
                  Expanded(child: TextFormField(controller: _foneFixoMaeController, keyboardType: TextInputType.phone, inputFormatters: [maskFixo], decoration: const InputDecoration(hintText: '(00) 0000-0000', labelText: 'Fixo Mãe'))),
                ]),
              ]),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Endereço e Catequese'),
              content: Column(children: [
                TextFormField(
                  controller: _cepController, 
                  inputFormatters: [maskCEP], 
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'CEP', suffixIcon: Icon(Icons.search)),
                  onChanged: (v) { if (v.length == 9) _buscarCEP(v); },
                ),
                TextFormField(controller: _ruaController, decoration: const InputDecoration(labelText: 'Rua')),
                Row(children: [
                  Expanded(flex: 2, child: TextFormField(controller: _numeroController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nº'))),
                  const SizedBox(width: 10),
                  Expanded(flex: 5, child: TextFormField(controller: _bairroController, decoration: const InputDecoration(labelText: 'Bairro'))),
                ]),
                TextFormField(controller: _paroquiaAtualController, decoration: const InputDecoration(labelText: 'Paróquia Atual')),
                TextFormField(controller: _catequistaAtualController, decoration: const InputDecoration(labelText: 'Catequista Atual')),
              ]),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Vida Cristã'),
              content: Column(children: [
                DropdownButtonFormField<String>(
                  value: _paisCasados,
                  decoration: const InputDecoration(labelText: 'Pais casados na Igreja?'),
                  items: ['Sim', 'Não'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setState(() => _paisCasados = v!),
                ),
                TextFormField(controller: _paroquiaCasamentoController, decoration: const InputDecoration(labelText: 'Paróquia do Casamento')),
                const Divider(height: 30),
                DropdownButtonFormField<String>(
                  value: _isBatizado,
                  decoration: const InputDecoration(labelText: 'Catequizando é Batizado?'),
                  items: ['Sim', 'Não'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (v) => setState(() => _isBatizado = v!),
                ),
                TextFormField(controller: _dataBatismoController, keyboardType: TextInputType.datetime, inputFormatters: [maskData], decoration: const InputDecoration(hintText: 'dd/mm/aaaa', labelText: 'Data do Batismo')),
                TextFormField(controller: _paroquiaBatismoController, decoration: const InputDecoration(labelText: 'Paróquia do Batismo')),
                Row(children: [
                  Expanded(child: TextFormField(controller: _cidadeBatismoController, decoration: const InputDecoration(labelText: 'Cidade Batismo'))),
                  const SizedBox(width: 10),
                  Expanded(child: UFAutocomplete(controller: _ufBatismoController, label: 'UF')),
                ]),
              ]),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: const Text('Assinatura'),
              content: Column(children: [
                const Text('Assine abaixo:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Signature(controller: _signatureController, height: 150, backgroundColor: Colors.white),
                ),
                TextButton(onPressed: () => _signatureController.clear(), child: const Text('Limpar Assinatura')),
              ]),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }
}
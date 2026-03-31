import '../widgets/uf_autocomplete.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ficha_model.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  final Ficha? initialFicha;
  const FormScreen({super.key, this.initialFicha});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String _userRole = 'user';

  // --- LISTA DE CATEQUISTAS ---
  List<String> _listaCatequistas = [];

  // Controllers
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
  final _cepController = TextEditingController();
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

  bool _inscBatismo = false;
  bool _inscEucaristia = false;
  bool _inscCrisma = false;
  bool _inscPreCatequese = false;
  bool _inscNoivos = false;
  bool _inscAdultos = false;
  String _etapa = '0';

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Máscaras
  var maskData = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var maskCelular = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskFixo = MaskTextInputFormatter(
      mask: '(##) ####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskCEP = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    _carregarRole();
    if (widget.initialFicha != null) {
      _preencherCampos();
    }
  }

  Future<void> _carregarRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role') ?? 'user';
    });

    // Se não for usuário comum, puxa a lista de catequistas do banco
    if (_userRole != 'user') {
      _buscarListaDeCatequistas();
    }
  }

  // --- NOVA FUNÇÃO: BUSCAR CATEQUISTAS DO BANCO ---
  Future<void> _buscarListaDeCatequistas() async {
    try {
      // O limite 0 traz todos os usuários da base
      final users = await ApiService.getUsers(limit: 0);
      setState(() {
        _listaCatequistas = users
            // Filtra para pegar apenas usuários ativos que são "superuser" (Catequistas)
            .where((u) => u['role'] == 'superuser' && u['isAtivo'] == true)
            .map<String>((u) => u['nome'].toString())
            .toList();
      });
    } catch (e) {
      debugPrint('Erro ao carregar lista de catequistas: $e');
    }
  }

  void _preencherCampos() {
    final f = widget.initialFicha!;
    _nomeController.text = f.nome;
    _nascimentoController.text = f.dataNascimento ?? '';
    _cidadeController.text = f.cidadeNascimento ?? '';
    _ufController.text = f.ufNascimento ?? '';
    _nomePaiController.text = f.nomePai ?? '';
    _foneFixoPaiController.text = f.foneFixoPai ?? '';
    _celularPaiController.text = f.celularPai ?? '';
    _nomeMaeController.text = f.nomeMae ?? '';
    _foneFixoMaeController.text = f.foneFixoMae ?? '';
    _celularMaeController.text = f.celularMae ?? '';
    _paisCasados = f.paisCasados ?? 'Não';
    _paroquiaCasamentoController.text = f.paroquiaCasamento ?? '';
    _cepController.text = f.cep ?? '';
    _ruaController.text = f.rua ?? '';
    _numeroController.text = f.numero ?? '';
    _bairroController.text = f.bairro ?? '';
    _paroquiaAtualController.text = f.paroquiaAtual ?? '';
    _catequistaAtualController.text = f.catequistaAtual ?? '';
    _isBatizado = f.isBatizado ?? 'Não';
    _dataBatismoController.text = f.dataBatismo ?? '';
    _paroquiaBatismoController.text = f.paroquiaBatismo ?? '';
    _cidadeBatismoController.text = f.cidadeBatismo ?? '';
    _ufBatismoController.text = f.ufBatismo ?? '';
    _inscBatismo = f.inscricaoBatismo;
    _inscEucaristia = f.inscricaoEucaristia;
    _inscCrisma = f.inscricaoCrisma;
    _inscPreCatequese = f.inscricaoPreCatequese;
    _inscNoivos = f.inscricaoNoivos;
    _inscAdultos = f.inscricaoAdultos;
    _etapa = f.etapa ?? '0';
  }

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
      debugPrint('Erro: $e');
    }
  }

  Future<void> _salvar() async {
    setState(() => _isSaving = true);
    String signatureBase64 = widget.initialFicha?.assinaturaBase64 ?? '';
    if (_signatureController.isNotEmpty) {
      final signatureBytes = await _signatureController.toPngBytes();
      if (signatureBytes != null)
        signatureBase64 = base64Encode(signatureBytes);
    }

    final fichaParaSalvar = Ficha(
      id: widget.initialFicha?.id,
      nome: _nomeController.text,
      dataNascimento: _nascimentoController.text,
      cidadeNascimento: _cidadeController.text,
      ufNascimento: _ufController.text,
      nomePai: _nomePaiController.text,
      celularPai: _celularPaiController.text,
      foneFixoPai: _foneFixoPaiController.text,
      nomeMae: _nomeMaeController.text,
      celularMae: _celularMaeController.text,
      foneFixoMae: _foneFixoMaeController.text,
      cep: _cepController.text,
      rua: _ruaController.text,
      numero: _numeroController.text,
      bairro: _bairroController.text,
      paroquiaAtual: _paroquiaAtualController.text,
      catequistaAtual:
          _catequistaAtualController.text, // Pega o valor do Autocomplete
      paisCasados: _paisCasados,
      paroquiaCasamento: _paroquiaCasamentoController.text,
      isBatizado: _isBatizado,
      dataBatismo: _dataBatismoController.text,
      paroquiaBatismo: _paroquiaBatismoController.text,
      cidadeBatismo: _cidadeBatismoController.text,
      ufBatismo: _ufBatismoController.text,
      assinaturaBase64: signatureBase64,
      inscricaoBatismo: _inscBatismo,
      inscricaoEucaristia: _inscEucaristia,
      inscricaoCrisma: _inscCrisma,
      inscricaoPreCatequese: _inscPreCatequese,
      inscricaoNoivos: _inscNoivos,
      inscricaoAdultos: _inscAdultos,
      etapa: _etapa,
    );

    bool sucesso;
    if (widget.initialFicha != null && widget.initialFicha!.id != null) {
      sucesso = await ApiService.atualizarFicha(fichaParaSalvar);
    } else {
      sucesso = await ApiService.salvarFicha(fichaParaSalvar);
    }
    setState(() => _isSaving = false);
    if (sucesso && mounted) Navigator.pop(context, true);
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('Catequizando'),
        content: Column(children: [
          TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome Completo'),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
          TextFormField(
              controller: _nascimentoController,
              inputFormatters: [maskData],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: '00/00/0000', labelText: 'Data de Nascimento'),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
          Row(children: [
            Expanded(
                child: TextFormField(
                    controller: _cidadeController,
                    decoration:
                        const InputDecoration(labelText: 'Cidade Natal'))),
            const SizedBox(width: 10),
            Expanded(
                child: UFAutocomplete(controller: _ufController, label: 'UF'))
          ]),
        ]),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Família'),
        content: Column(children: [
          TextFormField(
              controller: _nomePaiController,
              decoration: const InputDecoration(labelText: 'Nome do Pai')),
          Row(children: [
            Expanded(
                child: TextFormField(
                    controller: _celularPaiController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskCelular],
                    decoration: const InputDecoration(
                        hintText: '(00) 00000-0000',
                        labelText: 'Celular Pai'))),
            const SizedBox(width: 10),
            Expanded(
                child: TextFormField(
                    controller: _foneFixoPaiController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskFixo],
                    decoration: const InputDecoration(
                        hintText: '(00) 0000-0000', labelText: 'Fixo Pai')))
          ]),
          const Divider(height: 30),
          TextFormField(
              controller: _nomeMaeController,
              decoration: const InputDecoration(labelText: 'Nome da Mãe')),
          Row(children: [
            Expanded(
                child: TextFormField(
                    controller: _celularMaeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskCelular],
                    decoration: const InputDecoration(
                        hintText: '(00) 00000-0000',
                        labelText: 'Celular Mãe'))),
            const SizedBox(width: 10),
            Expanded(
                child: TextFormField(
                    controller: _foneFixoMaeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskFixo],
                    decoration: const InputDecoration(
                        hintText: '(00) 0000-0000', labelText: 'Fixo Mãe')))
          ]),
        ]),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Endereço'),
        content: Column(children: [
          TextFormField(
              controller: _cepController,
              inputFormatters: [maskCEP],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'CEP', suffixIcon: const Icon(Icons.search)),
              onChanged: (v) {
                if (v.length == 9) _buscarCEP(v);
              }),
          TextFormField(
              controller: _ruaController,
              decoration: const InputDecoration(labelText: 'Rua')),
          Row(children: [
            Expanded(
                flex: 2,
                child: TextFormField(
                    controller: _numeroController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nº'))),
            const SizedBox(width: 10),
            Expanded(
                flex: 5,
                child: TextFormField(
                    controller: _bairroController,
                    decoration: const InputDecoration(labelText: 'Bairro')))
          ]),
          TextFormField(
              controller: _paroquiaAtualController,
              decoration: const InputDecoration(labelText: 'Paróquia Atual')),
        ]),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Vida Cristã'),
        content: Column(children: [
          DropdownButtonFormField<String>(
              value: _paisCasados,
              decoration:
                  const InputDecoration(labelText: 'Pais casados na Igreja?'),
              items: ['Sim', 'Não']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _paisCasados = v!)),
          if (_paisCasados == 'Sim') ...[
            TextFormField(
                controller: _paroquiaCasamentoController,
                decoration:
                    const InputDecoration(labelText: 'Paróquia do Casamento')),
            const Divider(height: 30),
          ],
          DropdownButtonFormField<String>(
              value: _isBatizado,
              decoration:
                  const InputDecoration(labelText: 'Catequizando é Batizado?'),
              items: ['Sim', 'Não']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _isBatizado = v!)),
          if (_isBatizado == 'Sim') ...[
            TextFormField(
                controller: _dataBatismoController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [maskData],
                decoration: const InputDecoration(
                    hintText: 'dd/mm/aaaa', labelText: 'Data do Batismo')),
            TextFormField(
                controller: _paroquiaBatismoController,
                decoration:
                    const InputDecoration(labelText: 'Paróquia do Batismo')),
            Row(children: [
              Expanded(
                  child: TextFormField(
                      controller: _cidadeBatismoController,
                      decoration:
                          const InputDecoration(labelText: 'Cidade Batismo'))),
              const SizedBox(width: 10),
              Expanded(
                  child: UFAutocomplete(
                      controller: _ufBatismoController, label: 'UF'))
            ]),
          ],
        ]),
        isActive: _currentStep >= 3,
      ),
      if (_userRole != 'user')
        Step(
          title: const Text('Inscrição'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sacramentos:',
                  style: TextStyle(fontWeight: FontWeight.bold)),

              // --- CAMPO AUTOCOMPLETE DE CATEQUISTA ---
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  // Se estiver vazio, mostra a lista inteira
                  if (textEditingValue.text.isEmpty) {
                    return _listaCatequistas;
                  }
                  // Filtra pelo que está sendo digitado
                  return _listaCatequistas.where((option) => option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String selection) {
                  _catequistaAtualController.text = selection;
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  // Sincroniza a inicialização quando editamos uma ficha existente
                  if (controller.text.isEmpty &&
                      _catequistaAtualController.text.isNotEmpty) {
                    controller.text = _catequistaAtualController.text;
                  }
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (val) {
                      _catequistaAtualController.text =
                          val; // Mantém o controller original atualizado se ele só digitar
                    },
                    decoration: const InputDecoration(
                      labelText: 'Catequista Atual',
                      hintText: 'Busque o catequista...',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // ----------------------------------------

              CheckboxListTile(
                  title: const Text('Batismo'),
                  value: _inscBatismo,
                  onChanged: (v) => setState(() => _inscBatismo = v!)),
              CheckboxListTile(
                  title: const Text('Eucaristia'),
                  value: _inscEucaristia,
                  onChanged: (v) => setState(() => _inscEucaristia = v!)),
              CheckboxListTile(
                  title: const Text('Crisma'),
                  value: _inscCrisma,
                  onChanged: (v) => setState(() => _inscCrisma = v!)),
              CheckboxListTile(
                  title: const Text('Pré-Catequese'),
                  value: _inscPreCatequese,
                  onChanged: (v) => setState(() => _inscPreCatequese = v!)),
              CheckboxListTile(
                  title: const Text('Curso de Noivos'),
                  value: _inscNoivos,
                  onChanged: (v) => setState(() => _inscNoivos = v!)),
              CheckboxListTile(
                  title: const Text('Catequese Adultos'),
                  value: _inscAdultos,
                  onChanged: (v) => setState(() => _inscAdultos = v!)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _etapa,
                decoration: const InputDecoration(labelText: 'Etapa'),
                items: ['0', '1', '2', '3']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => _etapa = v!),
              ),
            ],
          ),
          isActive: _currentStep >= 4,
        ),
      Step(
        title: const Text('Assinatura'),
        content: Column(children: [
          const Text('Assine abaixo:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                  controller: _signatureController,
                  height: 150,
                  backgroundColor: Colors.white)),
          TextButton(
              onPressed: () => _signatureController.clear(),
              child: const Text('Limpar Assinatura')),
        ]),
        isActive: _currentStep >= (_userRole == 'user' ? 4 : 5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.initialFicha != null ? 'Editar Ficha' : 'Nova Ficha')),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Stepper(
              key: ValueKey(steps.length),
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < steps.length - 1) {
                  setState(() => _currentStep++);
                } else {
                  if (_formKey.currentState!.validate()) _salvar();
                }
              },
              onStepCancel: _currentStep > 0
                  ? () => setState(() => _currentStep--)
                  : null,
              steps: steps,
            ),
          ),
          if (_isSaving)
            Container(
                color: Colors.black54,
                child: const Center(
                    child: CircularProgressIndicator(color: Colors.white))),
        ],
      ),
    );
  }
}

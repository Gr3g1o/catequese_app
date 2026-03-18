// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FichasTable extends Fichas with TableInfo<$FichasTable, Ficha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FichasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataNascimentoMeta = const VerificationMeta(
    'dataNascimento',
  );
  @override
  late final GeneratedColumn<String> dataNascimento = GeneratedColumn<String>(
    'data_nascimento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cidadeNascimentoMeta = const VerificationMeta(
    'cidadeNascimento',
  );
  @override
  late final GeneratedColumn<String> cidadeNascimento = GeneratedColumn<String>(
    'cidade_nascimento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ufNascimentoMeta = const VerificationMeta(
    'ufNascimento',
  );
  @override
  late final GeneratedColumn<String> ufNascimento = GeneratedColumn<String>(
    'uf_nascimento',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 2),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomePaiMeta = const VerificationMeta(
    'nomePai',
  );
  @override
  late final GeneratedColumn<String> nomePai = GeneratedColumn<String>(
    'nome_pai',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foneFixoPaiMeta = const VerificationMeta(
    'foneFixoPai',
  );
  @override
  late final GeneratedColumn<String> foneFixoPai = GeneratedColumn<String>(
    'fone_fixo_pai',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _celularPaiMeta = const VerificationMeta(
    'celularPai',
  );
  @override
  late final GeneratedColumn<String> celularPai = GeneratedColumn<String>(
    'celular_pai',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomeMaeMeta = const VerificationMeta(
    'nomeMae',
  );
  @override
  late final GeneratedColumn<String> nomeMae = GeneratedColumn<String>(
    'nome_mae',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foneFixoMaeMeta = const VerificationMeta(
    'foneFixoMae',
  );
  @override
  late final GeneratedColumn<String> foneFixoMae = GeneratedColumn<String>(
    'fone_fixo_mae',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _celularMaeMeta = const VerificationMeta(
    'celularMae',
  );
  @override
  late final GeneratedColumn<String> celularMae = GeneratedColumn<String>(
    'celular_mae',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paisCasadosMeta = const VerificationMeta(
    'paisCasados',
  );
  @override
  late final GeneratedColumn<String> paisCasados = GeneratedColumn<String>(
    'pais_casados',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paroquiaCasamentoMeta = const VerificationMeta(
    'paroquiaCasamento',
  );
  @override
  late final GeneratedColumn<String> paroquiaCasamento =
      GeneratedColumn<String>(
        'paroquia_casamento',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ruaMeta = const VerificationMeta('rua');
  @override
  late final GeneratedColumn<String> rua = GeneratedColumn<String>(
    'rua',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bairroMeta = const VerificationMeta('bairro');
  @override
  late final GeneratedColumn<String> bairro = GeneratedColumn<String>(
    'bairro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paroquiaAtualMeta = const VerificationMeta(
    'paroquiaAtual',
  );
  @override
  late final GeneratedColumn<String> paroquiaAtual = GeneratedColumn<String>(
    'paroquia_atual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catequistaAtualMeta = const VerificationMeta(
    'catequistaAtual',
  );
  @override
  late final GeneratedColumn<String> catequistaAtual = GeneratedColumn<String>(
    'catequista_atual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBatizadoMeta = const VerificationMeta(
    'isBatizado',
  );
  @override
  late final GeneratedColumn<String> isBatizado = GeneratedColumn<String>(
    'is_batizado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataBatismoMeta = const VerificationMeta(
    'dataBatismo',
  );
  @override
  late final GeneratedColumn<String> dataBatismo = GeneratedColumn<String>(
    'data_batismo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paroquiaBatismoMeta = const VerificationMeta(
    'paroquiaBatismo',
  );
  @override
  late final GeneratedColumn<String> paroquiaBatismo = GeneratedColumn<String>(
    'paroquia_batismo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cidadeBatismoMeta = const VerificationMeta(
    'cidadeBatismo',
  );
  @override
  late final GeneratedColumn<String> cidadeBatismo = GeneratedColumn<String>(
    'cidade_batismo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ufBatismoMeta = const VerificationMeta(
    'ufBatismo',
  );
  @override
  late final GeneratedColumn<String> ufBatismo = GeneratedColumn<String>(
    'uf_batismo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assinaturaBase64Meta = const VerificationMeta(
    'assinaturaBase64',
  );
  @override
  late final GeneratedColumn<String> assinaturaBase64 = GeneratedColumn<String>(
    'assinatura_base64',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    dataNascimento,
    cidadeNascimento,
    ufNascimento,
    nomePai,
    foneFixoPai,
    celularPai,
    nomeMae,
    foneFixoMae,
    celularMae,
    paisCasados,
    paroquiaCasamento,
    rua,
    numero,
    bairro,
    paroquiaAtual,
    catequistaAtual,
    isBatizado,
    dataBatismo,
    paroquiaBatismo,
    cidadeBatismo,
    ufBatismo,
    assinaturaBase64,
    isSynced,
    dataCriacao,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fichas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ficha> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('data_nascimento')) {
      context.handle(
        _dataNascimentoMeta,
        dataNascimento.isAcceptableOrUnknown(
          data['data_nascimento']!,
          _dataNascimentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataNascimentoMeta);
    }
    if (data.containsKey('cidade_nascimento')) {
      context.handle(
        _cidadeNascimentoMeta,
        cidadeNascimento.isAcceptableOrUnknown(
          data['cidade_nascimento']!,
          _cidadeNascimentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cidadeNascimentoMeta);
    }
    if (data.containsKey('uf_nascimento')) {
      context.handle(
        _ufNascimentoMeta,
        ufNascimento.isAcceptableOrUnknown(
          data['uf_nascimento']!,
          _ufNascimentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ufNascimentoMeta);
    }
    if (data.containsKey('nome_pai')) {
      context.handle(
        _nomePaiMeta,
        nomePai.isAcceptableOrUnknown(data['nome_pai']!, _nomePaiMeta),
      );
    } else if (isInserting) {
      context.missing(_nomePaiMeta);
    }
    if (data.containsKey('fone_fixo_pai')) {
      context.handle(
        _foneFixoPaiMeta,
        foneFixoPai.isAcceptableOrUnknown(
          data['fone_fixo_pai']!,
          _foneFixoPaiMeta,
        ),
      );
    }
    if (data.containsKey('celular_pai')) {
      context.handle(
        _celularPaiMeta,
        celularPai.isAcceptableOrUnknown(data['celular_pai']!, _celularPaiMeta),
      );
    }
    if (data.containsKey('nome_mae')) {
      context.handle(
        _nomeMaeMeta,
        nomeMae.isAcceptableOrUnknown(data['nome_mae']!, _nomeMaeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMaeMeta);
    }
    if (data.containsKey('fone_fixo_mae')) {
      context.handle(
        _foneFixoMaeMeta,
        foneFixoMae.isAcceptableOrUnknown(
          data['fone_fixo_mae']!,
          _foneFixoMaeMeta,
        ),
      );
    }
    if (data.containsKey('celular_mae')) {
      context.handle(
        _celularMaeMeta,
        celularMae.isAcceptableOrUnknown(data['celular_mae']!, _celularMaeMeta),
      );
    }
    if (data.containsKey('pais_casados')) {
      context.handle(
        _paisCasadosMeta,
        paisCasados.isAcceptableOrUnknown(
          data['pais_casados']!,
          _paisCasadosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paisCasadosMeta);
    }
    if (data.containsKey('paroquia_casamento')) {
      context.handle(
        _paroquiaCasamentoMeta,
        paroquiaCasamento.isAcceptableOrUnknown(
          data['paroquia_casamento']!,
          _paroquiaCasamentoMeta,
        ),
      );
    }
    if (data.containsKey('rua')) {
      context.handle(
        _ruaMeta,
        rua.isAcceptableOrUnknown(data['rua']!, _ruaMeta),
      );
    } else if (isInserting) {
      context.missing(_ruaMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('bairro')) {
      context.handle(
        _bairroMeta,
        bairro.isAcceptableOrUnknown(data['bairro']!, _bairroMeta),
      );
    } else if (isInserting) {
      context.missing(_bairroMeta);
    }
    if (data.containsKey('paroquia_atual')) {
      context.handle(
        _paroquiaAtualMeta,
        paroquiaAtual.isAcceptableOrUnknown(
          data['paroquia_atual']!,
          _paroquiaAtualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paroquiaAtualMeta);
    }
    if (data.containsKey('catequista_atual')) {
      context.handle(
        _catequistaAtualMeta,
        catequistaAtual.isAcceptableOrUnknown(
          data['catequista_atual']!,
          _catequistaAtualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catequistaAtualMeta);
    }
    if (data.containsKey('is_batizado')) {
      context.handle(
        _isBatizadoMeta,
        isBatizado.isAcceptableOrUnknown(data['is_batizado']!, _isBatizadoMeta),
      );
    } else if (isInserting) {
      context.missing(_isBatizadoMeta);
    }
    if (data.containsKey('data_batismo')) {
      context.handle(
        _dataBatismoMeta,
        dataBatismo.isAcceptableOrUnknown(
          data['data_batismo']!,
          _dataBatismoMeta,
        ),
      );
    }
    if (data.containsKey('paroquia_batismo')) {
      context.handle(
        _paroquiaBatismoMeta,
        paroquiaBatismo.isAcceptableOrUnknown(
          data['paroquia_batismo']!,
          _paroquiaBatismoMeta,
        ),
      );
    }
    if (data.containsKey('cidade_batismo')) {
      context.handle(
        _cidadeBatismoMeta,
        cidadeBatismo.isAcceptableOrUnknown(
          data['cidade_batismo']!,
          _cidadeBatismoMeta,
        ),
      );
    }
    if (data.containsKey('uf_batismo')) {
      context.handle(
        _ufBatismoMeta,
        ufBatismo.isAcceptableOrUnknown(data['uf_batismo']!, _ufBatismoMeta),
      );
    }
    if (data.containsKey('assinatura_base64')) {
      context.handle(
        _assinaturaBase64Meta,
        assinaturaBase64.isAcceptableOrUnknown(
          data['assinatura_base64']!,
          _assinaturaBase64Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assinaturaBase64Meta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ficha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ficha(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      dataNascimento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_nascimento'],
      )!,
      cidadeNascimento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade_nascimento'],
      )!,
      ufNascimento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uf_nascimento'],
      )!,
      nomePai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_pai'],
      )!,
      foneFixoPai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fone_fixo_pai'],
      ),
      celularPai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}celular_pai'],
      ),
      nomeMae: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_mae'],
      )!,
      foneFixoMae: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fone_fixo_mae'],
      ),
      celularMae: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}celular_mae'],
      ),
      paisCasados: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pais_casados'],
      )!,
      paroquiaCasamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paroquia_casamento'],
      ),
      rua: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rua'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero'],
      )!,
      bairro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bairro'],
      )!,
      paroquiaAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paroquia_atual'],
      )!,
      catequistaAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catequista_atual'],
      )!,
      isBatizado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}is_batizado'],
      )!,
      dataBatismo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_batismo'],
      ),
      paroquiaBatismo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paroquia_batismo'],
      ),
      cidadeBatismo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade_batismo'],
      ),
      ufBatismo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uf_batismo'],
      ),
      assinaturaBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assinatura_base64'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $FichasTable createAlias(String alias) {
    return $FichasTable(attachedDatabase, alias);
  }
}

class Ficha extends DataClass implements Insertable<Ficha> {
  final String id;
  final String nome;
  final String dataNascimento;
  final String cidadeNascimento;
  final String ufNascimento;
  final String nomePai;
  final String? foneFixoPai;
  final String? celularPai;
  final String nomeMae;
  final String? foneFixoMae;
  final String? celularMae;
  final String paisCasados;
  final String? paroquiaCasamento;
  final String rua;
  final String numero;
  final String bairro;
  final String paroquiaAtual;
  final String catequistaAtual;
  final String isBatizado;
  final String? dataBatismo;
  final String? paroquiaBatismo;
  final String? cidadeBatismo;
  final String? ufBatismo;
  final String assinaturaBase64;
  final bool isSynced;
  final DateTime dataCriacao;
  final bool isActive;
  const Ficha({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.cidadeNascimento,
    required this.ufNascimento,
    required this.nomePai,
    this.foneFixoPai,
    this.celularPai,
    required this.nomeMae,
    this.foneFixoMae,
    this.celularMae,
    required this.paisCasados,
    this.paroquiaCasamento,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.paroquiaAtual,
    required this.catequistaAtual,
    required this.isBatizado,
    this.dataBatismo,
    this.paroquiaBatismo,
    this.cidadeBatismo,
    this.ufBatismo,
    required this.assinaturaBase64,
    required this.isSynced,
    required this.dataCriacao,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['data_nascimento'] = Variable<String>(dataNascimento);
    map['cidade_nascimento'] = Variable<String>(cidadeNascimento);
    map['uf_nascimento'] = Variable<String>(ufNascimento);
    map['nome_pai'] = Variable<String>(nomePai);
    if (!nullToAbsent || foneFixoPai != null) {
      map['fone_fixo_pai'] = Variable<String>(foneFixoPai);
    }
    if (!nullToAbsent || celularPai != null) {
      map['celular_pai'] = Variable<String>(celularPai);
    }
    map['nome_mae'] = Variable<String>(nomeMae);
    if (!nullToAbsent || foneFixoMae != null) {
      map['fone_fixo_mae'] = Variable<String>(foneFixoMae);
    }
    if (!nullToAbsent || celularMae != null) {
      map['celular_mae'] = Variable<String>(celularMae);
    }
    map['pais_casados'] = Variable<String>(paisCasados);
    if (!nullToAbsent || paroquiaCasamento != null) {
      map['paroquia_casamento'] = Variable<String>(paroquiaCasamento);
    }
    map['rua'] = Variable<String>(rua);
    map['numero'] = Variable<String>(numero);
    map['bairro'] = Variable<String>(bairro);
    map['paroquia_atual'] = Variable<String>(paroquiaAtual);
    map['catequista_atual'] = Variable<String>(catequistaAtual);
    map['is_batizado'] = Variable<String>(isBatizado);
    if (!nullToAbsent || dataBatismo != null) {
      map['data_batismo'] = Variable<String>(dataBatismo);
    }
    if (!nullToAbsent || paroquiaBatismo != null) {
      map['paroquia_batismo'] = Variable<String>(paroquiaBatismo);
    }
    if (!nullToAbsent || cidadeBatismo != null) {
      map['cidade_batismo'] = Variable<String>(cidadeBatismo);
    }
    if (!nullToAbsent || ufBatismo != null) {
      map['uf_batismo'] = Variable<String>(ufBatismo);
    }
    map['assinatura_base64'] = Variable<String>(assinaturaBase64);
    map['is_synced'] = Variable<bool>(isSynced);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  FichasCompanion toCompanion(bool nullToAbsent) {
    return FichasCompanion(
      id: Value(id),
      nome: Value(nome),
      dataNascimento: Value(dataNascimento),
      cidadeNascimento: Value(cidadeNascimento),
      ufNascimento: Value(ufNascimento),
      nomePai: Value(nomePai),
      foneFixoPai: foneFixoPai == null && nullToAbsent
          ? const Value.absent()
          : Value(foneFixoPai),
      celularPai: celularPai == null && nullToAbsent
          ? const Value.absent()
          : Value(celularPai),
      nomeMae: Value(nomeMae),
      foneFixoMae: foneFixoMae == null && nullToAbsent
          ? const Value.absent()
          : Value(foneFixoMae),
      celularMae: celularMae == null && nullToAbsent
          ? const Value.absent()
          : Value(celularMae),
      paisCasados: Value(paisCasados),
      paroquiaCasamento: paroquiaCasamento == null && nullToAbsent
          ? const Value.absent()
          : Value(paroquiaCasamento),
      rua: Value(rua),
      numero: Value(numero),
      bairro: Value(bairro),
      paroquiaAtual: Value(paroquiaAtual),
      catequistaAtual: Value(catequistaAtual),
      isBatizado: Value(isBatizado),
      dataBatismo: dataBatismo == null && nullToAbsent
          ? const Value.absent()
          : Value(dataBatismo),
      paroquiaBatismo: paroquiaBatismo == null && nullToAbsent
          ? const Value.absent()
          : Value(paroquiaBatismo),
      cidadeBatismo: cidadeBatismo == null && nullToAbsent
          ? const Value.absent()
          : Value(cidadeBatismo),
      ufBatismo: ufBatismo == null && nullToAbsent
          ? const Value.absent()
          : Value(ufBatismo),
      assinaturaBase64: Value(assinaturaBase64),
      isSynced: Value(isSynced),
      dataCriacao: Value(dataCriacao),
      isActive: Value(isActive),
    );
  }

  factory Ficha.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ficha(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      dataNascimento: serializer.fromJson<String>(json['dataNascimento']),
      cidadeNascimento: serializer.fromJson<String>(json['cidadeNascimento']),
      ufNascimento: serializer.fromJson<String>(json['ufNascimento']),
      nomePai: serializer.fromJson<String>(json['nomePai']),
      foneFixoPai: serializer.fromJson<String?>(json['foneFixoPai']),
      celularPai: serializer.fromJson<String?>(json['celularPai']),
      nomeMae: serializer.fromJson<String>(json['nomeMae']),
      foneFixoMae: serializer.fromJson<String?>(json['foneFixoMae']),
      celularMae: serializer.fromJson<String?>(json['celularMae']),
      paisCasados: serializer.fromJson<String>(json['paisCasados']),
      paroquiaCasamento: serializer.fromJson<String?>(
        json['paroquiaCasamento'],
      ),
      rua: serializer.fromJson<String>(json['rua']),
      numero: serializer.fromJson<String>(json['numero']),
      bairro: serializer.fromJson<String>(json['bairro']),
      paroquiaAtual: serializer.fromJson<String>(json['paroquiaAtual']),
      catequistaAtual: serializer.fromJson<String>(json['catequistaAtual']),
      isBatizado: serializer.fromJson<String>(json['isBatizado']),
      dataBatismo: serializer.fromJson<String?>(json['dataBatismo']),
      paroquiaBatismo: serializer.fromJson<String?>(json['paroquiaBatismo']),
      cidadeBatismo: serializer.fromJson<String?>(json['cidadeBatismo']),
      ufBatismo: serializer.fromJson<String?>(json['ufBatismo']),
      assinaturaBase64: serializer.fromJson<String>(json['assinaturaBase64']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'dataNascimento': serializer.toJson<String>(dataNascimento),
      'cidadeNascimento': serializer.toJson<String>(cidadeNascimento),
      'ufNascimento': serializer.toJson<String>(ufNascimento),
      'nomePai': serializer.toJson<String>(nomePai),
      'foneFixoPai': serializer.toJson<String?>(foneFixoPai),
      'celularPai': serializer.toJson<String?>(celularPai),
      'nomeMae': serializer.toJson<String>(nomeMae),
      'foneFixoMae': serializer.toJson<String?>(foneFixoMae),
      'celularMae': serializer.toJson<String?>(celularMae),
      'paisCasados': serializer.toJson<String>(paisCasados),
      'paroquiaCasamento': serializer.toJson<String?>(paroquiaCasamento),
      'rua': serializer.toJson<String>(rua),
      'numero': serializer.toJson<String>(numero),
      'bairro': serializer.toJson<String>(bairro),
      'paroquiaAtual': serializer.toJson<String>(paroquiaAtual),
      'catequistaAtual': serializer.toJson<String>(catequistaAtual),
      'isBatizado': serializer.toJson<String>(isBatizado),
      'dataBatismo': serializer.toJson<String?>(dataBatismo),
      'paroquiaBatismo': serializer.toJson<String?>(paroquiaBatismo),
      'cidadeBatismo': serializer.toJson<String?>(cidadeBatismo),
      'ufBatismo': serializer.toJson<String?>(ufBatismo),
      'assinaturaBase64': serializer.toJson<String>(assinaturaBase64),
      'isSynced': serializer.toJson<bool>(isSynced),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Ficha copyWith({
    String? id,
    String? nome,
    String? dataNascimento,
    String? cidadeNascimento,
    String? ufNascimento,
    String? nomePai,
    Value<String?> foneFixoPai = const Value.absent(),
    Value<String?> celularPai = const Value.absent(),
    String? nomeMae,
    Value<String?> foneFixoMae = const Value.absent(),
    Value<String?> celularMae = const Value.absent(),
    String? paisCasados,
    Value<String?> paroquiaCasamento = const Value.absent(),
    String? rua,
    String? numero,
    String? bairro,
    String? paroquiaAtual,
    String? catequistaAtual,
    String? isBatizado,
    Value<String?> dataBatismo = const Value.absent(),
    Value<String?> paroquiaBatismo = const Value.absent(),
    Value<String?> cidadeBatismo = const Value.absent(),
    Value<String?> ufBatismo = const Value.absent(),
    String? assinaturaBase64,
    bool? isSynced,
    DateTime? dataCriacao,
    bool? isActive,
  }) => Ficha(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    dataNascimento: dataNascimento ?? this.dataNascimento,
    cidadeNascimento: cidadeNascimento ?? this.cidadeNascimento,
    ufNascimento: ufNascimento ?? this.ufNascimento,
    nomePai: nomePai ?? this.nomePai,
    foneFixoPai: foneFixoPai.present ? foneFixoPai.value : this.foneFixoPai,
    celularPai: celularPai.present ? celularPai.value : this.celularPai,
    nomeMae: nomeMae ?? this.nomeMae,
    foneFixoMae: foneFixoMae.present ? foneFixoMae.value : this.foneFixoMae,
    celularMae: celularMae.present ? celularMae.value : this.celularMae,
    paisCasados: paisCasados ?? this.paisCasados,
    paroquiaCasamento: paroquiaCasamento.present
        ? paroquiaCasamento.value
        : this.paroquiaCasamento,
    rua: rua ?? this.rua,
    numero: numero ?? this.numero,
    bairro: bairro ?? this.bairro,
    paroquiaAtual: paroquiaAtual ?? this.paroquiaAtual,
    catequistaAtual: catequistaAtual ?? this.catequistaAtual,
    isBatizado: isBatizado ?? this.isBatizado,
    dataBatismo: dataBatismo.present ? dataBatismo.value : this.dataBatismo,
    paroquiaBatismo: paroquiaBatismo.present
        ? paroquiaBatismo.value
        : this.paroquiaBatismo,
    cidadeBatismo: cidadeBatismo.present
        ? cidadeBatismo.value
        : this.cidadeBatismo,
    ufBatismo: ufBatismo.present ? ufBatismo.value : this.ufBatismo,
    assinaturaBase64: assinaturaBase64 ?? this.assinaturaBase64,
    isSynced: isSynced ?? this.isSynced,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    isActive: isActive ?? this.isActive,
  );
  Ficha copyWithCompanion(FichasCompanion data) {
    return Ficha(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      dataNascimento: data.dataNascimento.present
          ? data.dataNascimento.value
          : this.dataNascimento,
      cidadeNascimento: data.cidadeNascimento.present
          ? data.cidadeNascimento.value
          : this.cidadeNascimento,
      ufNascimento: data.ufNascimento.present
          ? data.ufNascimento.value
          : this.ufNascimento,
      nomePai: data.nomePai.present ? data.nomePai.value : this.nomePai,
      foneFixoPai: data.foneFixoPai.present
          ? data.foneFixoPai.value
          : this.foneFixoPai,
      celularPai: data.celularPai.present
          ? data.celularPai.value
          : this.celularPai,
      nomeMae: data.nomeMae.present ? data.nomeMae.value : this.nomeMae,
      foneFixoMae: data.foneFixoMae.present
          ? data.foneFixoMae.value
          : this.foneFixoMae,
      celularMae: data.celularMae.present
          ? data.celularMae.value
          : this.celularMae,
      paisCasados: data.paisCasados.present
          ? data.paisCasados.value
          : this.paisCasados,
      paroquiaCasamento: data.paroquiaCasamento.present
          ? data.paroquiaCasamento.value
          : this.paroquiaCasamento,
      rua: data.rua.present ? data.rua.value : this.rua,
      numero: data.numero.present ? data.numero.value : this.numero,
      bairro: data.bairro.present ? data.bairro.value : this.bairro,
      paroquiaAtual: data.paroquiaAtual.present
          ? data.paroquiaAtual.value
          : this.paroquiaAtual,
      catequistaAtual: data.catequistaAtual.present
          ? data.catequistaAtual.value
          : this.catequistaAtual,
      isBatizado: data.isBatizado.present
          ? data.isBatizado.value
          : this.isBatizado,
      dataBatismo: data.dataBatismo.present
          ? data.dataBatismo.value
          : this.dataBatismo,
      paroquiaBatismo: data.paroquiaBatismo.present
          ? data.paroquiaBatismo.value
          : this.paroquiaBatismo,
      cidadeBatismo: data.cidadeBatismo.present
          ? data.cidadeBatismo.value
          : this.cidadeBatismo,
      ufBatismo: data.ufBatismo.present ? data.ufBatismo.value : this.ufBatismo,
      assinaturaBase64: data.assinaturaBase64.present
          ? data.assinaturaBase64.value
          : this.assinaturaBase64,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ficha(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('cidadeNascimento: $cidadeNascimento, ')
          ..write('ufNascimento: $ufNascimento, ')
          ..write('nomePai: $nomePai, ')
          ..write('foneFixoPai: $foneFixoPai, ')
          ..write('celularPai: $celularPai, ')
          ..write('nomeMae: $nomeMae, ')
          ..write('foneFixoMae: $foneFixoMae, ')
          ..write('celularMae: $celularMae, ')
          ..write('paisCasados: $paisCasados, ')
          ..write('paroquiaCasamento: $paroquiaCasamento, ')
          ..write('rua: $rua, ')
          ..write('numero: $numero, ')
          ..write('bairro: $bairro, ')
          ..write('paroquiaAtual: $paroquiaAtual, ')
          ..write('catequistaAtual: $catequistaAtual, ')
          ..write('isBatizado: $isBatizado, ')
          ..write('dataBatismo: $dataBatismo, ')
          ..write('paroquiaBatismo: $paroquiaBatismo, ')
          ..write('cidadeBatismo: $cidadeBatismo, ')
          ..write('ufBatismo: $ufBatismo, ')
          ..write('assinaturaBase64: $assinaturaBase64, ')
          ..write('isSynced: $isSynced, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    nome,
    dataNascimento,
    cidadeNascimento,
    ufNascimento,
    nomePai,
    foneFixoPai,
    celularPai,
    nomeMae,
    foneFixoMae,
    celularMae,
    paisCasados,
    paroquiaCasamento,
    rua,
    numero,
    bairro,
    paroquiaAtual,
    catequistaAtual,
    isBatizado,
    dataBatismo,
    paroquiaBatismo,
    cidadeBatismo,
    ufBatismo,
    assinaturaBase64,
    isSynced,
    dataCriacao,
    isActive,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ficha &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.dataNascimento == this.dataNascimento &&
          other.cidadeNascimento == this.cidadeNascimento &&
          other.ufNascimento == this.ufNascimento &&
          other.nomePai == this.nomePai &&
          other.foneFixoPai == this.foneFixoPai &&
          other.celularPai == this.celularPai &&
          other.nomeMae == this.nomeMae &&
          other.foneFixoMae == this.foneFixoMae &&
          other.celularMae == this.celularMae &&
          other.paisCasados == this.paisCasados &&
          other.paroquiaCasamento == this.paroquiaCasamento &&
          other.rua == this.rua &&
          other.numero == this.numero &&
          other.bairro == this.bairro &&
          other.paroquiaAtual == this.paroquiaAtual &&
          other.catequistaAtual == this.catequistaAtual &&
          other.isBatizado == this.isBatizado &&
          other.dataBatismo == this.dataBatismo &&
          other.paroquiaBatismo == this.paroquiaBatismo &&
          other.cidadeBatismo == this.cidadeBatismo &&
          other.ufBatismo == this.ufBatismo &&
          other.assinaturaBase64 == this.assinaturaBase64 &&
          other.isSynced == this.isSynced &&
          other.dataCriacao == this.dataCriacao &&
          other.isActive == this.isActive);
}

class FichasCompanion extends UpdateCompanion<Ficha> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> dataNascimento;
  final Value<String> cidadeNascimento;
  final Value<String> ufNascimento;
  final Value<String> nomePai;
  final Value<String?> foneFixoPai;
  final Value<String?> celularPai;
  final Value<String> nomeMae;
  final Value<String?> foneFixoMae;
  final Value<String?> celularMae;
  final Value<String> paisCasados;
  final Value<String?> paroquiaCasamento;
  final Value<String> rua;
  final Value<String> numero;
  final Value<String> bairro;
  final Value<String> paroquiaAtual;
  final Value<String> catequistaAtual;
  final Value<String> isBatizado;
  final Value<String?> dataBatismo;
  final Value<String?> paroquiaBatismo;
  final Value<String?> cidadeBatismo;
  final Value<String?> ufBatismo;
  final Value<String> assinaturaBase64;
  final Value<bool> isSynced;
  final Value<DateTime> dataCriacao;
  final Value<bool> isActive;
  final Value<int> rowid;
  const FichasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.dataNascimento = const Value.absent(),
    this.cidadeNascimento = const Value.absent(),
    this.ufNascimento = const Value.absent(),
    this.nomePai = const Value.absent(),
    this.foneFixoPai = const Value.absent(),
    this.celularPai = const Value.absent(),
    this.nomeMae = const Value.absent(),
    this.foneFixoMae = const Value.absent(),
    this.celularMae = const Value.absent(),
    this.paisCasados = const Value.absent(),
    this.paroquiaCasamento = const Value.absent(),
    this.rua = const Value.absent(),
    this.numero = const Value.absent(),
    this.bairro = const Value.absent(),
    this.paroquiaAtual = const Value.absent(),
    this.catequistaAtual = const Value.absent(),
    this.isBatizado = const Value.absent(),
    this.dataBatismo = const Value.absent(),
    this.paroquiaBatismo = const Value.absent(),
    this.cidadeBatismo = const Value.absent(),
    this.ufBatismo = const Value.absent(),
    this.assinaturaBase64 = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FichasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String dataNascimento,
    required String cidadeNascimento,
    required String ufNascimento,
    required String nomePai,
    this.foneFixoPai = const Value.absent(),
    this.celularPai = const Value.absent(),
    required String nomeMae,
    this.foneFixoMae = const Value.absent(),
    this.celularMae = const Value.absent(),
    required String paisCasados,
    this.paroquiaCasamento = const Value.absent(),
    required String rua,
    required String numero,
    required String bairro,
    required String paroquiaAtual,
    required String catequistaAtual,
    required String isBatizado,
    this.dataBatismo = const Value.absent(),
    this.paroquiaBatismo = const Value.absent(),
    this.cidadeBatismo = const Value.absent(),
    this.ufBatismo = const Value.absent(),
    required String assinaturaBase64,
    this.isSynced = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nome = Value(nome),
       dataNascimento = Value(dataNascimento),
       cidadeNascimento = Value(cidadeNascimento),
       ufNascimento = Value(ufNascimento),
       nomePai = Value(nomePai),
       nomeMae = Value(nomeMae),
       paisCasados = Value(paisCasados),
       rua = Value(rua),
       numero = Value(numero),
       bairro = Value(bairro),
       paroquiaAtual = Value(paroquiaAtual),
       catequistaAtual = Value(catequistaAtual),
       isBatizado = Value(isBatizado),
       assinaturaBase64 = Value(assinaturaBase64);
  static Insertable<Ficha> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? dataNascimento,
    Expression<String>? cidadeNascimento,
    Expression<String>? ufNascimento,
    Expression<String>? nomePai,
    Expression<String>? foneFixoPai,
    Expression<String>? celularPai,
    Expression<String>? nomeMae,
    Expression<String>? foneFixoMae,
    Expression<String>? celularMae,
    Expression<String>? paisCasados,
    Expression<String>? paroquiaCasamento,
    Expression<String>? rua,
    Expression<String>? numero,
    Expression<String>? bairro,
    Expression<String>? paroquiaAtual,
    Expression<String>? catequistaAtual,
    Expression<String>? isBatizado,
    Expression<String>? dataBatismo,
    Expression<String>? paroquiaBatismo,
    Expression<String>? cidadeBatismo,
    Expression<String>? ufBatismo,
    Expression<String>? assinaturaBase64,
    Expression<bool>? isSynced,
    Expression<DateTime>? dataCriacao,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (dataNascimento != null) 'data_nascimento': dataNascimento,
      if (cidadeNascimento != null) 'cidade_nascimento': cidadeNascimento,
      if (ufNascimento != null) 'uf_nascimento': ufNascimento,
      if (nomePai != null) 'nome_pai': nomePai,
      if (foneFixoPai != null) 'fone_fixo_pai': foneFixoPai,
      if (celularPai != null) 'celular_pai': celularPai,
      if (nomeMae != null) 'nome_mae': nomeMae,
      if (foneFixoMae != null) 'fone_fixo_mae': foneFixoMae,
      if (celularMae != null) 'celular_mae': celularMae,
      if (paisCasados != null) 'pais_casados': paisCasados,
      if (paroquiaCasamento != null) 'paroquia_casamento': paroquiaCasamento,
      if (rua != null) 'rua': rua,
      if (numero != null) 'numero': numero,
      if (bairro != null) 'bairro': bairro,
      if (paroquiaAtual != null) 'paroquia_atual': paroquiaAtual,
      if (catequistaAtual != null) 'catequista_atual': catequistaAtual,
      if (isBatizado != null) 'is_batizado': isBatizado,
      if (dataBatismo != null) 'data_batismo': dataBatismo,
      if (paroquiaBatismo != null) 'paroquia_batismo': paroquiaBatismo,
      if (cidadeBatismo != null) 'cidade_batismo': cidadeBatismo,
      if (ufBatismo != null) 'uf_batismo': ufBatismo,
      if (assinaturaBase64 != null) 'assinatura_base64': assinaturaBase64,
      if (isSynced != null) 'is_synced': isSynced,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FichasCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<String>? dataNascimento,
    Value<String>? cidadeNascimento,
    Value<String>? ufNascimento,
    Value<String>? nomePai,
    Value<String?>? foneFixoPai,
    Value<String?>? celularPai,
    Value<String>? nomeMae,
    Value<String?>? foneFixoMae,
    Value<String?>? celularMae,
    Value<String>? paisCasados,
    Value<String?>? paroquiaCasamento,
    Value<String>? rua,
    Value<String>? numero,
    Value<String>? bairro,
    Value<String>? paroquiaAtual,
    Value<String>? catequistaAtual,
    Value<String>? isBatizado,
    Value<String?>? dataBatismo,
    Value<String?>? paroquiaBatismo,
    Value<String?>? cidadeBatismo,
    Value<String?>? ufBatismo,
    Value<String>? assinaturaBase64,
    Value<bool>? isSynced,
    Value<DateTime>? dataCriacao,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return FichasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      cidadeNascimento: cidadeNascimento ?? this.cidadeNascimento,
      ufNascimento: ufNascimento ?? this.ufNascimento,
      nomePai: nomePai ?? this.nomePai,
      foneFixoPai: foneFixoPai ?? this.foneFixoPai,
      celularPai: celularPai ?? this.celularPai,
      nomeMae: nomeMae ?? this.nomeMae,
      foneFixoMae: foneFixoMae ?? this.foneFixoMae,
      celularMae: celularMae ?? this.celularMae,
      paisCasados: paisCasados ?? this.paisCasados,
      paroquiaCasamento: paroquiaCasamento ?? this.paroquiaCasamento,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      paroquiaAtual: paroquiaAtual ?? this.paroquiaAtual,
      catequistaAtual: catequistaAtual ?? this.catequistaAtual,
      isBatizado: isBatizado ?? this.isBatizado,
      dataBatismo: dataBatismo ?? this.dataBatismo,
      paroquiaBatismo: paroquiaBatismo ?? this.paroquiaBatismo,
      cidadeBatismo: cidadeBatismo ?? this.cidadeBatismo,
      ufBatismo: ufBatismo ?? this.ufBatismo,
      assinaturaBase64: assinaturaBase64 ?? this.assinaturaBase64,
      isSynced: isSynced ?? this.isSynced,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (dataNascimento.present) {
      map['data_nascimento'] = Variable<String>(dataNascimento.value);
    }
    if (cidadeNascimento.present) {
      map['cidade_nascimento'] = Variable<String>(cidadeNascimento.value);
    }
    if (ufNascimento.present) {
      map['uf_nascimento'] = Variable<String>(ufNascimento.value);
    }
    if (nomePai.present) {
      map['nome_pai'] = Variable<String>(nomePai.value);
    }
    if (foneFixoPai.present) {
      map['fone_fixo_pai'] = Variable<String>(foneFixoPai.value);
    }
    if (celularPai.present) {
      map['celular_pai'] = Variable<String>(celularPai.value);
    }
    if (nomeMae.present) {
      map['nome_mae'] = Variable<String>(nomeMae.value);
    }
    if (foneFixoMae.present) {
      map['fone_fixo_mae'] = Variable<String>(foneFixoMae.value);
    }
    if (celularMae.present) {
      map['celular_mae'] = Variable<String>(celularMae.value);
    }
    if (paisCasados.present) {
      map['pais_casados'] = Variable<String>(paisCasados.value);
    }
    if (paroquiaCasamento.present) {
      map['paroquia_casamento'] = Variable<String>(paroquiaCasamento.value);
    }
    if (rua.present) {
      map['rua'] = Variable<String>(rua.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (bairro.present) {
      map['bairro'] = Variable<String>(bairro.value);
    }
    if (paroquiaAtual.present) {
      map['paroquia_atual'] = Variable<String>(paroquiaAtual.value);
    }
    if (catequistaAtual.present) {
      map['catequista_atual'] = Variable<String>(catequistaAtual.value);
    }
    if (isBatizado.present) {
      map['is_batizado'] = Variable<String>(isBatizado.value);
    }
    if (dataBatismo.present) {
      map['data_batismo'] = Variable<String>(dataBatismo.value);
    }
    if (paroquiaBatismo.present) {
      map['paroquia_batismo'] = Variable<String>(paroquiaBatismo.value);
    }
    if (cidadeBatismo.present) {
      map['cidade_batismo'] = Variable<String>(cidadeBatismo.value);
    }
    if (ufBatismo.present) {
      map['uf_batismo'] = Variable<String>(ufBatismo.value);
    }
    if (assinaturaBase64.present) {
      map['assinatura_base64'] = Variable<String>(assinaturaBase64.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FichasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('cidadeNascimento: $cidadeNascimento, ')
          ..write('ufNascimento: $ufNascimento, ')
          ..write('nomePai: $nomePai, ')
          ..write('foneFixoPai: $foneFixoPai, ')
          ..write('celularPai: $celularPai, ')
          ..write('nomeMae: $nomeMae, ')
          ..write('foneFixoMae: $foneFixoMae, ')
          ..write('celularMae: $celularMae, ')
          ..write('paisCasados: $paisCasados, ')
          ..write('paroquiaCasamento: $paroquiaCasamento, ')
          ..write('rua: $rua, ')
          ..write('numero: $numero, ')
          ..write('bairro: $bairro, ')
          ..write('paroquiaAtual: $paroquiaAtual, ')
          ..write('catequistaAtual: $catequistaAtual, ')
          ..write('isBatizado: $isBatizado, ')
          ..write('dataBatismo: $dataBatismo, ')
          ..write('paroquiaBatismo: $paroquiaBatismo, ')
          ..write('cidadeBatismo: $cidadeBatismo, ')
          ..write('ufBatismo: $ufBatismo, ')
          ..write('assinaturaBase64: $assinaturaBase64, ')
          ..write('isSynced: $isSynced, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FichasTable fichas = $FichasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fichas];
}

typedef $$FichasTableCreateCompanionBuilder =
    FichasCompanion Function({
      Value<String> id,
      required String nome,
      required String dataNascimento,
      required String cidadeNascimento,
      required String ufNascimento,
      required String nomePai,
      Value<String?> foneFixoPai,
      Value<String?> celularPai,
      required String nomeMae,
      Value<String?> foneFixoMae,
      Value<String?> celularMae,
      required String paisCasados,
      Value<String?> paroquiaCasamento,
      required String rua,
      required String numero,
      required String bairro,
      required String paroquiaAtual,
      required String catequistaAtual,
      required String isBatizado,
      Value<String?> dataBatismo,
      Value<String?> paroquiaBatismo,
      Value<String?> cidadeBatismo,
      Value<String?> ufBatismo,
      required String assinaturaBase64,
      Value<bool> isSynced,
      Value<DateTime> dataCriacao,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$FichasTableUpdateCompanionBuilder =
    FichasCompanion Function({
      Value<String> id,
      Value<String> nome,
      Value<String> dataNascimento,
      Value<String> cidadeNascimento,
      Value<String> ufNascimento,
      Value<String> nomePai,
      Value<String?> foneFixoPai,
      Value<String?> celularPai,
      Value<String> nomeMae,
      Value<String?> foneFixoMae,
      Value<String?> celularMae,
      Value<String> paisCasados,
      Value<String?> paroquiaCasamento,
      Value<String> rua,
      Value<String> numero,
      Value<String> bairro,
      Value<String> paroquiaAtual,
      Value<String> catequistaAtual,
      Value<String> isBatizado,
      Value<String?> dataBatismo,
      Value<String?> paroquiaBatismo,
      Value<String?> cidadeBatismo,
      Value<String?> ufBatismo,
      Value<String> assinaturaBase64,
      Value<bool> isSynced,
      Value<DateTime> dataCriacao,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$FichasTableFilterComposer
    extends Composer<_$AppDatabase, $FichasTable> {
  $$FichasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidadeNascimento => $composableBuilder(
    column: $table.cidadeNascimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ufNascimento => $composableBuilder(
    column: $table.ufNascimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomePai => $composableBuilder(
    column: $table.nomePai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foneFixoPai => $composableBuilder(
    column: $table.foneFixoPai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get celularPai => $composableBuilder(
    column: $table.celularPai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeMae => $composableBuilder(
    column: $table.nomeMae,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foneFixoMae => $composableBuilder(
    column: $table.foneFixoMae,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get celularMae => $composableBuilder(
    column: $table.celularMae,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paisCasados => $composableBuilder(
    column: $table.paisCasados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paroquiaCasamento => $composableBuilder(
    column: $table.paroquiaCasamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rua => $composableBuilder(
    column: $table.rua,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bairro => $composableBuilder(
    column: $table.bairro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paroquiaAtual => $composableBuilder(
    column: $table.paroquiaAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catequistaAtual => $composableBuilder(
    column: $table.catequistaAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isBatizado => $composableBuilder(
    column: $table.isBatizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataBatismo => $composableBuilder(
    column: $table.dataBatismo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paroquiaBatismo => $composableBuilder(
    column: $table.paroquiaBatismo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidadeBatismo => $composableBuilder(
    column: $table.cidadeBatismo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ufBatismo => $composableBuilder(
    column: $table.ufBatismo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assinaturaBase64 => $composableBuilder(
    column: $table.assinaturaBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FichasTableOrderingComposer
    extends Composer<_$AppDatabase, $FichasTable> {
  $$FichasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidadeNascimento => $composableBuilder(
    column: $table.cidadeNascimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ufNascimento => $composableBuilder(
    column: $table.ufNascimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomePai => $composableBuilder(
    column: $table.nomePai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foneFixoPai => $composableBuilder(
    column: $table.foneFixoPai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get celularPai => $composableBuilder(
    column: $table.celularPai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeMae => $composableBuilder(
    column: $table.nomeMae,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foneFixoMae => $composableBuilder(
    column: $table.foneFixoMae,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get celularMae => $composableBuilder(
    column: $table.celularMae,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paisCasados => $composableBuilder(
    column: $table.paisCasados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paroquiaCasamento => $composableBuilder(
    column: $table.paroquiaCasamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rua => $composableBuilder(
    column: $table.rua,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bairro => $composableBuilder(
    column: $table.bairro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paroquiaAtual => $composableBuilder(
    column: $table.paroquiaAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catequistaAtual => $composableBuilder(
    column: $table.catequistaAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isBatizado => $composableBuilder(
    column: $table.isBatizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataBatismo => $composableBuilder(
    column: $table.dataBatismo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paroquiaBatismo => $composableBuilder(
    column: $table.paroquiaBatismo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidadeBatismo => $composableBuilder(
    column: $table.cidadeBatismo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ufBatismo => $composableBuilder(
    column: $table.ufBatismo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assinaturaBase64 => $composableBuilder(
    column: $table.assinaturaBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FichasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FichasTable> {
  $$FichasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidadeNascimento => $composableBuilder(
    column: $table.cidadeNascimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ufNascimento => $composableBuilder(
    column: $table.ufNascimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomePai =>
      $composableBuilder(column: $table.nomePai, builder: (column) => column);

  GeneratedColumn<String> get foneFixoPai => $composableBuilder(
    column: $table.foneFixoPai,
    builder: (column) => column,
  );

  GeneratedColumn<String> get celularPai => $composableBuilder(
    column: $table.celularPai,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomeMae =>
      $composableBuilder(column: $table.nomeMae, builder: (column) => column);

  GeneratedColumn<String> get foneFixoMae => $composableBuilder(
    column: $table.foneFixoMae,
    builder: (column) => column,
  );

  GeneratedColumn<String> get celularMae => $composableBuilder(
    column: $table.celularMae,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paisCasados => $composableBuilder(
    column: $table.paisCasados,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paroquiaCasamento => $composableBuilder(
    column: $table.paroquiaCasamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rua =>
      $composableBuilder(column: $table.rua, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get bairro =>
      $composableBuilder(column: $table.bairro, builder: (column) => column);

  GeneratedColumn<String> get paroquiaAtual => $composableBuilder(
    column: $table.paroquiaAtual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catequistaAtual => $composableBuilder(
    column: $table.catequistaAtual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isBatizado => $composableBuilder(
    column: $table.isBatizado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dataBatismo => $composableBuilder(
    column: $table.dataBatismo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paroquiaBatismo => $composableBuilder(
    column: $table.paroquiaBatismo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidadeBatismo => $composableBuilder(
    column: $table.cidadeBatismo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ufBatismo =>
      $composableBuilder(column: $table.ufBatismo, builder: (column) => column);

  GeneratedColumn<String> get assinaturaBase64 => $composableBuilder(
    column: $table.assinaturaBase64,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$FichasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FichasTable,
          Ficha,
          $$FichasTableFilterComposer,
          $$FichasTableOrderingComposer,
          $$FichasTableAnnotationComposer,
          $$FichasTableCreateCompanionBuilder,
          $$FichasTableUpdateCompanionBuilder,
          (Ficha, BaseReferences<_$AppDatabase, $FichasTable, Ficha>),
          Ficha,
          PrefetchHooks Function()
        > {
  $$FichasTableTableManager(_$AppDatabase db, $FichasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FichasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FichasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FichasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> dataNascimento = const Value.absent(),
                Value<String> cidadeNascimento = const Value.absent(),
                Value<String> ufNascimento = const Value.absent(),
                Value<String> nomePai = const Value.absent(),
                Value<String?> foneFixoPai = const Value.absent(),
                Value<String?> celularPai = const Value.absent(),
                Value<String> nomeMae = const Value.absent(),
                Value<String?> foneFixoMae = const Value.absent(),
                Value<String?> celularMae = const Value.absent(),
                Value<String> paisCasados = const Value.absent(),
                Value<String?> paroquiaCasamento = const Value.absent(),
                Value<String> rua = const Value.absent(),
                Value<String> numero = const Value.absent(),
                Value<String> bairro = const Value.absent(),
                Value<String> paroquiaAtual = const Value.absent(),
                Value<String> catequistaAtual = const Value.absent(),
                Value<String> isBatizado = const Value.absent(),
                Value<String?> dataBatismo = const Value.absent(),
                Value<String?> paroquiaBatismo = const Value.absent(),
                Value<String?> cidadeBatismo = const Value.absent(),
                Value<String?> ufBatismo = const Value.absent(),
                Value<String> assinaturaBase64 = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FichasCompanion(
                id: id,
                nome: nome,
                dataNascimento: dataNascimento,
                cidadeNascimento: cidadeNascimento,
                ufNascimento: ufNascimento,
                nomePai: nomePai,
                foneFixoPai: foneFixoPai,
                celularPai: celularPai,
                nomeMae: nomeMae,
                foneFixoMae: foneFixoMae,
                celularMae: celularMae,
                paisCasados: paisCasados,
                paroquiaCasamento: paroquiaCasamento,
                rua: rua,
                numero: numero,
                bairro: bairro,
                paroquiaAtual: paroquiaAtual,
                catequistaAtual: catequistaAtual,
                isBatizado: isBatizado,
                dataBatismo: dataBatismo,
                paroquiaBatismo: paroquiaBatismo,
                cidadeBatismo: cidadeBatismo,
                ufBatismo: ufBatismo,
                assinaturaBase64: assinaturaBase64,
                isSynced: isSynced,
                dataCriacao: dataCriacao,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String nome,
                required String dataNascimento,
                required String cidadeNascimento,
                required String ufNascimento,
                required String nomePai,
                Value<String?> foneFixoPai = const Value.absent(),
                Value<String?> celularPai = const Value.absent(),
                required String nomeMae,
                Value<String?> foneFixoMae = const Value.absent(),
                Value<String?> celularMae = const Value.absent(),
                required String paisCasados,
                Value<String?> paroquiaCasamento = const Value.absent(),
                required String rua,
                required String numero,
                required String bairro,
                required String paroquiaAtual,
                required String catequistaAtual,
                required String isBatizado,
                Value<String?> dataBatismo = const Value.absent(),
                Value<String?> paroquiaBatismo = const Value.absent(),
                Value<String?> cidadeBatismo = const Value.absent(),
                Value<String?> ufBatismo = const Value.absent(),
                required String assinaturaBase64,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FichasCompanion.insert(
                id: id,
                nome: nome,
                dataNascimento: dataNascimento,
                cidadeNascimento: cidadeNascimento,
                ufNascimento: ufNascimento,
                nomePai: nomePai,
                foneFixoPai: foneFixoPai,
                celularPai: celularPai,
                nomeMae: nomeMae,
                foneFixoMae: foneFixoMae,
                celularMae: celularMae,
                paisCasados: paisCasados,
                paroquiaCasamento: paroquiaCasamento,
                rua: rua,
                numero: numero,
                bairro: bairro,
                paroquiaAtual: paroquiaAtual,
                catequistaAtual: catequistaAtual,
                isBatizado: isBatizado,
                dataBatismo: dataBatismo,
                paroquiaBatismo: paroquiaBatismo,
                cidadeBatismo: cidadeBatismo,
                ufBatismo: ufBatismo,
                assinaturaBase64: assinaturaBase64,
                isSynced: isSynced,
                dataCriacao: dataCriacao,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FichasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FichasTable,
      Ficha,
      $$FichasTableFilterComposer,
      $$FichasTableOrderingComposer,
      $$FichasTableAnnotationComposer,
      $$FichasTableCreateCompanionBuilder,
      $$FichasTableUpdateCompanionBuilder,
      (Ficha, BaseReferences<_$AppDatabase, $FichasTable, Ficha>),
      Ficha,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FichasTableTableManager get fichas =>
      $$FichasTableTableManager(_db, _db.fichas);
}

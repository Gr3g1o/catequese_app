class Ficha {
  final String status;
  final String? id;
  final String nome;
  final String? dataNascimento;
  final String? cidadeNascimento;
  final String? ufNascimento;
  final String? nomePai;
  final String? celularPai;
  final String? foneFixoPai;
  final String? nomeMae;
  final String? celularMae;
  final String? foneFixoMae;
  final String? cep;
  final String? rua;
  final String? numero;
  final String? bairro;
  final String? paroquiaAtual;
  final String? catequistaAtual;
  final String? paisCasados;
  final String? paroquiaCasamento;
  final String? isBatizado;
  final String? dataBatismo;
  final String? paroquiaBatismo;
  final String? cidadeBatismo;
  final String? ufBatismo;
  final String? assinaturaBase64;
  final bool isAtivo;

  // NOVOS CAMPOS
  final bool inscricaoBatismo;
  final bool inscricaoEucaristia;
  final bool inscricaoCrisma;
  final bool inscricaoPreCatequese;
  final bool inscricaoNoivos;
  final bool inscricaoAdultos;
  final String? etapa;

  Ficha({
    this.status = 'ativo',
    this.id,
    required this.nome,
    this.dataNascimento,
    this.cidadeNascimento,
    this.ufNascimento,
    this.nomePai,
    this.celularPai,
    this.foneFixoPai,
    this.nomeMae,
    this.celularMae,
    this.foneFixoMae,
    this.cep,
    this.rua,
    this.numero,
    this.bairro,
    this.paroquiaAtual,
    this.catequistaAtual,
    this.paisCasados,
    this.paroquiaCasamento,
    this.isBatizado,
    this.dataBatismo,
    this.paroquiaBatismo,
    this.cidadeBatismo,
    this.ufBatismo,
    this.assinaturaBase64,
    this.isAtivo = true,
    this.inscricaoBatismo = false,
    this.inscricaoEucaristia = false,
    this.inscricaoCrisma = false,
    this.inscricaoPreCatequese = false,
    this.inscricaoNoivos = false,
    this.inscricaoAdultos = false,
    this.etapa,
  });

  factory Ficha.fromJson(Map<String, dynamic> json) {
    return Ficha(
      status: json['status'] ?? 'ativo',
      id: json['_id'],
      nome: json['nome'] ?? 'Sem nome',
      dataNascimento: json['dataNascimento'],
      cidadeNascimento: json['cidadeNascimento'],
      ufNascimento: json['ufNascimento'],
      nomePai: json['nomePai'],
      celularPai: json['celularPai'],
      foneFixoPai: json['foneFixoPai'],
      nomeMae: json['nomeMae'],
      celularMae: json['celularMae'],
      foneFixoMae: json['foneFixoMae'],
      cep: json['cep'],
      rua: json['rua'],
      numero: json['numero'],
      bairro: json['bairro'],
      paroquiaAtual: json['paroquiaAtual'],
      catequistaAtual: json['catequistaAtual'],
      paisCasados: json['paisCasados'],
      paroquiaCasamento: json['paroquiaCasamento'],
      isBatizado: json['isBatizado'],
      dataBatismo: json['dataBatismo'],
      paroquiaBatismo: json['paroquiaBatismo'],
      cidadeBatismo: json['cidadeBatismo'],
      ufBatismo: json['ufBatismo'],
      assinaturaBase64: json['assinaturaBase64'],
      isAtivo: json['isAtivo'] ?? true,
      inscricaoBatismo: json['inscricaoBatismo'] ?? false,
      inscricaoEucaristia: json['inscricaoEucaristia'] ?? false,
      inscricaoCrisma: json['inscricaoCrisma'] ?? false,
      inscricaoPreCatequese: json['inscricaoPreCatequese'] ?? false,
      inscricaoNoivos: json['inscricaoNoivos'] ?? false,
      inscricaoAdultos: json['inscricaoAdultos'] ?? false,
      etapa: json['etapa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'cidadeNascimento': cidadeNascimento,
      'ufNascimento': ufNascimento,
      'nomePai': nomePai,
      'celularPai': celularPai,
      'foneFixoPai': foneFixoPai,
      'nomeMae': nomeMae,
      'celularMae': celularMae,
      'foneFixoMae': foneFixoMae,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'paroquiaAtual': paroquiaAtual,
      'catequistaAtual': catequistaAtual,
      'paisCasados': paisCasados,
      'paroquiaCasamento': paroquiaCasamento,
      'isBatizado': isBatizado,
      'dataBatismo': dataBatismo,
      'paroquiaBatismo': paroquiaBatismo,
      'cidadeBatismo': cidadeBatismo,
      'ufBatismo': ufBatismo,
      'assinaturaBase64': assinaturaBase64,
      'isAtivo': isAtivo,
      'inscricaoBatismo': inscricaoBatismo,
      'inscricaoEucaristia': inscricaoEucaristia,
      'inscricaoCrisma': inscricaoCrisma,
      'inscricaoPreCatequese': inscricaoPreCatequese,
      'inscricaoNoivos': inscricaoNoivos,
      'inscricaoAdultos': inscricaoAdultos,
      'etapa': etapa,
    };
  }
}

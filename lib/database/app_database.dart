import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// Isto diz ao Drift para gerar o arquivo com o código pesado do banco
part 'app_database.g.dart';

// ==========================================
// 1. DEFINIÇÃO DA TABELA (Nossa Ficha)
// ==========================================
class Fichas extends Table {
  // A CHAVE MÁGICA: UUID em vez de auto_increment!
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  
  // DADOS DO CATEQUIZANDO
  TextColumn get nome => text()();
  TextColumn get dataNascimento => text()();
  TextColumn get cidadeNascimento => text()();
  TextColumn get ufNascimento => text().withLength(max: 2)();

  // FILIAÇÃO E ENDEREÇO
  TextColumn get nomePai => text()();
  TextColumn get foneFixoPai => text().nullable()(); // nullable = campo não obrigatório
  TextColumn get celularPai => text().nullable()();
  TextColumn get nomeMae => text()();
  TextColumn get foneFixoMae => text().nullable()();
  TextColumn get celularMae => text().nullable()();
  TextColumn get paisCasados => text()();
  TextColumn get paroquiaCasamento => text().nullable()();
  
  TextColumn get rua => text()();
  TextColumn get numero => text()();
  TextColumn get bairro => text()();

  // SACRAMENTOS
  TextColumn get paroquiaAtual => text()();
  TextColumn get catequistaAtual => text()();
  TextColumn get isBatizado => text()();
  TextColumn get dataBatismo => text().nullable()();
  TextColumn get paroquiaBatismo => text().nullable()();
  TextColumn get cidadeBatismo => text().nullable()();
  TextColumn get ufBatismo => text().nullable()();

  // ASSINATURA (Vamos salvar a imagem convertida em texto Base64)
  TextColumn get assinaturaBase64 => text()();

  // CONTROLE DE SINCRONIZAÇÃO (Essencial para o futuro!)
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dataCriacao => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// ==========================================
// 2. CONFIGURAÇÃO DA CONEXÃO COM O SQLITE
// ==========================================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Acha a pasta de Documentos do Windows/Mac ou pasta segura do Android/iOS
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'catequese_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Fichas])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Versão do banco de dados (se adicionarmos colunas no futuro, mudamos para 2)
  @override
  int get schemaVersion => 1;

  // Função para salvar uma nova ficha
  Future<int> insertFicha(FichasCompanion novaFicha) {
    return into(fichas).insert(novaFicha);
  }

  // Função para listar todas as fichas (usaremos depois na tela inicial)
  Future<List<Ficha>> getAllFichas() {
    return select(fichas).get();
  }
  // Função que "observa" a base de dados em tempo real
  Stream<List<Ficha>> watchAllFichas() {
    return select(fichas).watch();
  }
// Função de busca inteligente com Filtros, Ordenação e Paginação (Lazy Loading)
  Stream<List<Ficha>> watchFilteredFichas(String search, String sortOrder, int limit) {
    final query = select(fichas)..where((t) => t.isActive.equals(true));

    // 1. FILTRO DE BUSCA
    if (search.isNotEmpty) {
      // O "%" diz ao SQL para buscar o texto em qualquer parte do nome
      query.where((t) => t.nome.like('%$search%')); 
    }

    // 2. ORDENAÇÃO
    query.orderBy([
      (t) {
        if (sortOrder == 'AZ') return OrderingTerm(expression: t.nome, mode: OrderingMode.asc);
        if (sortOrder == 'ZA') return OrderingTerm(expression: t.nome, mode: OrderingMode.desc);
        // Padrão: Mais Recente
        return OrderingTerm(expression: t.dataCriacao, mode: OrderingMode.desc);
      }
    ]);

    // 3. LAZY LOADING (Carrega apenas o limite estipulado)
    query.limit(limit);

    return query.watch();
  }

  // Inativa a ficha em vez de deletar
  Future<int> inactivateFicha(String id) {
    return (update(fichas)..where((t) => t.id.equals(id)))
        .write(const FichasCompanion(isActive: Value(false)));
  }
  // Atualiza uma ficha existente
  Future<bool> updateFicha(Ficha ficha) {
    return update(fichas).replace(ficha);
  }
}
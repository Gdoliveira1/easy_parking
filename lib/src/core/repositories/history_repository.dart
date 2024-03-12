import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";

class HistoryRepository {
  static final HistoryRepository instance = HistoryRepository._init();
  static Database? _database;

  HistoryRepository._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB("history.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE history(
        id TEXT,
        number INTEGER,
        plate TEXT,
        entryTime INTEGER,
        exitTime INTEGER,
        status TEXT
      )
    """);
  }

  Future<int> createVacancy(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert("history", row);
  }

  Future<void> updateVacancy(VacancyModel vacancy) async {
    final Map<String, dynamic> updatedData = {
      "exitTime": vacancy.exitTime!.millisecondsSinceEpoch,
      "status": vacancy.status.title
    };
    final db = await database;
    await db.update(
      "history",
      updatedData,
      where: "id = ?",
      whereArgs: [vacancy.id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllVacancies() async {
    final db = await database;
    return await db.query("history");
  }
}

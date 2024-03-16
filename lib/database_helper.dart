import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'entry_class.dart';
import 'emoji_icon_class.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'journal_entries.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        body TEXT,
        moodLabel TEXT,
        imageData TEXT
      )
    ''');
  }

  Future<int> insertEntry(JournalEntry entry) async {
    Database db = await database;
    return await db.insert('entries', entry.toMap());
  }

  Future<List<JournalEntry>> getEntries() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('entries');
    return List.generate(maps.length, (i) {
      return JournalEntry(
          id: maps[i]['id'],
          date: maps[i]['date'],
          time: maps[i]['time'],
          body: maps[i]['body'],
          moodLabel: maps[i]['moodLabel'],
          imageData: maps[i]['imageData']);
    });
  }

  Future<void> updateEntry(JournalEntry entry) async {
    // Get a reference to the database.
    final db = await database;

    // Update the entry in the database.
    await db.update(
      'entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteEntry(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Delete the entry from the database.
    await db.delete(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

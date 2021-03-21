import 'package:note_app/model/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();
  static Database _db;
  static String columnId = 'id';
  static String columnTitle = 'title';
  static String columnContent = 'content';
  static String columnTime = 'time';
  static String tableNotes = 'notes';
  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }

    return _db = await openDatabase(
      join(await getDatabasesPath(), 'notesDb.db'),
      version: 1,
      onCreate: (Database db, int v) {
        db.execute('''
          CREATE TABLE $tableNotes(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle VARCHAR(32),
            $columnContent VARCHAR(255),
            $columnTime INTEGER);
            ''');
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;

    return db.insert(tableNotes, note.toMap());
  }

  Future<List> allNotes({String text}) async {
    final db = await database;
    if (text == '' || text == null) {
      return await db.query(tableNotes);
    } else {
      return db.query(tableNotes,
          where: '$columnTitle LIKE ? OR $columnContent LIKE ?',
          whereArgs: ['%' + text + '%', '%' + text + '%']);
    }
  }

  Future<int> deleteNote(Note note) async {
    Database db = await database;
    return db.delete(tableNotes, where: '$columnId = ?', whereArgs: [note.id]);
  }

  deleteAllNotes() async {
    final db = await database;
    db.delete(tableNotes);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(tableNotes, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }
}

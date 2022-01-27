import '../models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNotes = 'notes';
  final String colPosition = 'position';
  final String tableNotes = 'notes';

  // Database but keep getting late initalization errors
  Object _db = 1;
  final int _version = 1;
  static SqlHelper _singleton = SqlHelper._internal();

  SqlHelper._internal();

  factory SqlHelper() {
    return _singleton;
  }

  Future init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'notes.db');
    if (_db == 1) {
      _db = await openDatabase(dbPath, version: _version, onCreate: _createDb);
    }
    return _db;
  }

  Future _createDb(Database db, int version) async {
    String query =
        'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, $colName TEXT, $colDate TEXT, $colNotes TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<int> insertNote(Note note) async {
    if (_db == 1) {
      await init();
    }
    note.position = await findPosition();
    int result = await (_db as Database).insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    if (_db == 1) await init();
    int result = await (_db as Database).update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    if (_db == 1) await init();
    int result = await (_db as Database)
        .delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<List<Note>> getNotes() async {
    if (_db == 1) await init();
    List<Map<String, dynamic>> notesList =
        await (_db as Database).query(tableNotes, orderBy: colPosition);
    List<Note> notes = [];
    notesList.forEach((element) {
      notes.add(Note.fromMap(element));
    });
    return notes;
  }

  Future<int> findPosition() async {
    if (_db == 1) await init();
    final String sql = 'select max($colPosition) from $tableNotes';
    List<Map> queryResult = await (_db as Database).rawQuery(sql);
    int? position = queryResult.first.values.first;
    position = (position == null) ? 0 : position++;
    return position;
  }

  Future updatePositions(bool increment, int start, int end) async {
    if (_db == 1) await init();
    String sql;
    if (increment) {
      sql =
          'update $tableNotes set $colPosition = $colPosition + 1  where $colPosition >= $start and $colPosition <= $end';
    } else {
      sql =
          'update $tableNotes set $colPosition = $colPosition - 1  where $colPosition >= $start and $colPosition <= $end';
    }
    await (_db as Database).rawUpdate(sql);
  }
}

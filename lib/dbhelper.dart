import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<sql.Database> db() async {
    String databasePath = await sql.getDatabasesPath();
    String path = join(databasePath, 'kontak.db');
    return sql.openDatabase(path, version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT
    )
    """);
  }

  static Future<int> addNotes(String title, String description) async {
    final db = await DbHelper.db();
    final data = {'title': title, 'description': description};
    return await db.insert('notes', data);
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await DbHelper.db();
    return db.query('notes');
  }

  static Future<int> editNotes(int id, String title, String description) async {
    final db = await DbHelper.db();
    final data = {'title': title, 'description': description};

    return await db.update('notes', data, where: "id=$id");
  }

  static Future<void> deleteNotes(int id) async {
    final db = await DbHelper.db();
    await db.delete('notes', where: "id = $id");
  }
}

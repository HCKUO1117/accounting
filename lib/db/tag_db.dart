import 'package:accounting/db/tag_model.dart';
import 'package:flutter/animation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TagDB {
  static const _databaseName = 'tagDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'tag';

  static const columnId = 'id';
  static const columnSort = 'sort';
  static const columnColor = 'color';
  static const columnName = 'name';

  static Database? database;

  static Future<Database?> getDataBase() async {
    if (database != null) {
      return database;
    } else {
      return await initDataBase();
    }
  }

  static Future<Database?> initDataBase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE $tableName("
            "$columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            "$columnSort INTEGER,"
            "$columnColor INTEGER,"
            "$columnName TEXT"
            ")");
      },
      version: _databaseVersion,
    );
    return database;
  }

  //display all data
  static Future<List<TagModel>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      return TagModel(
        id: maps[index][columnId],
        sort: maps[index][columnSort],
        color: Color(maps[index][columnColor]),
        name: maps[index][columnName],
      );
    });
  }

  static Future<int?> insertData(TagModel tagModel) async {
    final Database? db = await getDataBase();
    try {
      return await db!.insert(tableName, tagModel.toMap());
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateData(TagModel tagModel) async {
    final Database? db = await getDataBase();

    await db!.update(
      tableName,
      tagModel.toMap(),
      where: '$columnId = ?',
      whereArgs: [tagModel.id],
    );
    return true;
  }

  static Future<void> deleteData(int id) async {
    final db = await getDataBase();

    await db!.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return;
  }

  static Future<void> deleteDatabase() async {
    await databaseFactory.deleteDatabase(join(await getDatabasesPath(), _databaseName));
    database = null;
  }
}

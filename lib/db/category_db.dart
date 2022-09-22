import 'package:accounting/db/category_model.dart';
import 'package:flutter/animation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDB {
  static const _databaseName = 'categoryDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'category';

  static const columnId = 'id';
  static const columnType = 'type';
  static const columnIcon = 'icon';
  static const columnIconColor = 'iconColor';
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
            "$columnType TEXT,"
            "$columnIcon TEXT,"
            "$columnIconColor INTEGER,"
            "$columnName TEXT"
            ")");
      },
      version: _databaseVersion,
    );
    return database;
  }

  //display all data
  static Future<List<CategoryModel>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      CategoryType type = CategoryType.income;
      switch (maps[index][columnType]) {
        case 'income':
          type = CategoryType.income;
          break;
        case 'expenditure':
          type = CategoryType.expenditure;
          break;
      }

      return CategoryModel(
        id: maps[index][columnId],
        type: type,
        icon: maps[index][columnIcon],
        iconColor: Color(maps[index][columnIconColor]),
        name: maps[index][columnName],
      );
    });
  }

  static Future<int?> insertData(CategoryModel categoryModel) async {
    final Database? db = await getDataBase();
    try {
      return await db!.insert(tableName, categoryModel.toMap());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateData(CategoryModel historyModel) async {
    final Database? db = await getDataBase();

    await db!.update(
      tableName,
      historyModel.toMap(),
      where: '$columnId = ?',
      whereArgs: [historyModel.id],
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
}

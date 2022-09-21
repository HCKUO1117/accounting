import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDB {
  static const _databaseName = 'categoryDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'category';

  static const columnId = 'id';
  static const columnIcon = 'icon';
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
            "$columnIcon TEXT,"
            "$columnName TEXT,"
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
      return CategoryModel(
        id: maps[index][columnId],
        icon: maps[index][columnIcon],
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

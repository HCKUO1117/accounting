import 'package:accounting/db/accounting_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum QueryType {
  date,
  category,
  tag,
}

class AccountingDB {
  static const _databaseName = 'accountingDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'accounting';

  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnCategory = 'category';
  static const columnTags = 'tags';
  static const columnAmount = 'amount';
  static const columnNote = 'note';

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
            "$columnDate TEXT,"
            "$columnCategory INTEGER,"
            "$columnTags TEXT,"
            "$columnAmount TEXT,"
            "$columnNote TEXT"
            ")");
      },
      version: _databaseVersion,
    );
    return database;
  }

  //display all data
  static Future<List<AccountingModel>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      List<int> tags = [];
      if (maps[index][columnTags].toString().isNotEmpty) {
        tags = [
          for (var element in maps[index][columnTags].toString().split(',')) int.parse(element)
        ];
      }


      return AccountingModel(
        id: maps[index][columnId],
        date: DateTime.parse(maps[index][columnDate]),
        category: maps[index][columnCategory],
        tags: tags,
        amount: double.parse(maps[index][columnAmount]),
        note: maps[index][columnNote],
      );
    });
  }

  //query data
  static Future<List<AccountingModel>> queryData({
    required QueryType queryType,
    List<String>? query,
  }) async {
    final Database? db = await getDataBase();

    String? whereString;
    List<dynamic>? whereArguments;
    switch (queryType) {
      case QueryType.date:
        whereString = '$columnDate = ?';
        whereArguments = query;
        break;
      case QueryType.category:
        whereString = '$columnCategory = ?';
        whereArguments = query;
        break;
      case QueryType.tag:
        whereString = '$columnTags = ?';
        whereArguments = query;
        break;
    }
    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: whereString,
      whereArgs: whereArguments,
    );

    return List.generate(maps.length, (index) {
      List<int> tags = [];
      if (maps[index][columnTags].toString().isNotEmpty) {
        tags = [
          for (var element in maps[index][columnTags].toString().split(',')) int.parse(element)
        ];
      }

      return AccountingModel(
        id: maps[index][columnId],
        date: DateTime.parse(maps[index][columnDate]),
        category: maps[index][columnCategory],
        tags: tags,
        amount: double.parse(maps[index][columnAmount]),
        note: maps[index][columnNote],
      );
    });
  }

  static Future<int?> insertData(AccountingModel historyModel) async {
    final Database? db = await getDataBase();
    try {
      return await db!.insert(tableName, historyModel.toMap());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateData(AccountingModel historyModel) async {
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

  static Future<void> deleteDatabase() async {
    await databaseFactory.deleteDatabase(join(await getDatabasesPath(), _databaseName));
    database = null;
  }
}

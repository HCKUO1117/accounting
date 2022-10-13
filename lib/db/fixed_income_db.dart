import 'package:accounting/db/fixed_income_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum QueryType {
  date,
  category,
  tag,
}

class FixedIncomeDB {
  static const _databaseName = 'fixedIncomeDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'fixedIncome';

  static const columnId = 'id';
  static const columnType = 'type';
  static const columnMonth = 'month';
  static const columnDay = 'day';
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
            "$columnType INTEGER,"
            "$columnMonth INTEGER,"
            "$columnDay INTEGER,"
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
  static Future<List<FixedIncomeModel>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      List<int> tags = [];
      if (maps[index][columnTags].toString().isNotEmpty) {
        tags = [
          for (var element in maps[index][columnTags].toString().split(',')) int.parse(element)
        ];
      }

      return FixedIncomeModel(
        id: maps[index][columnId],
        type: FixedIncomeType.values[maps[index][columnType]],
        month: maps[index][columnMonth],
        day: maps[index][columnDay],
        category: maps[index][columnCategory],
        tags: tags,
        amount: double.parse(maps[index][columnAmount]),
        note: maps[index][columnNote],
      );
    });
  }

  //query data
  // static Future<List<FixedIncomeModel>> queryData({
  //   required QueryType queryType,
  //   List<String>? query,
  // }) async {
  //   final Database? db = await getDataBase();
  //
  //   String? whereString;
  //   List<dynamic>? whereArguments;
  //   switch (queryType) {
  //     case QueryType.date:
  //       whereString = '$columnDate = ?';
  //       whereArguments = query;
  //       break;
  //     case QueryType.category:
  //       whereString = '$columnCategory = ?';
  //       whereArguments = query;
  //       break;
  //     case QueryType.tag:
  //       whereString = '$columnTags = ?';
  //       whereArguments = query;
  //       break;
  //   }
  //   final List<Map<String, dynamic>> maps = await db!.query(
  //     tableName,
  //     where: whereString,
  //     whereArgs: whereArguments,
  //   );
  //
  //   return List.generate(maps.length, (index) {
  //     final List<int> tags = [
  //       for (var element in maps[index][columnTags].toString().split(','))
  //         int.parse(element)
  //     ];
  //     return AccountingModel(
  //       id: maps[index][columnId],
  //       date: DateTime.fromMillisecondsSinceEpoch(
  //         int.parse(maps[index][columnDate]),
  //       ),
  //       category: maps[index][columnCategory],
  //       tags: tags,
  //       amount: double.parse(maps[index][columnAmount]),
  //       note: maps[index][columnNote],
  //     );
  //   });
  // }

  static Future<int?> insertData(FixedIncomeModel fixedIncomeModel) async {
    final Database? db = await getDataBase();
    try {
      return await db!.insert(tableName, fixedIncomeModel.toMap());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateData(FixedIncomeModel fixedIncomeModel) async {
    final Database? db = await getDataBase();

    await db!.update(
      tableName,
      fixedIncomeModel.toMap(),
      where: '$columnId = ?',
      whereArgs: [fixedIncomeModel.id],
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

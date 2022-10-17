import 'package:accounting/db/record_tag_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum RecordTagType {
  record,
  tag,
}

class RecordTagDB {
  static const _databaseName = 'recordTag.db';
  static const _databaseVersion = 1;

  static const tableName = 'recordTag';

  static const columnId = 'id';
  static const columnRecordId = 'recordId';
  static const columnTagId = 'tagId';

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
            "$columnRecordId INTEGER,"
            "$columnTagId INTEGER"
            ")");
      },
      version: _databaseVersion,
    );
    return database;
  }

  //display all data
  static Future<List<RecordTagModel>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      return RecordTagModel(
        id: maps[index][columnId],
        recordId: maps[index][columnRecordId],
        tagId: maps[index][columnTagId],
      );
    });
  }

  //query data
  static Future<List<RecordTagModel>> queryData({
    required RecordTagType queryType,
    List<int>? query,
  }) async {
    final Database? db = await getDataBase();

    String? whereString;
    List<dynamic>? whereArguments;
    switch (queryType) {
      case RecordTagType.record:
        whereString = '$columnRecordId = ?';
        whereArguments = query;
        break;
      case RecordTagType.tag:
        whereString = '$columnTagId = ?';
        whereArguments = query;
        break;
    }
    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: whereString,
      whereArgs: whereArguments,
    );

    return List.generate(maps.length, (index) {
      return RecordTagModel(
        id: maps[index][columnId],
        recordId: maps[index][columnRecordId],
        tagId: maps[index][columnTagId],
      );
    });
  }

  static Future<int?> insertData(RecordTagModel recordTagModel) async {
    final Database? db = await getDataBase();
    try {
      return await db!.insert(tableName, recordTagModel.toMap());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateData(RecordTagModel recordTagModel) async {
    final Database? db = await getDataBase();

    await db!.update(
      tableName,
      recordTagModel.toMap(),
      where: '$columnId = ?',
      whereArgs: [recordTagModel.id],
    );
    return true;
  }

  static Future<void> deleteData({required RecordTagType? type, required int id}) async {
    final db = await getDataBase();

    String? whereString;
    List<dynamic>? whereArguments;
    switch (type) {
      case RecordTagType.record:
        whereString = '$columnRecordId = ?';
        whereArguments = [id];
        break;
      case RecordTagType.tag:
        whereString = '$columnTagId = ?';
        whereArguments = [id];
        break;
      default:
        whereString = '$columnId = ?';
        whereArguments = [id];
    }

    await db!.delete(
      tableName,
      where: whereString,
      whereArgs: whereArguments,
    );
    return;
  }
}

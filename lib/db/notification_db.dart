import 'package:accounting/db/notification_data.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDB{
  static const _databaseName = 'notificationDatabase.db';
  static const _databaseVersion = 1;

  static const tableName = 'notification';

  static const columnId = 'id';
  static const columnContent = 'content';
  static const columnTime = 'time';
  static const columnWeekTimes = 'weekTimes';
  static const columnOpen = 'open';

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
            "$columnContent TEXT,"
            "$columnTime TEXT,"
            "$columnWeekTimes TEXT,"
            "$columnOpen TEXT"
            ")");
      },
      version: _databaseVersion,
    );
    return database;
  }

  static Future<List<NotificationData>> displayAllData() async {
    final Database? db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (index) {
      return NotificationData(
        id: maps[index][columnId],
        content: maps[index][columnContent],
        timeOfDay: TimeOfDay(
            hour: int.parse(maps[index][columnTime].split(":")[0]),
            minute: int.parse(maps[index][columnTime].split(":")[1])),
        weekTimes: maps[index][columnWeekTimes],
        open: maps[index][columnOpen] == 'true' ? true : false,
      );
    });
  }

  static Future<void> insertData(NotificationData notificationData) async {
    final Database? db = await getDataBase();
    await db!.insert(tableName, notificationData.toMap());
  }

  static Future<void> updateData(NotificationData notificationData) async {
    final Database? db = await getDataBase();

    await db!.update(
      tableName,
      notificationData.toMap(),
      where: '$columnId = ?',
      whereArgs: [notificationData.id],
    );
  }

  static Future<void> deleteData(NotificationData notificationData) async {
    final db = await getDataBase();

    await db!.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [notificationData.id],
    );
  }
}

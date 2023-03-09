import 'package:sqflite/sqflite.dart';
import 'package:todo_in_flutter/model/taskModel.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  // this method call from main.dart
  // first time this is required...
  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // this is for insert data into db but call from controller
  static Future<int> insert(TaskModel? taskModel) async {
    print("insert funtion callled");
    //?? means run 1st method if not then run 1
    return await _db?.insert(_tableName, taskModel!.toJson()) ?? 1;
  }


  // get data from db
  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  // Delete Method ...
  static delete(TaskModel task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
}

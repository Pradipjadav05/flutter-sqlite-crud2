// ignore: file_names
import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler.internal();
  DatabaseHandler.internal();

  factory DatabaseHandler() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return db;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'temp_db');
    var mydb = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
  }

  Future<int> saveData(Users user) async {
    var dbClient = await db;
    int res = await dbClient!.insert("Test", user.toMap());
    return res;
  }

  Future<int> updateUser(Users user) async {
    var dbClient = await db;
    int res = await dbClient!
        .update("Temp", user.toMap(), where: "id=?", whereArgs: [user.id]);
    return res;
  }

  Future<List<Users>> getData() async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM Test");
    return res.map((e) => Users.fromMap(e)).toList();
  }

  Future<Users> getUser() async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM Test where id = 1");
    return Users.fromMap(res.first);
  }
}

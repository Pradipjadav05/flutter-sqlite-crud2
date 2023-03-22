// ignore_for_file: avoid_print

import 'dart:async';

import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io';

import '../model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tablename = "user";
  final String columnId = "id";
  final String columnName = "name";
  final String columnPassword = "password";

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "rkit_task");
    var myDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tablename($columnId int, $columnName TEXT, $columnPassword TEXT)");

    print("Table created");
  }

  Future<int> saveData(Users user) async {
    var dbClient = await db;
    int res = await dbClient!.insert(tablename, user.toMap());
    return res;
  }

  Future<List<Users>> getUser() async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $tablename");

    return res.map((e) => Users.fromMap(e)).toList();
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete(tablename, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateUser(Users user) async {
    var dbClient = await db;
    return await dbClient!.update(tablename, user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
  }

  Future<Users> getOneUser(int id) async {
    var dbClient = await db;
    var res = await dbClient!
        .rawQuery("'SELECT * FROM $tablename where $columnId = $id");
    return Users.fromMap(res.first);
  }
}

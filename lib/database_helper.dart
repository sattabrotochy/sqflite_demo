import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlflite_project/userInfo.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'userInfo.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE userInfo(
       id INTEGER PRIMARY KEY, 
       name TEXT
       )''');
  }


  Future<List<UserInfoModel>> getAllUserList()async{
    Database db = await instance.database;
    var user = await db.query('userInfo', orderBy: 'name');
    List<UserInfoModel> userList = user.isNotEmpty
        ? user.map((c) => UserInfoModel.fromMap(c)).toList()
        : [];
    return userList;

  }

  Future<int> add(UserInfoModel userInfo) async {
    Database db = await instance.database;
    return await db.insert('userInfo', userInfo.toMap());
  }
  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('userInfo', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update(UserInfoModel userInfo) async {
    Database db = await instance.database;
    return await db.update('userInfo', userInfo.toMap(),
        where: "id = ?", whereArgs: [userInfo.id]);
  }
}

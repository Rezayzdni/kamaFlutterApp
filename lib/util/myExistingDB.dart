import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:comma/model/dictionary.dart';

class DbHelperReal{
  static final DbHelperReal _instance = DbHelperReal.internal();
  DbHelperReal.internal();
  factory DbHelperReal() => _instance;
  String colEn = "en";
  String colFa = "fa";
  String colId = "id";
  String colTime = "time";
  String colCardTime = 'cardtime';
  String colNumber = "number";

  static Database _db;

  Future<Database> get db async {

    if (_db == null) {
        _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    // dictionary_bomb.db
    Directory dir = await getApplicationDocumentsDirectory();
   String  path = dir.path + "dictionary_ss77.db";
     var dbDictionary = await openDatabase(path, version:1, onCreate: createDb);
     // print(' myHero $dbDictionary');
    return dbDictionary;
      print(' ffffff $dbDictionary');
  }
  Future<void> createDb(Database db, int newVersion,) async {


    await db.execute(
        "CREATE TABLE IF NOT EXISTS tmpplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT, $colCardTime INTEGER)");






    await db.execute(
        "CREATE TABLE IF NOT EXISTS firstplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT , $colCardTime INTEGER)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS secondplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT, $colCardTime INTEGER)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS thirdplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT, $colCardTime INTEGER)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS fourthplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT, $colCardTime INTEGER)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS fifthplace($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEn TEXT, $colFa TEXT, $colCardTime INTEGER)");


  }

  Future<void> copyTable() async{
 await this.db.then((value) => value.execute("INSERT INTO tmpplace($colId , $colEn, $colFa, $colCardTime) SELECT $colId, $colEn, $colFa, $colCardTime FROM mamain"));






  }
  Future<void> resetTable() async{
    await this.db.then((value) => value.execute("DELETE FROM firstplace"));
    await this.db.then((value) => value.execute("DELETE FROM secondplace"));
    await this.db.then((value) => value.execute("DELETE FROM thirdplace"));
    await this.db.then((value) => value.execute("DELETE FROM fourthplace"));
    await this.db.then((value) => value.execute("DELETE FROM fifthplace"));
    await this.db.then((value) => value.execute("DELETE FROM tmpplace"));





  }
  Future<void> resetOnly() async{
    await this.db.then((value) => value.execute("DELETE FROM tmpplace"));






  }

  Future<int> insertWord(Dictionary dictionary,tblName) async {
    Database db = await this.db;
    var result = await db.insert(tblName, dictionary.toMap());
    return result;
  }

  Future<int> updateWord(Dictionary dictionary,String tblName) async {
    var db = await this.db;
    var result = await db.update(tblName, dictionary.toMap(),
        where: "$colId = ?", whereArgs: [dictionary.id]);
    return result;
  }


  Future<List> getWords(tblName) async {
    Database db = await this.db;
    var result = await db.rawQuery(
        "SELECT * FROM $tblName order by $colCardTime ASC");
    return result.toList();
  }

  Future<int> getCount(tblName) async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblName")
    );
    return result;
  }
  Future<int> deleteWord(int id,String tblName) async {
    var db = await this.db;
    var result = await db.rawDelete('DELETE FROM $tblName WHERE $colId = $id');
    return result;
  }
}
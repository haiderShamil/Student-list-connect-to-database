import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite_dev.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:students_list/models/student.dart';

class SQL_Helper
{
  static SQL_Helper dbHelper;
  static Database _database;
  SQL_Helper._createInstant();
  factory SQL_Helper()
  {
    if (dbHelper == null)
      {
        dbHelper = SQL_Helper._createInstant();
      }
    return dbHelper;
  }
  String tableName = "students";
  String _id = "id";
  String _name = "name" ;
  String _description = "description";
  String _date = "date";
  String _pass = "pass" ;

  Future<Database> get database async
  {
    if (_database == null)
      {
        _database = await initializedDatabase();
      }
    return _database;
  }

  Future<Database> initializedDatabase () async
  {

      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "students.db";

      var studentDB = await openDatabase(path, version: 1,onCreate: createDatabase);
      return studentDB;

  }

  void createDatabase (Database db, int version) async {
     await db.execute(
          "CREATE TABLE $tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT, $_description TEXT" +
              "$_pass INTEGER, $_date TEXT)");
    }
    Future<List<Map<String, dynamic>>> getStudentMapList() async
    {
      Database db = await this.database;
//      var result1 = await db.rawQuery("SELECT ' FROM $tableName ORDER BY $_id ASC");
      var result = await db.query(tableName, orderBy: "$_id ASC");// SAME AS LAST ROW
      return result;
    }
    Future <int> insertStudent (Student student) async
    {
      Database db = await this.database;
      var result = await db.insert(tableName, student.toMap());
      return result;
    }
    Future <int> updateStudent (Student student) async
    {
      Database db = await this.database;
      var result = await db.update(tableName, student.toMap(), where: "$_id = ?", whereArgs: [student.id]);
      return result;
    }
    Future <int> deleteStudent (int id) async
    {
      Database db = await this.database;
      int result = await db.rawDelete("DELETE FROM $tableName WHERE $_id = $id");
      return result;
    }
    Future<int> getCount() async
    {
      Database db = await this.database;
      List<Map<String, dynamic>> all = await db.rawQuery("SELECT COUNT (*) FROM $tableName");
      int result = Sqflite.firstIntValue(all);
      return result;
    }
    Future<List<Student>> getStudentList() async
    {
      var studentMapList = await getStudentMapList();
      int count = studentMapList.length;

      List<Student> students = new List<Student>();
      for (int i=0; i<= count -1 ;i++)
        {
          students.add(Student.getMap(studentMapList[i]));
        }
      return students;
    }
}
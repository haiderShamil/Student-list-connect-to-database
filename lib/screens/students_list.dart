import 'package:flutter/material.dart';
import 'package:students_list/screens/student_detail.dart';
import 'dart:async';
import 'package:students_list/models/student.dart';
import 'package:students_list/utilitities/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class StudentsList extends StatefulWidget {
  int count=0;
  @override
  State <StatefulWidget> createState()
  {
    return  StudentsState();
  }
}

class StudentsState extends State<StudentsList> {
  SQL_Helper helper = new SQL_Helper();
  List<Student> studentList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (studentList == null) {
      studentList = new List<Student>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("students"),
      ),
      body: getStudentsList(),
      floatingActionButton: FloatingActionButton
        (
        onPressed: ()
        {
          navigateToStudent(Student('','',1,''), "Add new Student");
        },
        tooltip: "AddStudent",
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getStudentsList()
  {
    return ListView.builder(itemCount: count,
        itemBuilder: (BuildContext context, int position){
      return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile
      (
            leading: CircleAvatar(
              backgroundColor: isPassed(this.studentList[position].pass),
              child: getIcon(this.studentList[position].pass),
            ),
            title: Text(this.studentList[position].name),
            subtitle: Text(this.studentList[position].description + "|" + this.studentList[position].date),
            trailing:
            GestureDetector(
             child: Icon (Icons.delete, color: Colors.grey,),
              onTap: ()
              {
                _delete(context, this.studentList[position]);
              },
            ),
            onTap: ()
            {
              navigateToStudent( this.studentList[position], "Edit Student");
            },
      ),
      );
    });
  }
  Color isPassed (int value)
  {
    switch (value)
    {
      case 1:
        return Colors.amber;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }
  Icon getIcon (int value)
  {
    switch (value)
    {
      case 1:
        return Icon(Icons.check);
        break;
      case 2:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }
  void _delete (BuildContext context, Student student)async
  {
    int result = await helper.deleteStudent(student.id);
    if (result != 0)
      {
        _showSnackBar(context,"Student has been deleted");
        //Update ListView
      }
  }
  void _showSnackBar (BuildContext build, String msg)
  {
    final snackBar = SnackBar (content: Text(msg),);
    Scaffold.of(context).showSnackBar(snackBar);
  }
  void updateListView()
  {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database){
      Future<List<Student>> students = helper.getStudentList();
      students.then((theList){
        this.studentList = theList;
        this.count = theList.length;
      });
    });
  }
  void navigateToStudent(Student student, String appTitle) async
  {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)
    {
      return StudentDetail(student, appTitle);
    }));
    if (result)
      {
        updateListView();
      }
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:students_list/models/student.dart';
import 'package:students_list/utilitities/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:students_list/screens/students_list.dart';

class StudentDetail extends StatefulWidget {
  String screenTitle;
  Student student;
  StudentDetail(this.student, this.screenTitle);
  @override
  State<StatefulWidget> createState()
  {
     return Students(this.student, screenTitle);
  }
}

class Students extends State<StudentDetail> {

  static var _status = ["successed","failed"];
  String screenTitle;
  Student student;
  SQL_Helper helper = new SQL_Helper();

  Students(this.student, this.screenTitle);

  TextEditingController studentName   = new TextEditingController();
  TextEditingController studentDetail = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    studentName.text = student.name;
    studentDetail.text = student.description;
    // WillPopScope(
    //   onWillPop: goBack,
    //   child: Scaffold(
     return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
        onPressed: ()
          {
            goBack();
          },
        ),
      ),
      body: Padding (
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _status.map((String dropDownItem)
                {
                  return DropdownMenuItem<String>
                    (
                    value: dropDownItem,
                    child: Text(dropDownItem),
                  );
                }
                ).toList(),
                style: textStyle,
                value: getPassing(student.pass),
                onChanged: (selectedItem)
                {
                  setState(() {
                    setPassing(selectedItem);
                  });
                },
              ),
            ),
            Padding
              (
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: studentName,
                style: textStyle,
                onChanged: (value)
                {
                  student.name = value;
                },
                decoration: InputDecoration
                  (
                  labelText: "Name",
                  labelStyle: textStyle,
                  border: OutlineInputBorder
                    (
                    borderRadius: BorderRadius.circular(5),
                  )
                ),
              ),
            ),

            Padding//2
              (
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: studentDetail,
                style: textStyle,
                onChanged: (value)
                {
                  student.description = value;
                },
                decoration: InputDecoration
                  (
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder
                      (
                      borderRadius: BorderRadius.circular(5),
                    )
                ),
              ),
            ),//2

            Padding//3
              (
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded
                    (
                    child: RaisedButton
                      (
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text
                        (
                        'SAVE', textScaleFactor: 1.5,
                      ),
                      onPressed: ()
                      {
                        setState(() {
                          debugPrint ("User Clicked Saved");
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(width: 50),
                  Expanded
                    (
                    child: RaisedButton
                      (
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text
                        (
                        'DELETE', textScaleFactor: 1.5,
                      ),
                      onPressed: ()
                      {
                        setState(() {
                          debugPrint ("User Clicked DELETE");
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),//3
          ],
        ),
      ),
    // ),
    );
  }
  void goBack()
  {
    Navigator.pop(context, true);
  }
  void setPassing(String value)
  {
    switch (value)
    {
      case  "successed":
        student.pass = 1;
        break;
      case  "failed":
        student.pass = 2;
        break;
    }
  }
  String getPassing(int value)
  {
    String pass;
    switch (value)
    {
      case 1:
        pass = _status[0];
        break;
      case 2:
        pass = _status[1];
        break;
    }
    return pass;
  }
  void _save() async
  {
    goBack();
    student.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (student.id == null)
      {
        result = await helper.insertStudent(student);
      } else  {
      result = await helper.updateStudent(student);
    }
    if ( result == 0)
      {
        showAlertDialog('Sorry', " Student not saved");
      } else {
      showAlertDialog('Congratulation',"Student has been saved successfully" );
    }
  }
  void showAlertDialog (String title, String msg)
  {
    AlertDialog alertDialog = AlertDialog (
      title: Text(title),
    content: Text(msg),
    );
    showDialog(context:  context, builder: (_) => alertDialog);
  }
  void _delete() async
  {
    goBack();
    if (student.id == null)
      {
        showAlertDialog('ok delete', "No student was deleted");
        return;
      }
    int result = await helper.deleteStudent(student.id);
    if (result == 0)
      {
        showAlertDialog('ok delete', "No student was deleted");
      } else {
      showAlertDialog('ok delete', "Student was deleted");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:students_list/screens/students_list.dart';
import 'package:students_list/screens/student_detail.dart';
import 'dart:async';
void main()
{runApp(MyApp());}
//{getFileContent();}
//getFileContent()
//{
//  String fileContent = "The Content";
//  print(fileContent);
//}
//getFileContent() async
//{
//  String fileContent = await download();
//  print('hi7');
//}
//Future<String> download()
//{
//  Future<String> content = Future.delayed(Duration(second: 6),()
//  {
//    return "heloo";
//  });
//}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "students_list",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: StudentsList(),
    );
  }
}

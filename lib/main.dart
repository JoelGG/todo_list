import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: Icon(Icons.add),
        ),
        body: Container(
          child: Tasks(),
        ),
      ),
    );
  }
}

class TasksState extends State<Tasks> {
  Iterable<Task> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        // TODO
      },
    );
  }

  Widget _buildRow (Task task) {
    return ListTile(
      title: Text(task.title),
    );
  }
}

class Tasks extends StatefulWidget {
  @override
  TasksState createState() => TasksState();
}


class Task {
  String title;
  DateTime date;

  Task({this.title, this.date});
}
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
      home: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Task> _todos = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodos(null);
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _todos.length,
          itemBuilder: (BuildContext _context, int i) {
            return(_buildRow(_todos[i]));
          },
        ),
      ),
    );
  }

  Widget _buildRow (Task task) {
    return ListTile(
      title: Text(task.title + "," + task.date.toString()),
    );
  }

  void _addTodos (Task t) {
    setState(() {
      _todos.add(new Task(date: DateTime.now(), title: "Todo " + _todos.length.toString()));
    });
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}


class Task {
  String title;
  DateTime date;

  Task({this.title, this.date});
}
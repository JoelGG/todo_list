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
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.date.toString()),
        trailing: Container(
          child: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _removeTodo(task);
            },
          )
        ),
      )
    );
  }

  void _addTodos (Task t) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("New Todo"),
        content: Container(
          height: 200.0,
          width: 300.0,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Card(
                child: TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
              ),
              ),
              Card(
                child: InkWell(
                  child: Text("Select Date"),
                  onTap: () {showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2222));},
                ),
              ),
              Card(
                child: InkWell(
                  child: Text("Select Date"),
                  onTap: () {showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2222));},
                ),
              ),
            ]
          ),
        ),
        
        actions: [
          FlatButton(onPressed: () { Navigator.of(context).pop(); }, child: Text("Cancel")),
          FlatButton(onPressed: null, child: Text("Accept")),
        ],
      );
    });
    
    setState(() {
      _todos.add(new Task(date: DateTime.now(), title: "Todo " + _todos.length.toString()));
    });
  }

  void _removeTodo (Task t) {
    setState(() {
      _todos.remove(t);
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
  Category category;

  Task({this.title, this.date, this.category});
}

class Category {
  Icon icon;
  String name;

  Category({this.icon, this.name});
}
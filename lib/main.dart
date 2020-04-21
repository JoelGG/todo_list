import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to flutter',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Task> _todos = new List();
  List<Task> _completed = new List();
  Widget page;
  int _pageIndex = 0;
  String _pageTitle;

  @override
  Widget build(BuildContext context) {
    switch (_pageIndex) {
      case 0:
        page = Container(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _todos.length,
            itemBuilder: (BuildContext _context, int i) {
              return(_buildRow(_todos[i]));
            },
          ),
        );
        _pageTitle = "Todo List";
        break;
      case 1:
        page = Container (
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _completed.length,
            itemBuilder: (BuildContext _context, int i) {
              Task t = _completed[_completed.length - i - 1];
              return(
                Card(
                  child: ListTile(
                    title: Text(t.title),
                    subtitle: Text(t.date.toString()),
                    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                      setState(() {
                        _completed.remove(t);
                      });
                      }),
                  ),
                )
              );
            },
          ),
        );
        _pageTitle = "Completed Tasks";
        break;
      case 2:
        page = Container(
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Theme"),
                  DropdownButton(items: null, onChanged: null),
                ],
              ),
              
            ],
          ),
        );
        _pageTitle = "Settings";
        break;
      default:
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            title: Text('Finished'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _pageIndex,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodos(null);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: page,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Widget _buildRow (Task task) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.date.toString()),
        trailing: Container(
          child: PopupMenuButton(
            onSelected: (String result) {
              if (result == "Remove") {
                _removeTodo(task);
              } else if (result == "Complete") {
                _completeTodo(task);
              } else if (result == "Edit") {
                //TODO
              } else {
                throw new ErrorDescription("Option selected not supported - give the developer an email to shout at him!");
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem(
              child: Text("Complete"),
              value: "Complete",
            ),
            const PopupMenuItem(
              child: Text("Edit"),
              value: "Edit",
            ),
            const PopupMenuItem(
              child: Text("Remove"),
              value: "Remove",
            ),
          ])
        ),
      )
    );
  }

  void _addTodos (Task t) {

    setState(() {
      _todos.add(new Task(date: DateTime.now(), title: "Todo " + _todos.length.toString()));
    });
  }

  void _removeTodo (Task t) {
    setState(() {
      _todos.remove(t);
    });
  }

  void _completeTodo (Task t) {
    setState(() {
      _todos.remove(t);
      _completed.add(t);
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
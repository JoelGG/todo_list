import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeData _currentTheme = Themes.blue;

  @override
  Widget build(BuildContext context) {
    HomeScreen _homeScreen = HomeScreen(
      onThemeChanged: (String s) {
        setState(() {
          switch (s) {
            case 'Light: Blue' :
              _currentTheme = Themes.blue;
              break;
            case 'Light: Green' :
              _currentTheme = Themes.green;
              break;
            case 'Dark: Deep Black' :
              _currentTheme = Themes.deepBlack;
              break;
            default:
          }
        });
      },
    );

    return MaterialApp(
      title: 'Welcome to flutter',
      theme: _currentTheme,
      home: _homeScreen,
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Task> _todos = new List();
  List<Task> _completed = new List();
  Widget page;
  int _pageIndex = 0;
  String _pageTitle;
  ThemeData currentTheme = Themes.blue;
  String themeDropdownValue = 'Light: Blue';

  Widget _mainScreen() {
    bool displayFloating = true;

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
        displayFloating = false;
        _pageTitle = "Completed Tasks";
        break;
      case 2:
        page = Container(
          child: Column(
            children: <Widget>[
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Theme",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )),
                  Expanded(child:DropdownButton<String>(
                    value: themeDropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      widget.onThemeChanged(newValue);
                      themeDropdownValue = newValue;
                    },
                    items: <String>['Light: Blue', 'Light: Green', 'Dark: Deep Black']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                    )),
                ],
              ),
              Divider(),
            ],
          ),
          padding: EdgeInsets.all(24),
        );
        displayFloating = false;
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

      floatingActionButton: displayFloating ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return _dataEntry(null, null);
          }));
        },
        label: Text("New task"),
        icon: Icon(Icons.add),
      ) : null,
      body: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainScreen();
  }

  Widget _dataEntry(int replaceAtIndex, Task defualtTask) {
    if (defualtTask == null) {
      defualtTask = Task(title: "", date: DateTime.now());
    }

    final _formKey = GlobalKey<FormState>();
    DateTime chosenDate = DateTime.now();
    final taskController = TextEditingController(text: defualtTask.title);
    final dateController = TextEditingController(text: ((replaceAtIndex == null) ? "" : defualtTask.date.year.toString() + '/' + addZeros(defualtTask.date.month.toString(), 2) + '/' + addZeros(defualtTask.date.minute.toString(), 2)));
    final timeController = TextEditingController(text: ((replaceAtIndex == null) ? "" : addZeros(defualtTask.date.hour.toString(), 2) + ':' + addZeros(defualtTask.date.minute.toString(), 2)));
    TimeOfDay chosenTime = TimeOfDay.now();

    

    return Scaffold(
      appBar: AppBar(
        title: Text("New todo"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.lightbulb_outline),
                  labelText: 'Task',
                ),
                controller: taskController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                
                },
              ),
              Divider(),
              InkWell(
                onTap: () async {
                  chosenDate = await showDatePicker(
                    context: context, 
                    initialDate: defualtTask.date, 
                    firstDate: DateTime(2000), 
                    lastDate: DateTime(2100),
                  );
                  if (chosenDate != null) {
                    dateController.text = chosenDate.year.toString() + "/" + chosenDate.month.toString() + "/" + chosenDate.day.toString();
                  }
                  

                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: new InputDecoration(icon: Icon(Icons.date_range),labelText: 'Date'),
                    maxLength: 10,
                    controller: dateController,
                    onSaved: (String val) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a date';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () async {
                  chosenTime = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay(hour: defualtTask.date.hour, minute: defualtTask.date.minute), 
                  );
                  if (chosenTime != null) {
                    timeController.text = chosenTime.hour.toString() + ":" + (chosenTime.minute.toString().length < 2 ? "0" + chosenTime.minute.toString() : chosenTime.minute.toString());
                  }
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: new InputDecoration(icon: Icon(Icons.access_time),labelText: 'Time'),
                    maxLength: 10,
                    controller: timeController,
                    onSaved: (String val) {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a time';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Divider(),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (replaceAtIndex != null) {
                      _editTodos(Task(title: taskController.text, date: DateTime(chosenDate.year, chosenDate.month, chosenDate.day, chosenTime.hour, chosenTime.minute)), replaceAtIndex);
                    } else {
                      _addTodos(Task(title: taskController.text, date: DateTime(chosenDate.year, chosenDate.month, chosenDate.day, chosenTime.hour, chosenTime.minute)));
                    }
                    Navigator.pop(context);
                    taskController.clear();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        padding: EdgeInsets.all(30),
      ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return _dataEntry(_todos.indexOf(task), Task(title: task.title, date: task.date, category: task.category));
                }));
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
      _todos.add(t);
    });
  }

  void _editTodos (Task t, int index) {
    setState(() {
      _todos[index] = t;
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
  Function onThemeChanged;

  HomeScreen({this.onThemeChanged});

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

class Themes {
  static ThemeData green = ThemeData(
    primaryColor: Colors.green,
    accentColor: Colors.lightGreen,
    backgroundColor: Colors.white,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: Colors.lightGreen,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),

    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(color: Colors.green),
    ),

  );

  static ThemeData blue = ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.blueAccent,
    backgroundColor: Colors.white,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: Colors.blueAccent,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

  );

  static ThemeData deepBlack = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.white,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: Colors.grey,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),

    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.red,
    )

  );
}

String addZeros(String toFormat, int intendedLength) {
  intendedLength = intendedLength.abs();
  
  while (toFormat.length < intendedLength) {
    toFormat = '0' + toFormat;
  }

  return toFormat;
}
import 'package:flutter/material.dart';

import 'package:reactive_fl_app/views/screens/todo_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: TodoList.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == TodoList.routeName) {
          return MaterialPageRoute(
              settings: RouteSettings(name: TodoList.routeName),
              builder: (_) => TodoList());
        }
      },
    );
  }
}

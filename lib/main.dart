import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:reactive_fl_app/app.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider(
            create: (_) => TodoDatabase(),
            builder: (_, __) => App(),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

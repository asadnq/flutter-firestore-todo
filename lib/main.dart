import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:reactive_fl_app/app.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => TodoDatabase(),
      builder: (_, __) => App(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reactive_fl_app/models/TodoModel.dart';

class TodoApiProvider {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> todosSnapshots() {
    return firestore.collection('todos').snapshots();
  }

  Future<void> addTodo(TodoModel todo) async {
    return await firestore.collection('todos').add(todo.toJson());
  }
}

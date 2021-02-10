import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:reactive_fl_app/models/TodoModel.dart';

class TodoDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _todoController = BehaviorSubject<Stream<List<TodoModel>>>();

  Stream<Stream<List<TodoModel>>> get todoList => _todoController.stream;

  void fetchTodoList({List<String> tags = const []}) {
    Query query = firestore.collection('todos');

    if (tags.isNotEmpty) {
      query = query.where('tags', arrayContainsAny: tags);
    }

    final snapshots = query.snapshots().map(
          (snapshots) => snapshots.docs
              .map((doc) => TodoModel.fromJson(doc.data()))
              .toList(),
        );

    _todoController.sink.add(snapshots);
  }

  Stream<Set<String>> get todoTagsStream {
    return firestore.collection('todos').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => TodoModel.fromJson(doc.data()).tags).fold(
            <String>[],
            (List<String> result, element) => [...result, ...element]).toSet());
  }

  Future<void> addTodo(TodoModel todo) async {
    final uuid = Uuid();
    final data = TodoModel.update(todo, id: uuid.v4());

    CollectionReference todos = firestore.collection('todos');

    await todos.doc(data.id).set(data.toJson());
  }

  dispose() {
    _todoController.close();
  }

  Future<void> updateTodo(TodoModel todo) async {
    await firestore.collection('todos').doc(todo.id).set(todo.toJson());
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:reactive_fl_app/models/TodoModel.dart';
import 'package:reactive_fl_app/resources/todo_api_provider.dart';
import 'package:reactive_fl_app/views/screens/create_todo.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';

class TodoList extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> filterTags = [];

  _showCreateTodo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CreateTodo(),
    );
  }

  @override
  initState() {
    super.initState();
    context.read<TodoDatabase>().fetchTodoList();
  }

  @override
  dispose() {
    super.dispose();
    context.read<TodoDatabase>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todos'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: _buildTagList(context),
          ),
          Expanded(
            child: _buildTodoList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showCreateTodo(context);
        },
      ),
    );
  }

  Widget _buildTagList(BuildContext context) {
    return StreamBuilder<Set<String>>(
      stream: context.read<TodoDatabase>().todoTagsStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final tags = snapshot.data.toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
            itemBuilder: (_, index) {
              final tag = tags[index];
              return InputChip(
                label: Text(tag),
                selected: filterTags.contains(tag),
                onPressed: () {
                  setState(() {
                    if (filterTags.contains(tag)) {
                      filterTags.remove(tag);
                    } else {
                      filterTags.add(tag);
                    }

                    context
                        .read<TodoDatabase>()
                        .fetchTodoList(tags: filterTags);
                  });
                },
              );
            },
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildTodoList(BuildContext context) {
    // final service = TodoApiProvider();
    // return StreamBuilder<List<TodoModel>>(
    // stream: context.watch<TodoDatabase>().todosStream(),
    // stream: db.todosStream(),
    return StreamBuilder<Stream<List<TodoModel>>>(
      stream: context.watch<TodoDatabase>().todoList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<List<TodoModel>>(
            stream: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                // if (snapshot.hasData) {
                // final todos = snapshot.data.docs
                //     .map((doc) => TodoModel.fromJson(doc.data()))
                //     .toList();
                final todos = snapshot.data;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (_, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: todo.tags.isEmpty
                          ? Text('no provided tags')
                          : Wrap(
                              children: todo.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                            ),
                    );
                  },
                );
              }

              return Text(
                  '${snapshot.connectionState.toString()} ${snapshot.hasData}');
            },
          );
        }

        return Container(
            color: Colors.amber,
            child: Text('${snapshot.connectionState.toString()}'));
      },
    );
  }

  /* Widget _buildTodoList(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: context.read<TodoDatabase>().todosStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          final todos = snapshot.data;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (_, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: todo.tags.isEmpty
                    ? Text('no provided tags')
                    : Wrap(
                        children: todo.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
              );
            },
          );
        }

        return Text(
            '${snapshot.connectionState.toString()} ${snapshot.hasData}');
      },
    );
  } */
}

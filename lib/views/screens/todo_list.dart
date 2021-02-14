import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_fl_app/constants/constants.dart';

import 'package:reactive_fl_app/models/TodoModel.dart';
import 'package:reactive_fl_app/views/screens/create_todo.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';
import 'package:reactive_fl_app/views/screens/todo_detail.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filterTags = [];
      });
    });
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 120,
              child: _buildTagList(context),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _buildTodoList(context),
            ),
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
    return ListView.separated(
      separatorBuilder: (_, __) => SizedBox(
        width: 20,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: Constants.todoTags.length,
      itemBuilder: (_, index) {
        final tag = Constants.todoTags[index];
        return InputChip(
          label: Text(tag),
          selected: filterTags.contains(tag),
          selectedColor: Colors.pinkAccent,
          onPressed: () {
            setState(() {
              if (filterTags.contains(tag)) {
                filterTags.remove(tag);
              } else {
                filterTags.add(tag);
              }

              context.read<TodoDatabase>().fetchTodoList(tags: filterTags);
            });
          },
        );
      },
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return StreamBuilder<Stream<List<TodoModel>>>(
      stream: context.watch<TodoDatabase>().todoList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return StreamBuilder<List<TodoModel>>(
            stream: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                final todos = snapshot.data;

                if (todos.isEmpty) {
                  return Center(child: Text('No items'));
                }

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (_, index) {
                    final todo = todos[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TodoDetail(todo: todo),
                            ));
                      },
                      title: Text(todo.title),
                      subtitle: todo.tags.isEmpty
                          ? Text('no provided tags')
                          : Wrap(
                              spacing: 20,
                              children: todo.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                            ),
                    );
                  },
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return Center(child: Text('unkown error occured'));
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

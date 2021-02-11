import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_fl_app/constants/constants.dart';

import 'package:reactive_fl_app/models/TodoModel.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';

class TodoDetail extends StatefulWidget {
  final TodoModel todo;
  TodoDetail({this.todo});

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    final TodoModel todo = widget.todo;
    titleInput.text = todo.title;
    descriptionInput.text = todo.description;
    tags = todo.tags;
  }

  _onPop() async {
    final newTodo = TodoModel(
      id: widget.todo.id,
      title: titleInput.text,
      description: descriptionInput.text,
      tags: tags,
    );

    await context.read<TodoDatabase>().updateTodo(newTodo.id, newTodo);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text('')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: titleInput,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionInput,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(
                height: 40,
              ),
              Wrap(
                children: Constants.todoTags
                    .map((tag) => Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: InputChip(
                            selected: tags.contains(tag),
                            selectedColor: Colors.pinkAccent,
                            label: Text(tag),
                            onPressed: () {
                              setState(() {
                                if (tags.contains(tag)) {
                                  setState(() {
                                    tags.remove(tag);
                                  });
                                } else {
                                  setState(() {
                                    tags.add(tag);
                                  });
                                }
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('delete'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (_) => Colors.red),
                  ),
                  onPressed: () async {
                    await context
                        .read<TodoDatabase>()
                        .deleteTodo(widget.todo.id);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        _onPop();
        return true;
      },
    );
  }
}

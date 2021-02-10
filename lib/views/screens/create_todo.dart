import 'package:flutter/material.dart';
import 'package:reactive_fl_app/models/TodoModel.dart';
import 'package:reactive_fl_app/resources/todo_database.dart';
import 'package:provider/provider.dart';

final todoTags = ['urgent', 'completed', 'on hold', 'started'];

class CreateTodo extends StatefulWidget {
  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: todoTags
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
              child: Text('Submit'),
              onPressed: () async {
                final newTodo = TodoModel(
                  title: titleInput.text,
                  description: descriptionInput.text,
                  tags: tags,
                );

                await context.read<TodoDatabase>().addTodo(newTodo);

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

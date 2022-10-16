import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_desktop/models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _tastTitleController = TextEditingController();
  TextEditingController _taskDescController = TextEditingController();

  List<Todo> _tasks = [];

  // create a function for print todo list

  @override
  Widget build(BuildContext context) {
    // getting screenSize
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 240, 240, 240),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_tasks[index].title),
                  Text(_tasks[index].description),
                  Row(
                    children: [
                      Checkbox(
                        value: _tasks[index].isDone,
                        onChanged: (value) {
                          setState(() {
                            _tasks[index].isDone = value;
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.pushNamed(context, '/add');
          showDialog(context: context, builder: addTodoDialog(context));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // create  a todo list with
  addTodoDialog(
    context,
  ) {
    var size = MediaQuery.of(context).size;

    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              title: const Text('Add Todo'),
              content: Container(
                height: size.height * .5,
                child: Column(
                  children: [
                    TextField(
                      controller: _tastTitleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Todo Title',
                      ),
                    ),
                    Container(
                      height: size.height * .2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: TextField(
                        maxLines: 50,
                        controller: _taskDescController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Todo Description',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _tastTitleController.text.isNotEmpty &&
                            _taskDescController.text.isNotEmpty
                        ? addTodo(context, _tastTitleController.text,
                            _taskDescController.text)
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter a task to save')));
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        });
  }

  onTapAdd() {
    addTodo(context, _tastTitleController.text, _taskDescController.text);
    Navigator.pop(context);
  }

  deleteTask(Todo item) {
    setState(() {
      _tasks.removeWhere((element) => element.title == "App");
    });
  }

  // method for adding new task to the _task list
  addTodo(context, String title, String desc) {
    setState(() {
      if (title.isNotEmpty && desc.isNotEmpty) {
        _tasks.add(Todo(title: title, description: desc));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Add a task to save")));
      }
    });
  }
}

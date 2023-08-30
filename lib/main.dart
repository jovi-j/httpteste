import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:httpteste/todo_model.dart';

Future<List<Todo>> fetchTodos() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/'));

  if (response.statusCode != 200) {
    throw Exception("Error");
  }

  List<Todo> todos = (json.decode(response.body) as List)
      .map((data) => Todo.fromJson(data))
      .toList();
  return todos;
}

void main() => runApp(const MyHomePage());

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Todo>> todos;

  @override
  void initState() {
    super.initState();
    todos = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo Fetch'),
        ),
        body: Center(
          child: FutureBuilder<List<Todo>>(
            future: todos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    for (var todo in snapshot.data!) TodoWidget(todo: todo),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(bottom: 10, top: 10)),
                    Text(
                      "Carregando TODOs...",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final Todo todo;
  const TodoWidget({super.key, required this.todo});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
            todo.completed ? Icons.done : Icons.access_time_filled_rounded),
        onPressed: () {},
      ),
      title: Text(todo.title, softWrap: true),
      trailing: const Icon(Icons.more_vert),
    );
  }
}

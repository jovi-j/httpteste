import 'package:httpteste/user_model.dart';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  User user;

  Todo(this.userId, this.id, this.title, this.completed, this.user);

  factory Todo.fromJson(Map<String, dynamic> json, User user) {
    return Todo(
        json['userId'], json['id'], json['title'], json['completed'], user);
  }
}

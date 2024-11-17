import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  // Internal list to store to-do items
  List<String> _todoList = [];

  // Getter to retrieve the list of to-do items
  List<String> get todoList => _todoList;

  void addTodoItem(String title) {
    _todoList.add(title);
    notifyListeners();
  }

  void removeTodoItem(String title) {
    _todoList.remove(title);
    notifyListeners();
  }

  // Optionally, you could add persistence logic here (e.g., using SharedPreferences or Hive)
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  List<String> _todoList = [];
  bool _isLoading = false;

  List<String> get todoList => _todoList;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore.collection('tasks').get();
      _todoList = snapshot.docs.map((doc) => doc['title'] as String).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodoItem(String title) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('tasks').add({'title': title});
      _todoList.add(title);
    } catch (e) {
      print('Error adding task: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeTodoItem(String title) async {
    _isLoading = true;
    notifyListeners();
    try {
      final docSnapshot = await _firestore
          .collection('tasks')
          .where('title', isEqualTo: title)
          .get();
      if (docSnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('tasks')
            .doc(docSnapshot.docs[0].id)
            .delete();
        _todoList.remove(title);
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}

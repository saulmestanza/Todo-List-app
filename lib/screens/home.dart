import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '../provider/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<LoginProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.separated(
            itemCount: todoProvider.todoList.length,
            itemBuilder: (context, index) {
              String title = todoProvider.todoList[index];
              return Dismissible(
                key: Key(title),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  Provider.of<TodoProvider>(context, listen: false)
                      .removeTodoItem(title);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$title removed'),
                  ));
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: _buildTodoItem(title),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(String title) {
    if (title.isNotEmpty) {
      Provider.of<TodoProvider>(context, listen: false).addTodoItem(title);
      _textFieldController.clear();
    }
  }

  Widget _buildTodoItem(String title) {
    return ListTile(
      title: Text(title),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your List'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  static const String _todosKey = 'todos';

  // Load todos from SharedPreferences
  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_todosKey);
    
    if (todosJson == null || todosJson.isEmpty) {
      return [];
    }

    final List<dynamic> todosList = json.decode(todosJson);
    return todosList.map((json) => Todo.fromJson(json)).toList();
  }

  // Save todos to SharedPreferences
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = json.encode(
      todos.map((todo) => todo.toJson()).toList(),
    );
    await prefs.setString(_todosKey, todosJson);
  }

  // Add new todo
  Future<void> addTodo(List<Todo> todos, Todo newTodo) async {
    todos.add(newTodo);
    await saveTodos(todos);
  }

  // Update existing todo
  Future<void> updateTodo(List<Todo> todos, String id, String title, String description) async {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].title = title;
      todos[index].description = description;
      await saveTodos(todos);
    }
  }

  // Delete todo
  Future<void> deleteTodo(List<Todo> todos, String id) async {
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }

  // Toggle todo completion status
  Future<void> toggleTodoStatus(List<Todo> todos, String id) async {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].isCompleted = !todos[index].isCompleted;
      await saveTodos(todos);
    }
  }
}

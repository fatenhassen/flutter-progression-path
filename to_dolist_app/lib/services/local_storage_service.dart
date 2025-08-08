// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class LocalStorageService {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> decodedTasks = json.decode(tasksString);
      return decodedTasks.map((json) => Task.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonTasks = tasks.map((task) => task.toJson()).toList();
    prefs.setString(_tasksKey, json.encode(jsonTasks));
  }
}
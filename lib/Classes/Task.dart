import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String? title;
  String? description;
  bool state;
  List<String>? tags;
  DateTime? dueBy;

  Task({
    this.title,
    this.description,
    this.state = false,
    this.tags,
    this.dueBy,
  });

  // Factory constructor to create a Task from JSON
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        description = json['description'] as String?,
        state = json['state'] as bool? ?? false,
        tags = (json['tags'] as List<dynamic>?)?.cast<String>(),
        dueBy = json['dueBy'] != null
            ? DateTime.parse(json['dueBy'] as String)
            : null;

  // Method to convert a Task to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'state': state,
        'tags': tags,
        'dueBy': dueBy?.toIso8601String(),
      };

  // Converts a list of tasks to a JSON string
  static String listToJson(List<Task> tasks) {
    return jsonEncode(tasks.map((task) => task.toJson()).toList());
  }

  // Converts a JSON string to a list of tasks
  static List<Task> jsonToList(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Task.fromJson(item)).toList();
  }

  // Save a list of tasks to SharedPreferences
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = listToJson(tasks);
    await prefs.setString('tasks', jsonString);
  }

  // Load a list of tasks from SharedPreferences
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('tasks');
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return jsonToList(jsonString);
  }
}

import 'dart:convert';

import 'package:filament/Classes/Task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Project {
  String name;
  List<Task> tasks;

  Project({required this.name, required this.tasks});

  static String listToJson(List<Project> projects) {
    return jsonEncode(projects.map((project) => project.toJson()).toList());
  }

  static List<Project> jsonToList(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map<Project>((item) => Project.fromJson(item)).toList();
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    List<Task> taskList = Task.jsonToList(json['tasks'] as String);
    return Project(
      name: json['name'] as String? ?? "New Project",
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'tasks': Task.listToJson(tasks),
      };

  static Future<void> saveProjects(List<Project> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String jsonString = Project.listToJson(projects);
      await prefs.setString('data', jsonString);
    } catch (e) {
      // Handle errors during save operation
      print('Error saving projects: $e');
    }
  }

  static Future<List<Project>> loadProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('data');
      if (jsonString != null && jsonString.isNotEmpty) {
        return Project.jsonToList(jsonString);
      }
    } catch (e) {
      // Handle errors during load operation
      print('Error loading projects: $e');
    }
    return [];
  }
}
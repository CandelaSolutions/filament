import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Task {
  String? title;
  String? description;
  bool state;
  List<String>? tags;
  List<Task>? subTasks;
  DateTime? startBy;
  DateTime? dueBy;

  Task(
      {this.title,
      this.description,
      this.state = false,
      this.tags,
      this.subTasks,
      this.startBy,
      this.dueBy});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        description = json['description'] as String?,
        state = json['state'] as bool? ?? false,
        tags = json['tags'] as List<String>?,
        subTasks = json['subTasks'] as List<Task>?,
        startBy = json['startBy'] as DateTime?,
        dueBy = json['dueBy'] as DateTime?;

  static Map<String, dynamic> toJson(Task value) => {
        'title': value.title,
        'description': value.description,
        'state': value.state,
        'tags': value.tags,
        'subTasks': listToString(value.subTasks),
        'startBy': value.startBy,
        'dueBy': value.dueBy,
      };

  static String? listToString(List<Task>? tasks) {
    if (tasks == null) {
      return null;
    }
    var jsonText = (tasks.map((task) => jsonEncode(Task.toJson(task))))
        .toList()
        .toString();
    jsonText = jsonText.replaceAll("(", "[");
    jsonText = jsonText.replaceAll(")", "]");
    return jsonText;
  }

  static Future<File> saveTasks(List<Task> tasks) async {
    final file = await _localFile;
    var jsonText = listToString(tasks);
    return file.writeAsString(jsonText as String, mode: FileMode.writeOnly);
  }

  static Future<List<Task>> loadTasks() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(contents);
      List<Task> tasks = [];
      for (int i = 0; i < jsonData.length; i++) {
        tasks.add(Task.fromJson(jsonData[i] as Map<String, dynamic>));
      }
      return tasks;
    } catch (e) {
      return [];
    }
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/tasks.json');
}

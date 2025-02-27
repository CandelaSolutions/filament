import 'dart:convert';

class Task {
  String? name;
  String? description;
  bool done;
  DateTime? due;

  Task({
    this.name,
    this.description,
    this.done = false,
    this.due,
  });

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        description = json['desc'] as String?,
        done = json['done'] as bool? ?? false,
        due = json['due'] != null
            ? DateTime.parse(json['d'] as String)
            : null;

  Map<String, dynamic> toJson() => {
        'name': name,
        'desc': description,
        'done': done,
        'due': due?.toIso8601String(),
      };

  static String listToJson(List<Task> tasks) {
    return jsonEncode(tasks.map((task) => task.toJson()).toList());
  }

  static List<Task> jsonToList(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Task.fromJson(item)).toList();
  }
}

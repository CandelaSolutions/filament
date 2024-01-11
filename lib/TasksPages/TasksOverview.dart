import 'package:filament/Classes/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Task> tasks = [];

bool addingTask = false;
final controller = TextEditingController();

class TasksOverviewPage extends StatefulWidget {
  @override
  State<TasksOverviewPage> createState() => _TasksOverviewPageState();
}

class _TasksOverviewPageState extends State<TasksOverviewPage> {
  var actionIcon = Icons.add;
  var grey = Color.fromARGB(255, 128, 128, 128);
  @override
  void initState() {
    loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tasks.isNotEmpty
          ? ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, item);
                  saveTasks();
                });
              },
              children: [
                for (int i = 0; i < tasks.length; i++)
                  CheckboxListTile(
                    key: ValueKey(tasks[i]),
                    value: tasks[i].state,
                    onChanged: (bool? state) {
                      setState(() {
                        tasks[i].state = state!;
                      });
                      saveTasks();
                    },
                    title:
                        Text(tasks[i].title == null ? "..." : tasks[i].title!),
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: SizedBox(
                      width: 95,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mode),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                tasks.removeAt(i);
                              });
                              saveTasks();
                            },
                            icon: Icon(Icons.delete),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: grey, size: 100),
                  Text("To-Do? More like To-Done!",
                      style: TextStyle(color: grey))
                ],
              ),
            )),
      floatingActionButton: Row(
        children: [
          Spacer(),
          SizedBox(
              width: 200.0,
              child: () {
                if (addingTask) {
                  return TextField(
                    autofocus: true,
                    controller: controller,
                    onChanged: (String? i) {
                      setState(() {
                        if (i == null || i.isEmpty) {
                          actionIcon = Icons.close;
                        } else {
                          actionIcon = Icons.check;
                        }
                      });
                    },
                    onEditingComplete: onTaskActionButtonPressed,
                  );
                }
              }()),
          SizedBox(width: 20.0),
          SizedBox(
              child: FloatingActionButton(
            onPressed: onTaskActionButtonPressed,
            tooltip: 'Add Task',
            child: Icon(actionIcon),
          )),
        ],
      ),
    );
  }

  void onTaskActionButtonPressed() {
    setState(() {
      if (addingTask) {
        var task = controller.text;
        if (task.isNotEmpty) {
          tasks.add(Task(title: task));
        }
        actionIcon = Icons.add;
      } else {
        controller.clear();
        actionIcon = Icons.close;
      }
      addingTask = !addingTask;
    });
    saveTasks();
  }

  void saveTasks() {
    Task.saveTasks(tasks);
  }

  void loadTasks() {
    Task.loadTasks().then((List<Task> result) {
      setState(() {
        tasks += result;
      });
    });
  }
}

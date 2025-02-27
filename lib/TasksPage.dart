import 'package:filament/Classes/Project.dart';
import 'package:filament/Classes/Task.dart';
import 'package:flutter/material.dart';

List<Project> projects = [];

bool addingTask = false;
final controller = TextEditingController();

class TasksPage extends StatefulWidget {
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  var actionIcon = Icons.add;
  var grey = Color.fromARGB(255, 128, 128, 128);
  @override
  void initState() {
    loadProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: projects[0].tasks.isNotEmpty
          ? ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = projects[0].tasks.removeAt(oldIndex);
                  projects[0].tasks.insert(newIndex, item);
                  saveProjects();
                });
              },
              children: [
                for (int i = 0; i < projects[0].tasks.length; i++)
                  CheckboxListTile(
                    key: ValueKey(projects[0].tasks[i]),
                    value: projects[0].tasks[i].done,
                    onChanged: (bool? state) {
                      setState(() {
                        projects[0].tasks[i].done = state!;
                      });
                      saveProjects();
                    },
                    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(projects[0].tasks[i].name == null ? "..." : projects[0].tasks[i].name!), Text("Date", style: TextStyle(color: grey,),)]),
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
                                projects[0].tasks.removeAt(i);
                              });
                              saveProjects();
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
          projects[0].tasks.add(Task(name: task));
        }
        actionIcon = Icons.add;
      } else {
        controller.clear();
        actionIcon = Icons.close;
      }
      addingTask = !addingTask;
    });
    saveProjects();
  }

  void saveProjects() {
    Project.saveProjects(projects);
  }

  void loadProjects() {
    Project.loadProjects().then((List<Project> result) {
      setState(() {
        projects += result;
        if (projects.isEmpty || result.runtimeType == Null) {
          projects.add(Project(name: "Sample", tasks: []));
        }
      });
    });
  }
}
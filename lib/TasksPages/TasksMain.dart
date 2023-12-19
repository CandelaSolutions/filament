import 'package:flutter/material.dart';
import 'package:filament/NavigationRail.dart';
import 'package:filament/BottomNavigationBar.dart';
import 'package:filament/TasksPages/TasksOverview.dart';
import 'package:filament/TasksPages/TasksDaily.dart';
import 'package:filament/TasksPages/TasksPersonal.dart';
import 'package:filament/TasksPages/TasksWork.dart';

class TasksPage extends StatefulWidget {
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      TasksOverviewPage(),
      TasksDailyPage(),
      TasksPersonalPage(),
      TasksWorkPage(),
    ];
    if (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
        1) {
      return landscapeScaffold(context, pages);
    } else {
      return portraitScaffold(context, pages);
    }
  }

  Scaffold portraitScaffold(BuildContext context, List<Widget> pages) {
    var theme = Theme.of(context);
    return Scaffold(
        bottomNavigationBar: navBar(
          theme,
          1,
          selectedIndex,
          (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          [
            navBarItem(Icons.checklist, "Overview", theme, 1),
            navBarItem(Icons.event_repeat, "Habit Builder", theme, 1),
            navBarItem(Icons.people, "Personal", theme, 1),
            navBarItem(Icons.engineering, "Work", theme, 1)
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ));
  }

  Scaffold landscapeScaffold(BuildContext context, List<Widget> pages) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: navRail(
            theme,
            1,
            selectedIndex,
            (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            [
              railDestination(Icons.checklist, "Overview", theme, 1),
              railDestination(Icons.event_repeat, "Habit Builder", theme, 1),
              railDestination(Icons.people, "Personal", theme, 1),
              railDestination(Icons.engineering, "Work", theme, 1),
            ],
          )),
          Expanded(
              child: IndexedStack(
            index: selectedIndex,
            children: pages,
          )),
        ],
      ),
    );
  }
}

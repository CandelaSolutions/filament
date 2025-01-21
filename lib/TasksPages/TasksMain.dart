import 'package:flutter/material.dart';
import 'package:filament/Classes/NavigationRail.dart';
import 'package:filament/Classes/BottomNavigationBar.dart';
import 'package:filament/TasksPages/TasksOverview.dart';
import 'package:filament/TasksPages/TasksRoutine.dart';

class TasksPage extends StatefulWidget {
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  var selectedIndex = 0;
  bool landscape = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      TasksOverviewPage(),
      TasksRoutinePage(),
    ];

    var theme = Theme.of(context);

    if (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
        1) {
      landscape = false;
    } else {
      landscape = true;
    }

    return Scaffold(
        bottomNavigationBar: taskNavBar(theme, landscape),
        body: Row(
          children: [
            if (!landscape) SafeArea(child: taskNavRail(theme)),
            Expanded(
                child: IndexedStack(
              index: selectedIndex,
              children: pages,
            )),
          ],
        ));
  }

  BottomNavigationBar? taskNavBar(ThemeData theme, bool landscape) {
    if (landscape) {
      return navBar(
        theme,
        1,
        selectedIndex,
        (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        [
          navBarItem(Icons.checklist, "Tasks", theme, 1),
          navBarItem(Icons.event_repeat, "Habit Builder", theme, 1),
        ],
      );
    }
    return null;
  }

  NavigationRail taskNavRail(ThemeData theme) {
    return navRail(
      theme,
      1,
      selectedIndex,
      (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      [
        railDestination(Icons.checklist, "Tasks", theme, 1),
        railDestination(Icons.event_repeat, "Habit Builder", theme, 1),
      ],
    );
  }
}

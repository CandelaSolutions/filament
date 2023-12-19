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

Widget page(var selectedIndex) {
  Widget page;
  switch (selectedIndex) {
    case 0:
      page = TasksOverviewPage();
    case 1:
      page = TasksDailyPage();
    case 2:
      page = TasksPersonalPage();
    case 3:
      page = TasksWorkPage();
    default:
      throw UnimplementedError('no widget for $selectedIndex');
  }
  return page;
}

class _TasksPageState extends State<TasksPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
        1) {
      return landscapeScaffold(context);
    } else {
      return portraitScaffold(context);
    }
  }

  Scaffold portraitScaffold(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: navBar(
        theme,
        0,
        selectedIndex,
        (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        [
          navBarItem(Icons.home, "Home", theme, 0),
          navBarItem(Icons.calendar_today, "Calendar", theme, 0),
          navBarItem(Icons.checklist, "Tasks", theme, 0),
          navBarItem(Icons.contact_mail, "Messages", theme, 0)
        ],
      ),
      body: page(selectedIndex),
    );
  }

  Scaffold landscapeScaffold(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: navRail(
            theme,
            0,
            selectedIndex,
            (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            [
              railDestination(Icons.home, "Home", theme, 0),
              railDestination(Icons.calendar_today, "Calendar", theme, 0),
              railDestination(Icons.checklist, "Tasks", theme, 0),
              railDestination(Icons.contact_mail, "Messages", theme, 0)
            ],
          )),
          Expanded(
            child: page(selectedIndex),
          ),
        ],
      ),
    );
  }
}

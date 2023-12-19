import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filament/NavigationRail.dart';
import 'package:filament/BottomNavigationBar.dart';
import 'package:filament/LandingPage.dart';
import 'package:filament/CalendarPage.dart';
import 'package:filament/TasksPages/TasksMain.dart';
import 'package:filament/MessagesPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Filament',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.green.shade100)),
        home: ReadyScene(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}

class ReadyScene extends StatefulWidget {
  @override
  State<ReadyScene> createState() => _ReadySceneState();
}

class _ReadySceneState extends State<ReadyScene> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      LandingPage(),
      CalendarPage(),
      TasksPage(),
      MessagesPage()
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
              child: IndexedStack(
            index: selectedIndex,
            children: pages,
          )),
        ],
      ),
    );
  }
}

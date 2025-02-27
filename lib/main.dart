import 'package:candela_standards/candela_standard_app.dart';
import 'package:candela_standards/candela_standard_app_profile_prefabs.dart';
import 'package:filament/TasksPage.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:filament/Widgets/NavigationRail.dart';
import 'package:filament/Widgets/BottomNavigationBar.dart';
import 'package:filament/LandingPage.dart';
import 'package:filament/CalendarPage.dart';

void main() {
  runApp(App());
  doWhenWindowReady(() {
    appWindow.title = filament.text;
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CandelaStandardAppWindow(
      profile: filament,
      child: ReadyScene(),
    );
  }
}

class ReadyScene extends StatefulWidget {
  @override
  State<ReadyScene> createState() => _ReadySceneState();
}

class _ReadySceneState extends State<ReadyScene> {
  var selectedIndex = 0;
  bool landscape = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      LandingPage(),
      CalendarPage(),
      TasksPage(),
    ];

    var theme = Theme.of(context);

    if (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
        1) {
      landscape = false;
    } else {
      landscape = true;
    }

    return Scaffold(
        bottomNavigationBar: mainNavBar(theme, landscape),
        body: Row(
          children: [
            if (!landscape) SafeArea(child: mainNavRail(theme)),
            Expanded(
                child: IndexedStack(
              index: selectedIndex,
              children: pages,
            )),
          ],
        ));
  }

  NavigationRail mainNavRail(ThemeData theme) {
    return navRail(
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
      ],
    );
  }

  BottomNavigationBar? mainNavBar(ThemeData theme, bool landscape) {
    if (landscape) {
      if (selectedIndex == 4) {
        selectedIndex = 0;
      }
      return navBar(
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
        ],
      );
    }
    return null;
  }
}

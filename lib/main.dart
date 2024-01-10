import 'package:filament/TasksPages/TasksOverview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:filament/Classes/NavigationRail.dart';
import 'package:filament/Classes/BottomNavigationBar.dart';
import 'package:filament/LandingPage.dart';
import 'package:filament/CalendarPage.dart';
import 'package:filament/TasksPages/TasksMain.dart';
import 'package:filament/MessagesPage.dart';

void main() {
  runApp(App());
  doWhenWindowReady(() {
    appWindow.title = "Filament";
    appWindow.show();
  });
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
              colorScheme: ColorScheme.dark(
                  primary: Color.fromARGB(255, 224, 134, 0),
                  secondary: Color.fromARGB(255, 239, 191, 56))),
          home: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromARGB(255, 224, 134, 0),
                  Color.fromARGB(255, 239, 191, 56),
                ],
                    stops: [
                  0,
                  1
                ])),
            child: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(
                          child: MoveWindow(
                              child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Icon(Icons.emoji_objects),
                          ),
                          Text("Filament",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal))
                        ],
                      ))),
                      WindowButtons()
                    ],
                  ),
                ),
                Expanded(child: TasksOverviewPage()),
              ],
            ),
          )),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(
              mouseOver: Color.fromARGB(255, 224, 134, 0),
              iconNormal: Color.fromARGB(255, 255, 255, 255)),
        ),
        MaximizeWindowButton(
          colors: WindowButtonColors(
              mouseOver: Color.fromARGB(255, 224, 134, 0),
              iconNormal: Color.fromARGB(255, 255, 255, 255)),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
              iconNormal: Color.fromARGB(255, 255, 255, 255)),
        )
      ],
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
  bool landscape = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      LandingPage(),
      CalendarPage(),
      TasksPage(),
      MessagesPage()
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
        railDestination(Icons.contact_mail, "Messages", theme, 0)
      ],
    );
  }

  BottomNavigationBar? mainNavBar(ThemeData theme, bool landscape) {
    if (landscape) {
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
          navBarItem(Icons.contact_mail, "Messages", theme, 0)
        ],
      );
    }
    return null;
  }
}

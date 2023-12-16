import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filament/NavigationRail.dart';
import 'package:filament/LandingPage.dart';
import 'package:filament/CalendarPage.dart';

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
    final theme = Theme.of(context);
    final backgroundShade = theme.colorScheme.background;

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: navRail(
              theme,
              selectedIndex,
              (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: backgroundShade,
              child: page(selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}

Widget page(var selectedIndex) {
  Widget page;
  switch (selectedIndex) {
    case 0:
      page = LandingPage();
    case 1:
      page = CalendarPage();
    default:
      throw UnimplementedError('no widget for navRail.selectedIndex');
  }
  return page;
}

import 'package:filament/Widgets/Timer.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> landingWidgets = [
      Spacer(),
      Expanded(child: PomodoroTimer()),
      Expanded(
        child: Center(
          child: OutlinedButton(
            style: ButtonStyle(
                side: WidgetStatePropertyAll(
                    BorderSide(color: theme.colorScheme.primary))),
            onPressed: () {},
            child: Row(
              children: [Icon(Icons.casino), Text("I'm feeling lucky")],
            ),
          ),
        ),
      ),
    ];

    if (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height >
        1) {
      return Row(
        children: [
          Expanded(
            child: landingWidgets[0],
          ),
          Expanded(
            child: Column(
              children: [landingWidgets[1], landingWidgets[2]],
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [landingWidgets[1], landingWidgets[2]],
      );
    }
  }
}

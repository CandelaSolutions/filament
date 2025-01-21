import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class PomodoroTimer extends StatefulWidget {
  PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  final NumberFormat timeFormat = NumberFormat("00");

  int time = 25 * 60; // 25 minutes in seconds
  Timer? timer;

  void startTime() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (time > 0) {
          setState(() {
            time--;
          });
        } else {
          timer.cancel();
        }
      });
    } else if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    setState(() {});
  }

  void resetTime() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    setState(() {
      time = 25 * 60; // Reset to 25 minutes
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    return Stack(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                value: time / (25 * 60), // Update progress indicator
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "${(time / 60).toInt()}:${timeFormat.format(time % 60)}",
            style: style,
          ),
        ),
        Container(
          alignment:
              Alignment.lerp(Alignment.bottomCenter, Alignment.center, 0.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: startTime,
                child: timer == null || !timer!.isActive
                    ? Icon(Icons.play_arrow)
                    : Icon(Icons.pause),
              ),
              SizedBox(width: 20),
              FilledButton(
                onPressed: resetTime,
                child: Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

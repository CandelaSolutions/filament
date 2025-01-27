import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroTimer extends StatefulWidget {
  PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  final NumberFormat timeFormat = NumberFormat("00");
  Timer? timer;
  PomodoroTimerStateContainer state = PomodoroTimerStateContainer();

  @override
  void initState() {
    super.initState();
    state.load().then((value) {
      setState(() {
        if (state.active) {
          startTime();
        }
      });
    });
  }

  void startTime() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        tick();
      });
      setState(() {
        state.active = true;
      });
      state.save();
    } else if (timer != null && timer!.isActive) {
      setState(() {
        state.active = false;
      });
      state.save();
      timer!.cancel();
    }
  }

  void tick() {
    if (state.time > 0) {
      setState(() {
        state.time--;
      });
    } else {
      setState(() {
        state.rest = !state.rest;
      });
      if (state.rest) {
        setState(() {
          state.time = 5 * 60;
        });
      } else {
        setState(() {
          state.time = 25 * 60;
        });
      }
    }
    state.save();
  }

  void resetTime() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    setState(() {
      state.rest = false;
      state.time = 25 * 60;
      state.active = false; // Reset to 25 minutes
    });
    state.save();
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
                value: state.time / (25 * 60),
                color: !state.rest
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary, // Update progress indicator
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "${(state.time / 60).toInt()}:${timeFormat.format(state.time % 60)}\n${state.rest ? "Rest" : "Work"}",
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
                child:
                    state.active ? Icon(Icons.pause) : Icon(Icons.play_arrow),
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

class PomodoroTimerStateContainer {
  late int time;
  late bool active;
  late bool rest;

  static const String timeKey = "timer.Value";
  static const String activeKey = "timer.Active";
  static const String restKey = "timer.Rest";

  Future<void> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      time = prefs.getInt(timeKey) ?? 25 * 60;
      active = prefs.getBool(activeKey) ?? false;
      rest = prefs.getBool(restKey) ?? false;
    } catch (e) {
      time = 25 * 60;
      active = false;
      rest = false;
    }
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(timeKey, time);
    await prefs.setBool(activeKey, active);
    await prefs.setBool(restKey, rest);
  }
}

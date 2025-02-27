import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_selector/number_selector.dart';
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
          state.time = state.timeRest * 60;
        });
      } else {
        setState(() {
          state.time = state.timeWork * 60;
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
      state.time = state.timeWork * 60;
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
    final smallStyle = TextStyle(color: theme.colorScheme.onSurface);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      value: !state.rest
                          ? (state.time / (state.timeWork * 60))
                          : (state.time / (state.timeRest * 60)),
                      color: !state.rest
                          ? theme.colorScheme.primary
                          : theme.colorScheme
                              .secondary, // Update progress indicator
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
                alignment: Alignment.lerp(
                    Alignment.bottomCenter, Alignment.center, 0.25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: startTime,
                      child: state.active
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                    ),
                    if (state.time != state.timeWork * 60) SizedBox(width: 20),
                    if (state.time != state.timeWork * 60)
                      FilledButton(
                        onPressed: resetTime,
                        child: Icon(Icons.refresh),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Spacer(),
            Text(
              "Work:",
              style: smallStyle,
            ),
            NumberSelector.plain(
              current: state.timeWork,
              min: 1,
              showMinMax: false,
              iconColor: style.color!,
              textStyle: smallStyle,
              onUpdate: (number) {
                setState(() {
                  state.timeWork = number;
                });
                state.save();
              },
            ),
            Spacer(),
            Text(
              "Rest:",
              style: smallStyle,
            ),
            NumberSelector.plain(
              current: state.timeRest,
              min: 1,
              showMinMax: false,
              iconColor: style.color!,
              textStyle: smallStyle,
              onUpdate: (number) {
                setState(() {
                  state.timeRest = number;
                });
                state.save();
              },
            ),
            Spacer(),
          ],
        )
      ],
    );
  }
}

class PomodoroTimerStateContainer {
  late int time;
  late int timeWork;
  late int timeRest;
  late bool active;
  late bool rest;

  static const String timeKey = "timer.Value";
  static const String timeWorkKey = "timer.Value.Work";
  static const String timeRestKey = "timer.Value.Rest";
  static const String activeKey = "timer.Active";
  static const String restKey = "timer.Rest";

  Future<void> load() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      timeWork = prefs.getInt(timeWorkKey) ?? 25;
      timeRest = prefs.getInt(timeRestKey) ?? 5;
      time = prefs.getInt(timeKey) ?? timeWork * 60;
      active = prefs.getBool(activeKey) ?? false;
      rest = prefs.getBool(restKey) ?? false;
    } catch (e) {
      timeWork = 25;
      timeRest = 5;
      time = timeWork * 60;
      active = false;
      rest = false;
    }
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(timeKey, time);
    await prefs.setInt(timeWorkKey, timeWork);
    await prefs.setInt(timeRestKey, timeRest);
    await prefs.setBool(activeKey, active);
    await prefs.setBool(restKey, rest);
  }
}

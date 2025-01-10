import 'dart:async';
import 'package:latest_try_ct/database/db_query.dart';
import 'package:latest_try_ct/handlers/calendar_handler.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:latest_try_ct/database/db_CRUD.dart';

class TimerHandler with ChangeNotifier {
  TimerHandler._internal();
  static final TimerHandler _instance = TimerHandler._internal();
  factory TimerHandler() {
    return _instance;
  }

  bool isCountdownOn = false;
  Timer? _backgroundTimer;

  Duration _initialDuration = Duration.zero;
  Duration _prevDuration = Duration.zero;
  Duration _currentDuration = Duration.zero;

  Duration get currentDuration => _currentDuration;
  Duration get initialDuration => _initialDuration;

  void startBackgroundTimer() {
    _backgroundTimer?.cancel;
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isCountdownOn && _currentDuration > Duration.zero) {
        _currentDuration -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void toggleCountdown() {
    if (initialDuration == Duration.zero) {
      return;
    }
    isCountdownOn = !isCountdownOn;
    if (isCountdownOn == false) {
      int minutesInBetween =
          _prevDuration.inMinutes - currentDuration.inMinutes;
      CalendarHandler().today!.numOfMinutes += minutesInBetween;
      updateDay(CalendarHandler().today!);
      CalendarHandler().thisWeek!.numOfMinutes += minutesInBetween;
      updateWeek(CalendarHandler().thisWeek!);
      _prevDuration = _currentDuration;
    }
    notifyListeners();
  }

  Future<void> setCountDownDuration(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    if (pickedTime != null) {
      _initialDuration =
          Duration(hours: pickedTime.hour, minutes: pickedTime.minute);
    }
    _currentDuration = _initialDuration;
    _prevDuration = _initialDuration;
    notifyListeners();
  }

  String formattedTimeString(Duration givenDuration) {
    int hours = givenDuration.inHours % 24;
    int minutes = givenDuration.inMinutes % 60;
    int seconds = givenDuration.inSeconds % 60;

    String formatSeconds = seconds < 10 ? "0$seconds" : "$seconds";
    String formatMinutes = minutes < 10 ? "0$minutes" : "$minutes";
    String formatHours = hours < 10 ? "0$hours" : "$hours";

    return "$formatHours:$formatMinutes:$formatSeconds";
  }
}

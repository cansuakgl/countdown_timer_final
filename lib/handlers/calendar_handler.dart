import 'dart:async';
import 'package:latest_try_ct/database/db_query.dart';
import '../database/data_models.dart';
import 'dart:core';
import 'package:latest_try_ct/database/db_CRUD.dart';
import 'package:week_number/iso.dart';

class CalendarHandler {
  CalendarHandler._internal();
  static final CalendarHandler _instance = CalendarHandler._internal();
  factory CalendarHandler() {
    return _instance;
  }
  Day? today;
  Week? thisWeek;

  Future<void> setDate() async {
    DateTime todayAsDateTime = DateTime.now();
    int todaysDayId = getGivenDateAsInt(todayAsDateTime);
    if (todaysDayId != DbQuery().lastDay!.dayId) {
      today = Day(
          dayId: todaysDayId,
          dayNum: todayAsDateTime.day,
          belongsToWeek: todayAsDateTime.weekNumber,
          numOfMinutes: 0,
          numOfTasks: 0);
      insertDay(today!);
    } else {
      today = DbQuery().lastDay;
    }
    if (todayAsDateTime.weekNumber != DbQuery().lastWeek!.weekId) {
      thisWeek = Week(
          weekId: todayAsDateTime.weekNumber, numOfMinutes: 0, numOfTasks: 0);
      insertWeek(thisWeek!);
    } else {
      thisWeek = DbQuery().lastWeek;
    }
  }

  void updateDateEveryMin() {
    Timer.periodic(const Duration(minutes: 1), (newTimer) {
      DateTime todayAsDateTime = DateTime.now();
      if (today != null) {
        if (today!.dayId != getGivenDateAsInt(todayAsDateTime)) {
          today = Day(
              dayId: getGivenDateAsInt(todayAsDateTime),
              dayNum: todayAsDateTime.day,
              belongsToWeek: todayAsDateTime.weekNumber,
              numOfMinutes: 0,
              numOfTasks: 0);
          insertDay(today!);
          if (DateTime.now().weekday == DateTime.monday) {
            thisWeek = Week(
                weekId: getGivenDateAsInt(todayAsDateTime),
                numOfMinutes: 0,
                numOfTasks: 0);
            insertWeek(thisWeek!);
          }
        }
      }
    });
  }

  int getGivenDateAsInt(DateTime givenDate) {
    return int.parse(
        '${givenDate.year}${givenDate.month.toString().padLeft(2, '0')}${givenDate.day.toString().padLeft(2, '0')}');
  }
}

import 'package:flutter/material.dart';
import 'package:latest_try_ct/database/data_models.dart';
import 'package:latest_try_ct/database/database_handler.dart';
import 'package:latest_try_ct/database/db_CRUD.dart';
import 'package:sqflite/sqflite.dart';
import 'package:latest_try_ct/handlers/calendar_handler.dart';

class DbQuery with ChangeNotifier {
  DbQuery._internal();
  static final DbQuery _instance = DbQuery._internal();
  factory DbQuery() {
    return _instance;
  }
  Day? lastDay;
  Week? lastWeek;

  List<Task> taskList = [];
  List<Week> weekList = [];
  List<Day> dayList = [];

  Future<void> fetchAllTasks() async {
    final Database db = await DatabaseHandler().getDatabase;
    final List<Map<String, dynamic>> taskMaps = await db.query('tasks_table');
    taskList = List.generate(taskMaps.length, (i) {
      return Task(
        taskId: taskMaps[i]['task_id'],
        isCompleted: taskMaps[i]['is_completed'],
        taskString: taskMaps[i]['task_string'],
      );
    });
  }

  Future<void> fetchLastFourWeeks() async {
    final Database db = await DatabaseHandler().getDatabase;
    final List<Map<String, dynamic>> weekMaps =
        await db.query('weeks_table', orderBy: 'week_id DESC', limit: 4);
    List<Week> tempList = List.generate(weekMaps.length, (i) {
      return Week(
        weekId: weekMaps[i]['week_id'],
        numOfMinutes: weekMaps[i]['num_of_minutes'],
        numOfTasks: weekMaps[i]['num_of_tasks'],
      );
    });
    if (tempList.isNotEmpty) {
      lastWeek = tempList[0];
      Iterable<Week> reversedList = tempList.reversed;
      weekList = reversedList.toList();
    }
  }

  Future<void> fetchLastSevenDays() async {
    final Database db = await DatabaseHandler().getDatabase;
    final List<Map<String, dynamic>> dayMaps =
        await db.query('days_table', orderBy: 'day_id DESC', limit: 7);
    List<Day> tempList = List.generate(dayMaps.length, (i) {
      return Day(
        dayId: dayMaps[i]['day_id'],
        dayNum: dayMaps[i]['day_num'],
        belongsToWeek: dayMaps[i]['belongs_to_week'],
        numOfMinutes: dayMaps[i]['num_of_minutes'],
        numOfTasks: dayMaps[i]['num_of_tasks'],
      );
    });
    if (tempList.isNotEmpty) {
      lastDay = tempList[0];
      Iterable<Day> reversedList = tempList.reversed;
      dayList = reversedList.toList();
    }
  }
}

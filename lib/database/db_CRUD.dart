// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:latest_try_ct/database/database_handler.dart';
import 'package:latest_try_ct/database/data_models.dart';
import 'package:sqflite/sqflite.dart';

Future<void> insertWeek(Week week) async {
  Database database = await DatabaseHandler().getDatabase;
  final weekMap = week.toMap();
  await database.insert(
    'weeks_table',
    weekMap,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertDay(Day day) async {
  Database database = await DatabaseHandler().getDatabase;
  final dayMap = day.toMap();
  await database.insert(
    'days_table',
    dayMap,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertTask(Task task) async {
  Database database = await DatabaseHandler().getDatabase;
  final taskMap = task.toMap();
  if (task.taskId == null) {
    taskMap.remove('task_id');
  }
  await database.insert(
    'tasks_table',
    taskMap,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateWeek(Week week) async {
  Database database = await DatabaseHandler().getDatabase;
  await database.update(
    'weeks_table',
    week.toMap(),
    where: 'week_id = ?',
    whereArgs: [week.weekId],
  );
}

Future<void> updateDay(Day day) async {
  Database database = await DatabaseHandler().getDatabase;
  await database.update(
    'days_table',
    day.toMap(),
    where: 'day_id = ?',
    whereArgs: [day.dayId],
  );
}

Future<void> updateTask(Task task) async {
  Database database = await DatabaseHandler().getDatabase;
  await database.update(
    'tasks_table',
    task.toMap(),
    where: 'task_id = ?',
    whereArgs: [task.taskId],
  );
}

Future<void> deleteTask(Task task) async {
  Database database = await DatabaseHandler().getDatabase;
  await database.delete(
    'tasks_table',
    where: 'task_id = ?',
    whereArgs: [task.taskId],
  );
}

Future<void> deleteWeek(Week week) async {
  Database database = await DatabaseHandler().getDatabase;
  await database.delete(
    'weeks_table',
    where: 'week_id = ?',
    whereArgs: [week.weekId],
  );
}

/*
  weekId -> index of the week out of 52 weeks of the year
  dayId -> date of the day in the form of 'YYYYMMDD'
  tasksId -> incrementing integers starting from 0 
*/

class Week {
  int weekId;
  int numOfMinutes = 0;
  int numOfTasks = 0;

  Week({
    required this.weekId,
    required this.numOfMinutes,
    required this.numOfTasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'week_id': weekId,
      'num_of_minutes': numOfMinutes,
      'num_of_tasks': numOfTasks,
    };
  }
}

class Day {
  int dayId;
  int dayNum;
  int belongsToWeek;
  int numOfMinutes = 0;
  int numOfTasks = 0;
  Day({
    required this.dayId,
    required this.dayNum,
    required this.belongsToWeek,
    required this.numOfMinutes,
    required this.numOfTasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'day_id': dayId,
      'day_num': dayNum,
      'belongs_to_week': belongsToWeek,
      'num_of_Minutes': numOfMinutes,
      'num_of_tasks': numOfTasks,
    };
  }
}

class Task {
  int? taskId;
  int? isCompleted = 0;
  String taskString;

  Task({
    this.taskId,
    this.isCompleted,
    required this.taskString,
  });

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'is_completed': isCompleted,
      'task_string': taskString,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:latest_try_ct/database/db_CRUD.dart';
import 'package:latest_try_ct/handlers/calendar_handler.dart';
import 'package:latest_try_ct/theme.dart';
import '../database/data_models.dart';
import 'package:latest_try_ct/database/db_query.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    refetchTasks();
    super.initState();
  }

  Future<void> refetchTasks() async {
    await DbQuery().fetchAllTasks();
    setState(() {});
  }

  void _addTask(String taskString) {
    Task newTask = Task(
      taskString: taskString,
      isCompleted: 0,
    );
    insertTask(newTask);
    refetchTasks();
  }

  void _toggleTask(Task task) {
    (task.isCompleted == 1) ? task.isCompleted = 0 : task.isCompleted = 1;
    if (task.isCompleted == 1) {
      CalendarHandler().today!.numOfTasks++;
      CalendarHandler().thisWeek!.numOfTasks++;
    } else {
      CalendarHandler().today!.numOfTasks--;
      CalendarHandler().thisWeek!.numOfTasks--;
    }
    updateTask(task);
    refetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: DbQuery().taskList.length,
        itemBuilder: (context, index) {
          final currentTask = DbQuery().taskList[index];
          return ListTile(
            onLongPress: () => taskDeletionDialog(context, currentTask),
            iconColor: ThemeColors.lightPurple,
            selectedColor: ThemeColors.lightGray,
            title: Text(
              currentTask.taskString,
              style: TextStyle(
                decoration: currentTask.isCompleted == 1
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                fontSize: 22,
              ),
            ),
            trailing: Checkbox(
              value: currentTask.isCompleted == 1,
              onChanged: (value) {
                _toggleTask(DbQuery().taskList[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskInputDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void taskInputDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Task'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Add a new task ->'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () {
                  String givenText = controller.text;
                  _addTask(givenText);
                  Navigator.of(context).pop();
                },
                child: const Text('add'),
              )
            ],
          );
        });
  }

  void taskDeletionDialog(BuildContext context, Task task) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete task?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('cancel')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteTask(task);
                  refetchTasks();
                },
                child: const Text('delete'),
              ),
            ],
          );
        });
  }
}

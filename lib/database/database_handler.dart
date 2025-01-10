import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  Database? _database;

  factory DatabaseHandler() {
    return _instance;
  }
  DatabaseHandler._internal();

  Future<Database> get getDatabase async{
    if(_database == null){
      await initDatabase();
    }
    return _database!;
  }

    Future<void> initDatabase() async {
    _database =  await  openDatabase(join(await getDatabasesPath(), 'ct_database.db'),
      version: 1,
      onCreate: (db, version) async {
      await db.execute('PRAGMA foreign_keys = ON;');
      await createWeeksTable(db);
      await createDaysTable(db);
      await createTasksTable(db);
    });
  }

  Future<void> createWeeksTable(Database database) async {
    await database.execute('''
    CREATE TABLE weeks_table(
        week_id INTEGER UNIQUE,
        num_of_minutes INTEGER,
        num_of_tasks INTEGER
    )
''');
  }

  Future<void> createDaysTable(Database database) async {
    await database.execute('''
    CREATE TABLE days_table(
        day_id INTEGER UNIQUE,
        day_num INTEGER,
        belongs_to_week INTEGER,
        num_of_minutes INTEGER,
        num_of_tasks INTEGER,
        FOREIGN KEY (belongs_to_week) REFERENCES weeks_table(week_id)
    )
''');
  }

  Future<void> createTasksTable(Database database) async {
    await database.execute('''
    CREATE TABLE tasks_table(
        task_id INTEGER PRIMARY KEY,
        is_completed INTEGER,
        task_string TEXT
    )
''');
  }
}

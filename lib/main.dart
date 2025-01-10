import 'package:flutter/material.dart';
import 'package:latest_try_ct/database/data_models.dart';
import 'package:latest_try_ct/database/database_handler.dart';
import 'package:latest_try_ct/database/db_CRUD.dart';
import 'package:latest_try_ct/database/db_query.dart';
import 'package:latest_try_ct/ui_pages/tasks_page.dart';
import 'package:latest_try_ct/ui_pages/counter_page.dart';
import 'package:latest_try_ct/ui_pages/stats_page.dart';
import 'package:provider/provider.dart';
import 'package:latest_try_ct/handlers/calendar_handler.dart';
import 'package:latest_try_ct/handlers/timer_handler.dart';
import 'package:latest_try_ct/theme.dart';
import 'dart:math';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await DbQuery().fetchLastFourWeeks();
  await DbQuery().fetchLastSevenDays();

  await CalendarHandler().setDate();
  CalendarHandler().updateDateEveryMin();
  TimerHandler().startBackgroundTimer();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageNavigationProvider()),
      ChangeNotifierProvider(create: (_) => TimerHandler()),
      ChangeNotifierProvider(create: (_) => DbQuery()),
    ],
    child: const MainApp(),
  ));
}

class PageNavigationProvider with ChangeNotifier {
  int _currentPageNum = 0;
  int get currentPageNum => _currentPageNum;

  void setCurrentPageNum(int pageNum) {
    _currentPageNum = pageNum;
    DbQuery().fetchLastFourWeeks();
    DbQuery().fetchLastSevenDays();
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const StatsPage(),
    const CounterPage(),
    const TasksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ThemeColors.darkGray,
        backgroundColor: ThemeColors.darkPurple,
      ),
      body: Consumer<PageNavigationProvider>(
        builder: (context, pageNavigationProvider, _) {
          return _pages[pageNavigationProvider.currentPageNum];
        },
      ),
      bottomNavigationBar: Consumer<PageNavigationProvider>(
          builder: (context, pageNavigationProvider, _) {
        return BottomNavigationBar(
            currentIndex: pageNavigationProvider.currentPageNum,
            onTap: (pageNum) {
              pageNavigationProvider.setCurrentPageNum(pageNum);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timelapse),
                label: 'countdown',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'tasks',
              ),
            ]);
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:latest_try_ct/database/data_models.dart';
import 'package:latest_try_ct/database/db_CRUD.dart';
import 'package:latest_try_ct/database/db_query.dart';
import 'package:latest_try_ct/handlers/calendar_handler.dart';
import 'package:latest_try_ct/main.dart';
import 'package:latest_try_ct/theme.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  StatsPageState createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ThemeColors.darkPurple,
      ),
      body: Consumer<PageNavigationProvider>(
        builder: (context, PageNavigationProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('last 7 days',
                          style: TextStyle(
                              color: ThemeColors.darkPurple, fontSize: 30)),
                    )),
                const SizedBox(height: 3),
                Center(
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        barGroups: DbQuery()
                            .dayList
                            .map((day) => BarChartGroupData(
                                  x: day.dayNum,
                                  barRods: [
                                    BarChartRodData(
                                      toY: (day.numOfMinutes / 60).toDouble(),
                                      color: ThemeColors.darkPurple,
                                    ),
                                  ],
                                ))
                            .toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                              reservedSize: 40,
                            ),
                            axisNameWidget: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Number of Hours'),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Day ${value.toInt()}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text('last 4 weeks',
                          style: TextStyle(
                              color: ThemeColors.darkPurple, fontSize: 30)),
                    )),
                const SizedBox(height: 3),
                Center(
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        barGroups: DbQuery()
                            .weekList
                            .map((week) => BarChartGroupData(
                                  x: week.weekId,
                                  barRods: [
                                    BarChartRodData(
                                      toY: (week.numOfMinutes / 60).toDouble(),
                                      color: ThemeColors.darkPurple,
                                    ),
                                  ],
                                ))
                            .toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                              reservedSize: 40,
                            ),
                            axisNameWidget: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Number of Hours'),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Week ${value.toInt()}',
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

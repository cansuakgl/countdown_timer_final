import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latest_try_ct/handlers/timer_handler.dart';
import 'package:latest_try_ct/theme.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerHandler>(builder: (context, timerHandler, _) {
      return Scaffold(
        appBar: AppBar(
        foregroundColor: ThemeColors.darkPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 350,
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DashedCircularProgressBar.square(
                    dimensions: 330,
                    progress: timerHandler.currentDuration.inMinutes.toDouble(),
                    maxProgress:
                        timerHandler.initialDuration.inMinutes.toDouble(),
                    startAngle: 270,
                    foregroundColor: ThemeColors.darkPurple,
                    backgroundColor: ThemeColors.lightPurple,
                    foregroundStrokeWidth: 23,
                    animation: true,
                    child: TextButton(
                      onPressed: () {
                        timerHandler.setCountDownDuration(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent),
                      child: const Text(""),
                    ),
                  ),
                  Text(
                    timerHandler
                        .formattedTimeString(timerHandler.currentDuration),
                    style: const TextStyle(
                      fontSize: 60,
                      color: ThemeColors.darkPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              timerHandler.toggleCountdown();
            },
            child: Text(timerHandler.isCountdownOn ? 'pause' : 'start', style: const TextStyle(fontSize: 30)),
          ),
        ],
      ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: const Color(0xFFE7626C),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
      ),
      home: const Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<int> timeSelection = [
    15 * 60,
    20 * 60,
    25 * 60,
    30 * 60,
    35 * 60
  ];
  int selectedTime = timeSelection[2];
  static const int totalCycle = 4;
  int currentCycle = 1;
  static const int goalRound = 12;
  int currentRound = 0;

  int totalSeconds = timeSelection[2];
  bool isRunning = false;
  bool isRest = false;
  late Timer timer;

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration
        .toString()
        .split('.')
        .first
        .split(":")
        .getRange(1, 3)
        .join(":");
  }

  void onTick(Timer timer) {
    if (isRest) {
      if (totalSeconds == 0) {
        timer.cancel();
        setState(() {
          totalSeconds = selectedTime;
          isRunning = false;
          isRest = false;
          currentRound++;
          if (currentRound >= goalRound) {
            currentRound = 0;
          } else {
            timer = Timer.periodic(const Duration(seconds: 1), onTick);
          }
        });
      } else {
        setState(() {
          totalSeconds--;
        });
      }
    } else {
      if (totalSeconds == 0) {
        timer.cancel();
        setState(() {
          totalSeconds = selectedTime;
          isRunning = false;
          currentCycle++;
          if (currentCycle > totalCycle) {
            currentCycle = 1;
            currentRound++;
            if (currentRound >= goalRound) {
              currentRound = 0;
              currentCycle = 0;
            } else {
              isRest = true;
              totalSeconds = 5;
              timer = Timer.periodic(const Duration(seconds: 1), onTick);
            }
          }
        });
      } else {
        setState(() {
          totalSeconds--;
        });
      }
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onRestartPressed() {
    timer.cancel();
    setState(() {
      totalSeconds = selectedTime;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POMOTIMER',
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 1,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                isRest ? 'Rest' : 'Work',
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              itemExtent: 100,
              controller: ScrollController(
                initialScrollOffset: 50,
              ),
              children: [
                for (var i = 0; i < timeSelection.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        selectedTileColor: Colors.white,
                        selectedColor: Theme.of(context).backgroundColor,
                        selected: selectedTime == timeSelection[i],
                        onTap: () {
                          setState(() {
                            selectedTime = timeSelection[i];
                            totalSeconds = selectedTime;
                          });
                        },
                        title: Text(
                          '${timeSelection[i] ~/ 60}',
                          style: TextStyle(
                            color: selectedTime == timeSelection[i]
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).cardColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: isRunning
                        ? onPausePressed
                        : isRest
                            ? null
                            : onStartPressed,
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    disabledColor: Theme.of(context).cardColor.withOpacity(0.5),
                    icon: Icon(isRunning
                        ? Icons.pause_circle_rounded
                        : Icons.play_circle_outline),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  IconButton(
                    onPressed: isRunning ? onRestartPressed : null,
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    disabledColor: Theme.of(context).cardColor.withOpacity(0.5),
                    icon: const Icon(Icons.restart_alt_rounded),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ROUND',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                              Text(
                                '$currentCycle/$totalCycle',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GOAL',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                              Text(
                                '$currentRound/$goalRound',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

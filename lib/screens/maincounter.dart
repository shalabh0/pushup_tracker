import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushup_tracker/screens/Statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class counter extends StatefulWidget {
  const counter({super.key});

  @override
  State<counter> createState() => _counterState();
}

class _counterState extends State<counter> {
  int set1count = 0;
  int set2count = 0;
  final int setLimit = 15;
  bool isResting = false;
  int remainingTime = 60;
  Timer? restTimer;

  int get totalCount => set1count + set2count;
  final int dailyGoal = 30;

  @override
  void initState() {
    super.initState();
    resetSession(); // Always reset session on app start
  }

  void resetSession() {
    setState(() {
      set1count = 0;
      set2count = 0;
      isResting = false;
      remainingTime = 60;
      restTimer?.cancel();
    });
  }

  void startRestTimer() {
    setState(() {
      isResting = true;
      remainingTime = 60;
    });

    restTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
      });

      if (remainingTime == 0) {
        timer.cancel();
        setState(() {
          isResting = false;
        });
      }
    });
  }

  Widget buildSetBox(String label, int count, bool isActive) {
    double progress = count / setLimit;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isActive ? Colors.deepOrange : Colors.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrangeAccent, width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "$count / $setLimit",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Future<void> saveDailyStats(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = "${today.day}-${today.month}-${today.year}";

    Map<String, dynamic> stat = {
      'Date': dateKey,
      'Pushups': count,
    };

    await prefs.setString(dateKey, jsonEncode(stat));
  }

  void handlePushup() {
    if (isResting) return;

    setState(() {
      if (set1count < setLimit) {
        set1count++;
        if (set1count == setLimit) {
          startRestTimer();
        }
      } else if (set2count < setLimit) {
        set2count++;
      }
    });

    saveDailyStats(totalCount);
  }

  void finishSessionAndSave() async {
    await saveDailyStats(totalCount);
    resetSession();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Session finished and progress saved."),
      backgroundColor: Colors.deepOrange,
    ));
  }

  @override
  Widget build(BuildContext context) {
    int count = totalCount;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSetBox("Set 1", set1count, set1count < setLimit),
                  SizedBox(height: 5),
                  buildSetBox(
                      "Set 2", set2count, set1count == setLimit && set2count < setLimit),
                ],
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: isResting || count >= dailyGoal
                    ? null
                    : () {
                        handlePushup();
                      },
                child: Icon(Icons.add, color: Colors.deepOrange),
                tooltip: "Add Pushup",
              ),
              SizedBox(height: 8),
              Text(
                "Goal : $dailyGoal PushUps",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You have done $count PushUps",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              Text(
                count >= dailyGoal
                    ? "You have reached the daily goal!!!!"
                    : "${dailyGoal - count} more pushups to go",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              if (isResting)
                Text(
                  'Resting time... $remainingTime seconds left',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Statistics()));
                },
                child: Text("View your stats"),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: finishSessionAndSave,
                icon: Icon(Icons.check),
                label: Text("Finish Session"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

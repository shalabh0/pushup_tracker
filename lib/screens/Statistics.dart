import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

Map<String, dynamic> stats = {};
bool isLoading = true;

Future<void> loadStats() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();

  Map<String, dynamic> loadedStats = {};

  for (String key in keys) {
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      loadedStats[key] = data;
    }
  }

  setState(() {
    stats = loadedStats;
    isLoading = false;
  });
}

  @override
  
  void initState()
  {
    super.initState();
    loadStats();
  }





@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text("Your Statistics",style: TextStyle(color: Colors.deepOrange),),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : stats.isEmpty
            ? Center(child: Text("No stats found",))
            : ListView(
                children: stats.entries.map((entry) {
                  final date = entry.key;
                  final Pushups = entry.value['Pushups'];
                  return ListTile(
                    leading: Icon(Icons.fitness_center,color: Colors.deepOrange,),
                    title: Text("Date: $date",style: TextStyle(color: Colors.deepOrange),),
                    trailing: Text(
                      "$Pushups",
                      style: TextStyle(

                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange
                      ),
                    ),
                  );
                }).toList(),
              ),
  );
}
}
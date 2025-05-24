import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushup_tracker/screens/maincounter.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Pushup Tracker ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => counter()),
                  );
                },
                child: Text("Get Started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

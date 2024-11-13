import 'dart:async';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_florist, // Replace with the icon you want
                size: 60,
                color: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                "Detecting possible diseases",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showLoadingScreen(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoadingScreen(),
  );
}

// Sample usage of the loading screen
void simulateDetectionProcess(BuildContext context) {
  showLoadingScreen(context);

  // Simulate a delay for the detection process
  Timer(Duration(seconds: 3), () {
    Navigator.of(context).pop(); // Close the loading screen after processing
  });
}

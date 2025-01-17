import 'package:flutter/material.dart';

class MentalTrainingScreen extends StatelessWidget {
  const MentalTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Training"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Welcome to the Mental Training Screen!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

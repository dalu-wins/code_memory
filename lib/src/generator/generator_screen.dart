import 'dart:async';
import 'dart:math';

import 'package:code_memory/src/dialpad/dial_screen.dart';
import 'package:flutter/material.dart';

class GeneratorScreen extends StatefulWidget {
  final Widget message;

  const GeneratorScreen(this.message, {super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  late String pin;
  int countdown = 5;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    pin = Random()
        .nextInt(100000)
        .toString()
        .padLeft(5, '0'); // Generates a 5-digit PIN as a string
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        countdown--;
        if (countdown == 0) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DialScreen(pin: pin)),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$pin',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Switching in $countdown seconds...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

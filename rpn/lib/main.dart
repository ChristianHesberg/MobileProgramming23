import 'package:flutter/material.dart';

import 'commands.dart';
import 'display.dart';
import 'keypad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = "Calculator";
    return MaterialApp(
      title: title,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MainScreen(title: title),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CalcState state = CalcState.empty();
  String number = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            // Consumes state
            child: Display(
              state: state,
              number: number,
            ),
          ),
          Flexible(
            flex: 2,
            // Changes state
            child: Keypad(
              addDecimal: addDecimal,
              addDigit: addDigit,
              enter: enter,
              execute: execute,
              remove: remove,
            ),
          ),
        ],
      ),
    );
  }

  clear() {
    setState(() {
      number = "";
    });
  }

  remove() {
    if (number.isEmpty) return;
    setState(() {
      number = number.substring(0, number.length - 1);
    });
  }

  addDecimal() {
    setState(() {
      number = "$number.";
    });
  }

  addDigit(int digit) {
    final newNumber = "$number$digit";
    if (num.tryParse(newNumber) == null) return;
    setState(() {
      number = newNumber;
    });
  }

  enter() {
    execute(Enter(num.tryParse(number)));
  }

  execute(Command command) {
    try {
      final newState = command.execute(state);
      setState(() {
        state = newState;
        number = "";
      });
    } catch (Error) {}
  }
}

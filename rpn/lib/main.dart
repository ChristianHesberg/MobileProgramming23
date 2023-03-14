import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpn/calculator_model.dart';

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
        home: ChangeNotifierProvider<CalculatorModel>(
          create: (context) => CalculatorModel(),
          child: const MainScreen(
            title: title,
          ),
        ));
  }
}

class MainScreen extends StatelessWidget {
  final String title;
  const MainScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            // Consumes state
            child: Display(),
          ),
          Flexible(
            flex: 2,
            // Changes state
            child: Keypad(),
          ),
        ],
      ),
    );
  }
}

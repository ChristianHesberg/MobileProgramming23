import 'package:flutter/material.dart';

import 'button_grid.dart';
import 'commands.dart';
import 'display.dart';

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
          Flexible(flex: 1, child: Display(state: state, number: number)),
          Flexible(
              flex: 2,
              child: ButtonGrid([
                [
                  ButtonDef("Undo", _execute(Undo())),
                  ButtonDef("Clear", _execute(Clear())),
                  ButtonDef("Remove", _remove()),
                  ButtonDef("/", _execute(Divide())),
                ],
                [
                  ButtonDef("7", _addDigit(7)),
                  ButtonDef("8", _addDigit(8)),
                  ButtonDef("9", _addDigit(9)),
                  ButtonDef("*", _execute(Multiply())),
                ],
                [
                  ButtonDef("4", _addDigit(4)),
                  ButtonDef("5", _addDigit(5)),
                  ButtonDef("6", _addDigit(6)),
                  ButtonDef("-", _execute(Subtract())),
                ],
                [
                  ButtonDef("1", _addDigit(1)),
                  ButtonDef("2", _addDigit(2)),
                  ButtonDef("3", _addDigit(3)),
                  ButtonDef("+", _execute(Add())),
                ],
                [
                  ButtonDef(""),
                  ButtonDef("0", _addDigit(0)),
                  ButtonDef(".", _addDecimal()),
                  ButtonDef("Enter", _execute(Enter(num.tryParse(number)))),
                ],
              ])),
        ],
      ),
    );
  }

  _clear() {
    return () {
      setState(() {
        number = "";
      });
    };
  }

  _remove() {
    return () {
      if (number.isEmpty) return;
      setState(() {
        number = number.substring(0, number.length - 1);
      });
    };
  }

  _addDecimal() {
    return () {
      final newNumber = "$number.";
      if (num.tryParse(newNumber) == null) return;
      setState(() {
        number = newNumber;
      });
    };
  }

  _addDigit(int digit) {
    return () {
      final newNumber = "$number$digit";
      if (num.tryParse(newNumber) == null) return;
      setState(() {
        number = newNumber;
      });
    };
  }

  _execute(Command command) {
    return () {
      try {
        final newState = command.execute(state);
        setState(() {
          state = newState;
          number = "";
        });
      } catch (Error) {}
    };
  }
}

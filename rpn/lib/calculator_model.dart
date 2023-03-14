import 'package:flutter/material.dart';

import 'commands.dart';

class CalculatorModel extends ChangeNotifier {
  CalcState state = CalcState.empty();
  String number = "";

  clear() {
    number = "";
    notifyListeners();
  }

  remove() {
    if (number.isEmpty) return;
    number = number.substring(0, number.length - 1);
    notifyListeners();
  }

  addDecimal() {
    number = "$number.";
    notifyListeners();
  }

  addDigit(int digit) {
    final newNumber = "$number$digit";
    if (num.tryParse(newNumber) == null) return;
    number = newNumber;
    notifyListeners();
  }

  enter() {
    execute(Enter(num.tryParse(number)));
  }

  execute(Command command) {
    try {
      final newState = command.execute(state);
      state = newState;
      number = "";
      notifyListeners();
    } catch (Error) {}
  }
}

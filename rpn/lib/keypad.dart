
import 'package:flutter/material.dart';

import 'button_grid.dart';
import 'commands.dart';

class Keypad extends StatelessWidget {
  final void Function(Command command) execute;
  final void Function(int digit) addDigit;
  final void Function() addDecimal;
  final void Function() remove;
  final void Function() enter;

  const Keypad({
    super.key,
    required this.execute,
    required this.addDigit,
    required this.addDecimal,
    required this.remove,
    required this.enter,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonGrid([
      [
        ButtonDef("Undo", () => execute(Undo())),
        ButtonDef("Clear", () => execute(Clear())),
        ButtonDef("Remove", () => remove()),
        ButtonDef("/", () => execute(Divide())),
      ],
      [
        ButtonDef("7", () => addDigit(7)),
        ButtonDef("8", () => addDigit(8)),
        ButtonDef("9", () => addDigit(9)),
        ButtonDef("*", () => execute(Multiply())),
      ],
      [
        ButtonDef("4", () => addDigit(4)),
        ButtonDef("5", () => addDigit(5)),
        ButtonDef("6", () => addDigit(6)),
        ButtonDef("-", () => execute(Subtract())),
      ],
      [
        ButtonDef("1", () => addDigit(1)),
        ButtonDef("2", () => addDigit(2)),
        ButtonDef("3", () => addDigit(3)),
        ButtonDef("+", () => execute(Add())),
      ],
      [
        ButtonDef(""),
        ButtonDef("0", () => addDigit(0)),
        ButtonDef(".", () => addDecimal()),
        ButtonDef("Enter", () => enter()),
      ],
    ]);
  }
}

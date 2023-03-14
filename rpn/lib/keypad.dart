import 'package:flutter/material.dart';
import 'package:rpn/main.dart';

import 'button_grid.dart';
import 'commands.dart';

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final changer = StateChanger.of(context);
    return ButtonGrid([
      [
        ButtonDef("Undo", () => changer.execute(Undo())),
        ButtonDef("Clear", () => changer.execute(Clear())),
        ButtonDef("Remove", () => changer.remove()),
        ButtonDef("/", () => changer.execute(Divide())),
      ],
      [
        ButtonDef("7", () => changer.addDigit(7)),
        ButtonDef("8", () => changer.addDigit(8)),
        ButtonDef("9", () => changer.addDigit(9)),
        ButtonDef("*", () => changer.execute(Multiply())),
      ],
      [
        ButtonDef("4", () => changer.addDigit(4)),
        ButtonDef("5", () => changer.addDigit(5)),
        ButtonDef("6", () => changer.addDigit(6)),
        ButtonDef("-", () => changer.execute(Subtract())),
      ],
      [
        ButtonDef("1", () => changer.addDigit(1)),
        ButtonDef("2", () => changer.addDigit(2)),
        ButtonDef("3", () => changer.addDigit(3)),
        ButtonDef("+", () => changer.execute(Add())),
      ],
      [
        ButtonDef(""),
        ButtonDef("0", () => changer.addDigit(0)),
        ButtonDef(".", () => changer.addDecimal()),
        ButtonDef("Enter", () => changer.enter()),
      ],
    ]);
  }
}

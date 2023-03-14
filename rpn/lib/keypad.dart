import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpn/calculator_model.dart';
import 'package:rpn/main.dart';

import 'button_grid.dart';
import 'commands.dart';

class Keypad extends StatelessWidget {
  const Keypad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorModel>(context);
    return ButtonGrid([
      [
        ButtonDef("Undo", () => provider.execute(Undo())),
        ButtonDef("Clear", () => provider.execute(Clear())),
        ButtonDef("Remove", () => provider.remove()),
        ButtonDef("/", () => provider.execute(Divide())),
      ],
      [
        ButtonDef("7", () => provider.addDigit(7)),
        ButtonDef("8", () => provider.addDigit(8)),
        ButtonDef("9", () => provider.addDigit(9)),
        ButtonDef("*", () => provider.execute(Multiply())),
      ],
      [
        ButtonDef("4", () => provider.addDigit(4)),
        ButtonDef("5", () => provider.addDigit(5)),
        ButtonDef("6", () => provider.addDigit(6)),
        ButtonDef("-", () => provider.execute(Subtract())),
      ],
      [
        ButtonDef("1", () => provider.addDigit(1)),
        ButtonDef("2", () => provider.addDigit(2)),
        ButtonDef("3", () => provider.addDigit(3)),
        ButtonDef("+", () => provider.execute(Add())),
      ],
      [
        ButtonDef(""),
        ButtonDef("0", () => provider.addDigit(0)),
        ButtonDef(".", () => provider.addDecimal()),
        ButtonDef("Enter", () => provider.enter()),
      ],
    ]);
  }
}

import 'package:flutter/material.dart';

class ButtonDef {
  final String text;
  final VoidCallback? onPressed;
  const ButtonDef(this.text, [this.onPressed]);
}

class ButtonGrid extends StatelessWidget {
  List<List<ButtonDef>> buttons;

  ButtonGrid(List<List<ButtonDef>> this.buttons);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons
          .map((col) => Expanded(
                child: Row(
                  children: col
                      .map((row) => _buildButton(row.text, row.onPressed))
                      .toList(),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildButton(String text, VoidCallback? onPressed) {
    return Expanded(
      key: ValueKey(text),
      child: IconButton(
        onPressed: onPressed,
        icon: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'commands.dart';

class Display extends StatelessWidget {
  const Display({
    super.key,
    required this.state,
    required this.number,
  });

  final CalcState state;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${state.registry}",
              textAlign: TextAlign.right, style: TextStyle(fontSize: 30)),
          Text("${number ?? ""}",
              textAlign: TextAlign.right, style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String? payload;
  const SecondScreen(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Scree')),
      body: Center(
        child: Column(
          children: [
            Text('You got here from a notification'),
            Text(this.payload ?? '')
          ],
        ),
      ),
    );
  }
}

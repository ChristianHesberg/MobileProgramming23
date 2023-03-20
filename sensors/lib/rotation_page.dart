import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:sensors_plus/sensors_plus.dart';

class RotationPage extends StatelessWidget {
  const RotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          Text('Rotate your device to move the image around'),
          Flexible(
            child: DraggableCard(
              child: FlutterLogo(
                size: 128,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

const speed = 5.00;

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  Alignment _alignment = Alignment.center;
  DateTime? _time;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          final size = MediaQuery.of(context).size;
          if (!snapshot.hasData) return Container();
          final event = snapshot.data!;
          final newTime = DateTime.now();
          final delta = newTime.microsecondsSinceEpoch -
              (_time?.microsecondsSinceEpoch ?? 0);
          _time = newTime;
          final x =
              _alignment.x + ((event.x.clamp(-10, 10) * speed) / size.width);
          final y =
              _alignment.y + ((event.y.clamp(-10, 10) * speed) / size.height);
          _alignment = Alignment(x.clamp(-1, 1), y.clamp(-1, 1));
          return AnimatedAlign(
              duration: Duration(microseconds: delta),
              alignment: _alignment,
              child: Card(
                child: widget.child,
              ));
        });
  }
}

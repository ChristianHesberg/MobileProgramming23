import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/app_scaffold.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// https://pub.dev/packages/sensors_plus
// https://www.syncfusion.com/blogs/post/updating-live-data-in-flutter-charts.aspx

class Point {
  final double x;
  final double y;
  final double z;

  Point({required this.x, required this.y, required this.z});
}

class AccelerometerPage extends StatelessWidget {
  const AccelerometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Accelerometer',
      body: Column(
        children: [
          AccelerometerChart(
            title:'Raw',
              stream: accelerometerEvents
                  .map((e) => Point(x: e.x, y: e.y, z: e.z))),
          AccelerometerChart(
            title: 'User',
              stream: userAccelerometerEvents
                  .map((e) => Point(x: e.x, y: e.y, z: e.z))),
        ],
      ),
    );
  }
}

class AccelerometerChart extends StatefulWidget {
  final String title;
  final Stream<Point> stream;

  const AccelerometerChart({required this.title, required this.stream, super.key});

  @override
  State<AccelerometerChart> createState() => _AccelerometerChartState();
}

class _AccelerometerChartState extends State<AccelerometerChart> {
  StreamSubscription<Point>? _subscription;
  final List<Point> _events = [];

  @override
  void initState() {
    _subscription = widget.stream.listen((Point event) {
      setState(() {
        if (_events.length > 200) {
          _events.removeRange(0, _events.length % 200);
        }
        _events.add(event);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: widget.title),
      series: [
        LineSeries(
          color: Colors.green,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.x,
        ),
        LineSeries(
          color: Colors.blue,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.y,
        ),
        LineSeries(
          color: Colors.red,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.z,
        )
      ],
    );
  }
}

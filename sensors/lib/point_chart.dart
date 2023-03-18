import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// https://www.syncfusion.com/blogs/post/updating-live-data-in-flutter-charts.aspx

class Point {
  final double x;
  final double y;
  final double z;

  Point({required this.x, required this.y, required this.z});
}

class PointChart extends StatefulWidget {
  final String title;
  final Stream<Point> stream;

  const PointChart({required this.title, required this.stream, super.key});

  @override
  State<PointChart> createState() => _PointChartState();
}

class _PointChartState extends State<PointChart> {
  StreamSubscription<Point>? _subscription;
  final List<Point> _events = [];

  @override
  void initState() {
    _subscription = widget.stream.listen((Point event) {
      setState(() {
        if (_events.length > 200) {
          _events.removeRange(0, _events.length % 100);
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
      legend: Legend(isVisible: true),
      series: [
        LineSeries(
          legendItemText: 'X',
          color: Colors.green,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.x,
        ),
        LineSeries(
          legendItemText: 'Y',
          color: Colors.blue,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.y,
        ),
        LineSeries(
          legendItemText: 'Z',
          color: Colors.red,
          dataSource: _events,
          xValueMapper: (datum, index) => index,
          yValueMapper: (datum, index) => datum.z,
        )
      ],
    );
  }
}

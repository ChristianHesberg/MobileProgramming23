import 'package:flutter/material.dart';
import 'package:sensors/app_scaffold.dart';
import 'package:sensors/point_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

// https://pub.dev/packages/sensors_plus

class SensorsPlus extends StatelessWidget {
  const SensorsPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sensors Plus',
      body: ListView(
        children: [
          PointChart(
            title:'Accelerometer',
              stream: accelerometerEvents
                  .map((e) => Point(x: e.x, y: e.y, z: e.z))),
          PointChart(
            title: 'User Accelerometer',
              stream: userAccelerometerEvents
                  .map((e) => Point(x: e.x, y: e.y, z: e.z))),
          PointChart(
              title: 'Gyroscope',
              stream:
                  gyroscopeEvents.map((e) => Point(x: e.x, y: e.y, z: e.z))),
          PointChart(
              title: 'Magnetometer (μT)',
              stream:
                  magnetometerEvents.map((e) => Point(x: e.x, y: e.y, z: e.z)))
        ],
      ),
    );
  }
}
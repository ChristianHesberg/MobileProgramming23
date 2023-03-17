import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:light/light.dart';
import 'package:sensors/app_scaffold.dart';

// https://pub.dev/packages/light/example

class LightPage extends StatelessWidget {
  final _light = Light();
  LightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
        title: 'Light',
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<double>(
            initialData: 0,
            stream: _light.lightSensorStream.map(Smooth(0.3)),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Text('Lux: ${snapshot.data!.toInt()}', style: textTheme.bodyLarge,),
                  DayNightWidget(light: toDecimal(snapshot.data!, maxValue: 1000)),
                ],
              );
            },
          ),
        ));
  }
}

num toDecimal(num value, {required int maxValue}) {
  return value.clamp(0, maxValue) / maxValue;
}

class Smooth {
  final num a;
  num acc = 0;

  Smooth(this.a);
  double call(int e) {
    return (acc = acc + a * (e.toDouble() - acc));
  }
}

class LightWidget extends StatefulWidget {
  const LightWidget({super.key});

  @override
  State<LightWidget> createState() => _LightWidgetState();
}

class _LightWidgetState extends State<LightWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DayNightWidget extends StatelessWidget {
  final num light;

  const DayNightWidget({
    required this.light,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Stack(children: [
        Image.asset('assets/hills_night.jpg'),
        Opacity(opacity: light.toDouble(), child: Image.asset('assets/hills_day.jpg')),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sensors/app_scaffold.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

class CompassPage extends StatelessWidget {
  const CompassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Compass",
      body: Center(child: SmoothCompass()),
    );
  }
}

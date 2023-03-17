import 'package:flutter/material.dart';
import 'package:sensors/camera_page.dart';
import 'package:sensors/compass_page.dart';
import 'package:sensors/sensors_plus_page.dart';

import 'home_page.dart';

// https://docs.flutter.dev/cookbook/design/drawer

const menu = {
  'Home': MyHomePage.new,
  'Camera': CameraPage.new,
  'Sensors Plus': SensorsPlus.new,
  'Compass': CompassPage.new
};

class DemosDrawer extends StatelessWidget {
  const DemosDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Demos'),
          ),
          ...menu.entries.map(
            (e) => ListTile(
              title: Text(e.key),
              onTap: () {
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => e.value.call(),
                    ),
                    (route) => route.isFirst);
              },
            ),
          )
        ],
      ),
    );
  }
}

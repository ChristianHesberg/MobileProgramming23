import 'package:flutter/material.dart';
import 'package:sensors/barcode_page.dart';
import 'package:sensors/camera_page.dart';
import 'package:sensors/compass_page.dart';
import 'package:sensors/gallery_page.dart';
import 'package:sensors/light_page.dart';
import 'package:sensors/map_page.dart';
import 'package:sensors/rotation_page.dart';
import 'package:sensors/sensors_plus_page.dart';

import 'home_page.dart';

// https://docs.flutter.dev/cookbook/design/drawer

const menu = {
  'Home': MyHomePage.new,
  'Camera': CameraPage.new,
  'Gallery': GalleryPage.new,
  'Barcode': BarcodePage.new,
  'Sensors Plus': SensorsPlusPage.new,
  'Compass': CompassPage.new,
  'Light': LightPage.new,
  'Rotation': RotationPage.new,
  'Map': MapPage.new,
};

class DemosDrawer extends StatelessWidget {
  const DemosDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.greenAccent,
                  Colors.blue,
                ],
              ),
            ),
            child: Text(
              'Demos',
              style: textTheme.titleLarge,
            ),
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

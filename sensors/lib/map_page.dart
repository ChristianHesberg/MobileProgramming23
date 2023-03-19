import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'app_scaffold.dart';

// https://github.com/fleaflet/flutter_map/blob/master/example/lib/pages/live_location.dart

extension LocationDataExtension on LocationData {
  asLatLng() {
    return LatLng(latitude ?? 0, longitude ?? 0);
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentLocation = null;
  late final MapController _mapController;

  String? _serviceError = '';

  // int interActiveFlags = InteractiveFlag.all;
  int interActiveFlags = InteractiveFlag.rotate |
      InteractiveFlag.pinchZoom |
      InteractiveFlag.doubleTapZoom;

  final Location _locationService = Location();

  StreamSubscription<LocationData>? _subscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    try {
      bool serviceEnabled = await _locationService.serviceEnabled();

      if (!(await _locationService.serviceEnabled())) {
        initLocationService();
        return;
      }

      final permission = await _locationService.requestPermission();

      if (permission != PermissionStatus.granted) return;
      _currentLocation = (await _locationService.getLocation()).asLatLng();
      _subscription = _locationService.onLocationChanged
          .listen((LocationData result) async {
        if (!mounted) return;
        setState(() {
          _currentLocation = result.asLatLng();

          _mapController.move(
              LatLng(result.latitude!, result.longitude!), _mapController.zoom);
        });
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        return Future.error('Location permissions are denied');
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        return Future.error(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng latLng = _currentLocation ?? LatLng(0, 0);

    return AppScaffold(
      title: 'Map',
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildStatusText(latLng),
        ),
        Flexible(
          child: _buildMap(latLng),
        ),
      ]),
    );
  }

  _buildStatusText(LatLng latLng) {
    return Text('This is a map that is showing '
        '(${latLng.latitude}, ${latLng.longitude}).');
  }

  FlutterMap _buildMap(LatLng latLng) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(latLng.latitude, latLng.longitude),
        zoom: 12,
        interactiveFlags: interActiveFlags,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: [
          Marker(
            width: 80,
            height: 80,
            point: latLng,
            builder: (ctx) => const Icon(
              Icons.man,
              color: Colors.red,
            ),
          ),
        ]),
      ],
    );
  }
}

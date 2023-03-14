import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/app_state.dart';
import 'package:weather/repositories/forecast_repository.dart';
import 'package:weather/repositories/geocode_repository.dart';

import 'widgets/forecast_screen.dart';

void main() {
  runApp(HorizonsApp());
}

class HorizonsApp extends StatelessWidget {
  HorizonsApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider(create: (_) => GeoCodeRepository()),
        Provider(create: (_) => ForecastRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // This is the theme of your application.
        theme: ThemeData.dark(),
        // Scrolling in Flutter behaves differently depending on the
        // ScrollBehavior. By default, ScrollBehavior changes depending
        // on the current platform. For the purposes of this scrolling
        // workshop, we're using a custom ScrollBehavior so that the
        // experience is the same for everyone - regardless of the
        // platform they are using.
        scrollBehavior: const ConstantScrollBehavior(),
        title: "Weather",
        home: ForecastScreen(),
      ),
    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

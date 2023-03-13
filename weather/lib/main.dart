import 'package:flutter/material.dart';

import 'hourly_forecast_list.dart';
import 'server.dart';
import 'weekly_forecast_list.dart';

void main() {
  runApp(HorizonsApp());
}

class HorizonsApp extends StatelessWidget {
  HorizonsApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        title: 'Horizons Weather',
        home: ForecastWidget());
  }
}

class ForecastWidget extends StatefulWidget {
  const ForecastWidget({Key? key}) : super(key: key);

  @override
  State<ForecastWidget> createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  int _selectedIndex = 0;
  final _tabs = [
    WeeklyForecastList.new,
    HourlyForecastList.new,
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Server.restore(),
      builder: (context, snapshot) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await Server.refresh();
            await Server.save();
            print('Refresh was called');
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(),
              _tabs.elementAt(_selectedIndex).call()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_week), label: 'Weekly'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_day), label: 'Hourly'),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.teal[800],
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        title: const Text('Horizons'),
        background: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[Colors.teal[800]!, Colors.transparent],
            ),
          ),
          child: Image.network(
            headerImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------
// Below this line are helper classes and data.

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

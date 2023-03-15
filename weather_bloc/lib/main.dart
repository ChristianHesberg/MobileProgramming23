import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/forecast_bloc.dart';

import 'hourly_forecast_list.dart';
import 'server.dart';
import 'weekly_forecast_list.dart';

void main() {
  runApp(const HorizonsApp());
}

class HorizonsApp extends StatelessWidget {
  const HorizonsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Horizons Weather',
      home: BlocProvider(
        create: (context) => ForecastBloc(),
        child: const ForecastWidget(),
      ),
    );
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
  void initState() {
    final bloc = BlocProvider.of<ForecastBloc>(context);
    bloc.add(LoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ForecastBloc>(context);
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(bloc),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(),
              _buildSliverBody(snapshot),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
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

  Future _onRefresh(ForecastBloc bloc) async {
    bloc.add(RefreshEvent());
    await bloc.stream.firstWhere((state) => state is LoadedState);
  }

  Widget _buildSliverBody(AsyncSnapshot<AppState> snapshot) {
    if (snapshot.data is ForecastState) {
      return _tabs
          .elementAt(_selectedIndex)
          .call((snapshot.data as ForecastState).forecast);
    }
    return const SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(child: CircularProgressIndicator()),
    ));
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

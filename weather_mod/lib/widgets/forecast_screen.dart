import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/app_state.dart';

import '../repositories/forecast_repository.dart';
import '../utils/position.dart';
import 'forecast_app_bar.dart';
import 'hourly_forecast_list.dart';
import 'weekly_forecast_list.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  int _selectedIndex = 0;
  final _tabs = [
    WeeklyForecastList.new,
    HourlyForecastList.new,
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final repo = Provider.of<ForecastRepository>(context);
    return Scaffold(
      body: FutureBuilder(
        future: _restore(state, repo),
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: () async {
            await _refresh(state, repo);
            setState(() {});
          },
          child: CustomScrollView(
            slivers: <Widget>[
              const ForecastAppBar(),
              _buildTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Future _restore(AppState state, ForecastRepository repo) async {
    await state.restore();
    if (state.isStale()) {
      await _refresh(state, repo);
    }
  }

  Future _refresh(AppState state, ForecastRepository repo) async {
    var latitude = state.location?.latitude;
    var longitude = state.location?.longitude;
    if (state.location == null) {
      final position = await determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }
    final data =
        await repo.getForecast(latitude: latitude!, longitude: longitude!);
    await state.setForecast(data);
  }

  Widget _buildTab() {
    return _tabs
        .elementAt(_selectedIndex)
        .call(key: ValueKey('tab-$_selectedIndex'));
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }
}

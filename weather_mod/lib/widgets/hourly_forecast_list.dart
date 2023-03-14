import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather/models/app_state.dart';

import '../models/hourly_forecast.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final forecast = state.hourlyForecast;
    final timestamp = state.timestamp;
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(child: TemperatureChart(forecast)),
        Card(child: PrecipitationChart(forecast)),
        if (timestamp != null)
          Center(
            child: Text('Last updated: $timestamp'),
          ),
      ]),
    );
  }
}

class TemperatureChart extends StatelessWidget {
  final List<HourlyForecast> forecast;
  const TemperatureChart(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      key: const ValueKey('temp-chart'),
      title: ChartTitle(text: 'Temperature'),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(title: AxisTitle(text: '°C')),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: [
        SplineSeries(
            dataSource: forecast,
            xValueMapper: (element, index) => element.time,
            yValueMapper: (element, index) => element.temperature_2m,
            legendItemText: 'Air temp'),
        SplineSeries(
            dataSource: forecast,
            xValueMapper: (element, index) => element.time,
            yValueMapper: (element, index) => element.apparent_temperature,
            legendItemText: 'Feels-like'),
      ],
    );
  }
}

class PrecipitationChart extends StatelessWidget {
  final List<HourlyForecast> forecast;
  const PrecipitationChart(this.forecast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      key: const ValueKey('precipitation-chart'),
      title: ChartTitle(text: 'Precipitation'),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'mm')),
      series: [
        ColumnSeries(
          dataSource: forecast.take(48).toList(),
          xValueMapper: (datum, index) => datum.time,
          yValueMapper: (datum, index) => datum.precipitation,
          pointColorMapper: (datum, index) => Color.alphaBlend(
            Colors.white.withOpacity(datum.precipitation_probability / 100),
            Colors.blueGrey,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'server.dart';

class WeeklyForecastList extends StatelessWidget {
  const WeeklyForecastList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final forecasts = Server.getDailyForecast();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final forecast = forecasts[index];
          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.grey[800]!,
                              Colors.transparent
                            ],
                          ),
                        ),
                        child: Image.network(
                          '${baseAssetURL}/day_$index.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          forecast.time.day.toString(),
                          style: textTheme.headline2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          forecast.getWeekday(),
                          style: textTheme.headline4,
                        ),
                        const SizedBox(height: 10.0),
                        Text(forecast.weathercode.description),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${forecast.temperature_2m_max} | ${forecast.temperature_2m_min} C',
                    style: textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: forecasts.length,
      ),
    );
  }
}

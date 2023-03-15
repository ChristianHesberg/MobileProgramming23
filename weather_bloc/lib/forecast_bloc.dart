import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_bloc/models.dart';
import 'server.dart';

@immutable
abstract class AppState {}

class InitialState extends AppState {}

class LoadingState extends AppState {}

class LoadedState extends AppState {
  final Forecast forecast;
  LoadedState(this.forecast);
}

@immutable
abstract class AppEvent {}

class LoadEvent extends AppEvent {}

class RefreshEvent extends AppEvent {}

class ForecastBloc {
  final _state = StreamController<AppState>();
  final _event = StreamController<AppEvent>();

  late Stream<AppState> _broadcastStream;

  Stream<AppState> get stream => _broadcastStream;

  add(AppEvent event) => _event.sink.add(event);

  _emit(AppState state) => _state.sink.add(state);

  ForecastBloc() {
    _broadcastStream = _state.stream.asBroadcastStream();
    _event.stream.listen(_mapEventToState);
    _emit(InitialState());
  }

  void _mapEventToState(AppEvent event) async {
    if (event is LoadEvent || event is RefreshEvent) {
      _emit(LoadingState());
      final forecast = await Server.refresh();
      _emit(LoadedState(forecast));
    }
  }
}

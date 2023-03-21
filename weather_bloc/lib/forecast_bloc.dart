import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/models.dart';
import 'server.dart';

@immutable
abstract class AppState {}

class InitialState extends AppState {}

class LoadingState extends AppState {}

class ForecastState extends AppState {
  final Forecast forecast;
  ForecastState(this.forecast);
}

class RefreshState extends ForecastState {
  RefreshState(super.forecast);
}

class LoadedState extends ForecastState {
  LoadedState(super.forecast);
}

@immutable
abstract class AppEvent {}

class LoadEvent extends AppEvent {}

class RefreshEvent extends AppEvent {}

class ForecastBloc extends Bloc<AppEvent, AppState> {
  ForecastBloc() : super(InitialState()) {
    on<LoadEvent>((event, emit) async {
      emit(LoadingState());
      final forecast = await Server.refresh();
      emit(LoadedState(forecast));
    });
    on<RefreshEvent>((event, emit) async {
      if (state is LoadedState) {
        emit(RefreshState((state as LoadedState).forecast));
      } else {
        emit(LoadingState());
      }
      final forecast = await Server.refresh();
      emit(LoadedState(forecast));
    });
  }
}

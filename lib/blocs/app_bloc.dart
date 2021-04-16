import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:h3_app/skin/skin.dart';
import 'package:flutter/material.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.init());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield AppState(theme: Skin.dark());
    }
  }
}

@immutable
abstract class AppEvent extends Equatable {}

class ThemeChanged extends AppEvent {
  @override
  List<Object> get props => [];
}

class LocaleChanged extends AppEvent {
  @override
  List<Object> get props => [];
}

@immutable
class AppState extends Equatable {
  final Locale locale;
  final Skin theme;
  const AppState({
    this.locale,
    this.theme,
  });

  factory AppState.init() {
    return AppState(
      theme: Skin.light(),
      locale: Locale("zh", "CN"),
    );
  }

  @override
  List<Object> get props => [locale, theme];
}

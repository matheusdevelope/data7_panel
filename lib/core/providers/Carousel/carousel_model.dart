import 'package:data7_panel/core/providers/Settings/settings_preferences.dart';
import 'package:flutter/material.dart';

import 'carousel_preferences.dart';

class CarouselModel extends ChangeNotifier {
  late int _currentIndex;
  late int _itensCount;
  late bool _autoplay;
  late int _autoPlayDuration;
  late CarouselPreferences _preferences;
  int get currentIndex => _currentIndex;
  int get itensCount => _itensCount;
  bool get autoplay => _autoplay;
  int get autoPlayDuration => _autoPlayDuration;

  CarouselModel() {
    _currentIndex = 0;
    _itensCount = 0;
    _autoplay = true;
    _autoPlayDuration = 1000;
    _preferences = SettingsPreferences.carousel;
    _getPreferences();
  }

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  set itensCount(int value) {
    _itensCount = value;
    notifyListeners();
  }

  set autoplay(bool value) {
    _autoplay = value;
    _preferences.setAutoPlay(value);
    notifyListeners();
  }

  set autoPlayDuration(int value) {
    _autoPlayDuration = value;
    _preferences.setIntervalAutoPlay(value);
    notifyListeners();
  }

  _getPreferences() async {
    _autoplay = await _preferences.getAutoPlay();
    _autoPlayDuration = await _preferences.getIntervalAutoPlay();
    notifyListeners();
  }

  Future<CarouselModel> initialize() async {
    await _getPreferences();
    return this;
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class CarouselPreferences {
  setAutoPlay(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('@autoplay', value);
  }

  Future<bool> getAutoPlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('@autoplay') ?? true;
  }

  void setIntervalAutoPlay(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('@interval_autoplay', value);
  }

  Future<int> getIntervalAutoPlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('@interval_autoplay') ?? 5;
  }
}

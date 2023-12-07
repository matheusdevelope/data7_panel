import 'package:data7_panel/infra/storage/storage.dart';

class CarouselPreferences {
  IStorage storage;
  CarouselPreferences({required this.storage});
  setAutoPlay(bool value) async {
    await storage.setBool('@autoplay', value);
  }

  Future<bool> getAutoPlay() async {
    return await storage.getBool('@autoplay') ?? true;
  }

  void setIntervalAutoPlay(int value) async {
    await storage.setInt('@interval_autoplay', value);
  }

  Future<int> getIntervalAutoPlay() async {
    return await storage.getInt('@interval_autoplay') ?? 5;
  }
}

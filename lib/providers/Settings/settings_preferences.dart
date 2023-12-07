import 'package:data7_panel/dependecy_injection.dart';
import 'package:data7_panel/infra/storage/storage.dart';
import 'package:data7_panel/providers/Carousel/carousel_preferences.dart';
import 'package:data7_panel/providers/Database/database_preferences.dart';
import 'package:data7_panel/providers/Notification/notification_preferences.dart';
import 'package:data7_panel/providers/Panel/panel_preferences.dart';
import 'package:data7_panel/providers/WindowsService/windows_service_preferences.dart';
import 'package:data7_panel/providers/Theme/theme_preferences.dart';

class SettingsPreferences {
  static IStorage storage = DI.get<IStorage>();
  static ThemePreferences theme = ThemePreferences(storage: storage);
  static CarouselPreferences carousel = CarouselPreferences(storage: storage);
  static NotificationPreferences notifications =
      NotificationPreferences(storage: storage);
  static DatabasePreferences database = DatabasePreferences(storage: storage);
  static PanelPreferences panel = PanelPreferences(storage: storage);
  static WindowsServicePreferences winService =
      WindowsServicePreferences(storage: storage);
}

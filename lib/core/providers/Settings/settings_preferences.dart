import 'package:data7_panel/dependecy_injection.dart';
import 'package:data7_panel/core/infra/storage/storage.dart';
import 'package:data7_panel/core/providers/Carousel/carousel_preferences.dart';
import 'package:data7_panel/core/providers/Database/database_preferences.dart';
import 'package:data7_panel/core/providers/Notification/notification_preferences.dart';
import 'package:data7_panel/core/providers/Panel/panel_preferences.dart';
import 'package:data7_panel/core/providers/WindowsService/windows_service_preferences.dart';
import 'package:data7_panel/core/providers/Theme/theme_preferences.dart';

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

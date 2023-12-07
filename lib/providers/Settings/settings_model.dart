import 'package:data7_panel/providers/Carousel/carousel_model.dart';
import 'package:data7_panel/providers/Database/database_model.dart';
import 'package:data7_panel/providers/Notification/notification_model.dart';
// import 'package:data7_panel/providers/Panel/panel_model.dart';
import 'package:data7_panel/providers/WindowsService/windows_service_model.dart';
import 'package:data7_panel/providers/theme/theme_model.dart';

class Settings {
  late ThemeModel _theme;
  late CarouselModel _carousel;
  // late PanelSettings _panel;
  late NotificationsSettings _notifications;
  late DatabaseProvider _database;
  late WindowsServiceProvider _windowsService;

  ThemeModel get theme => _theme;
  CarouselModel get carousel => _carousel;
  // PanelSettings get panel => _panel;
  NotificationsSettings get notifications => _notifications;
  DatabaseProvider get database => _database;
  WindowsServiceProvider get winService => _windowsService;

  Settings() {
    _theme = ThemeModel();
    _carousel = CarouselModel();
    // _panel = PanelSettings();
    _notifications = NotificationsSettings();
    _database = DatabaseProvider();
    _windowsService = WindowsServiceProvider();
  }

  Future<void> initialize() async {
    await _theme.initialize();
    await _carousel.initialize();
    // await _panel.initialize();
    await _notifications.initialize();
    await _database.initialize();
    await _windowsService.initialize();
  }
}

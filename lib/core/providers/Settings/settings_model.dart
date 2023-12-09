import 'package:data7_panel/core/providers/Carousel/carousel_model.dart';
import 'package:data7_panel/core/providers/Database/database_model.dart';
import 'package:data7_panel/core/providers/Notification/notification_model.dart';
import 'package:data7_panel/core/providers/WindowsService/windows_service_model.dart';
import 'package:data7_panel/core/providers/theme/theme_model.dart';

class Settings {
  static final Settings _instance = Settings._internal();

  factory Settings() {
    return _instance;
  }

  Settings._internal();

  final ThemeModel _theme = ThemeModel();
  final CarouselModel _carousel = CarouselModel();
  final NotificationsSettings _notifications = NotificationsSettings();
  final DatabaseProvider _database = DatabaseProvider();
  final WindowsServiceProvider _windowsService = WindowsServiceProvider();

  ThemeModel get theme => _theme;
  CarouselModel get carousel => _carousel;
  NotificationsSettings get notifications => _notifications;
  DatabaseProvider get database => _database;
  WindowsServiceProvider get winService => _windowsService;

  Future<void> initialize() async {
    await _theme.initialize();
    await _carousel.initialize();
    await _notifications.initialize();
    await _database.initialize();
    await _windowsService.initialize();
  }
}

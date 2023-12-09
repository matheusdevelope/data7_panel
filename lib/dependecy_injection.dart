import 'package:data7_panel/core/domain/repository/panel_repository.dart';
import 'package:data7_panel/core/infra/api/Http/dio_http.dart';
import 'package:data7_panel/core/infra/api/Http/http_client.dart';
import 'package:data7_panel/core/infra/repository/http_panel_repository.dart';
import 'package:data7_panel/core/infra/services/Adapters/disk_audio_manager.dart';
import 'package:data7_panel/core/infra/services/Adapters/media_kit_audio_palyer_adapter.dart';
import 'package:data7_panel/core/infra/services/Adapters/windows_firewall_rules_powershell_adapter.dart';
import 'package:data7_panel/core/infra/services/Adapters/windows_service_powershell_adapter.dart';
import 'package:data7_panel/core/infra/services/Interfaces/audio_manager.dart';
import 'package:data7_panel/core/infra/services/Interfaces/audio_player.dart';
import 'package:data7_panel/core/infra/services/Interfaces/windows_firewall_rules.dart';
import 'package:data7_panel/core/infra/services/Interfaces/windows_service.dart';
import 'package:data7_panel/core/infra/storage/shared_preferences_storage.dart';
import 'package:data7_panel/core/infra/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// ignore: non_constant_identifier_names
final GetIt DI = GetIt.I;

class Dependencies {
  static void init() {
    DI.registerFactoryParam<IHttpClient, String?, void>(
        (baseUrl, _) => DioHttpClient(BaseOptions(baseUrl: baseUrl ?? '')));
    DI.registerFactoryParam<IPanelRepository, String, void>(
        (baseUrl, _) => HttpPanelRepository(baseUrl: baseUrl));
    DI.registerSingleton<IStorage>(SharedPreferencesStorage());
    DI.registerSingleton<IAudioPlayer>(MediaKitAudioAdapter());
    DI.registerSingleton<IAudioManager>(DiskAudioManager());
    DI.registerSingleton<IWindowsService>(PowershellWindowsServiceAdapter());
    DI.registerSingleton<IWindowsFirewallRule>(
        WindowsFirewallRulePowershellAdapter());
  }

  static void reset() {
    DI.reset();
  }
}

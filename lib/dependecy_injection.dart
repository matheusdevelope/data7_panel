import 'package:data7_panel/domain/repository/panel_repository.dart';
import 'package:data7_panel/infra/api/Http/dio_http.dart';
import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:data7_panel/infra/repository/http_panel_repository.dart';
import 'package:data7_panel/infra/services/Adapters/media_kit_audio_palyer_adapter.dart';
import 'package:data7_panel/infra/services/Adapters/windows_firewall_rules_powershell_adapter.dart';
import 'package:data7_panel/infra/services/Adapters/windows_service_powershell_adapter.dart';
import 'package:data7_panel/infra/services/Interfaces/audio_player.dart';
import 'package:data7_panel/infra/services/Interfaces/windows_firewall_rules.dart';
import 'package:data7_panel/infra/services/Interfaces/windows_service.dart';
import 'package:data7_panel/infra/storage/shared_preferences_storage.dart';
import 'package:data7_panel/infra/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt DI = GetIt.I;

class Dependencies {
  static void init() {
    DI.registerFactoryParam<IHttpClient, String?, void>(
        (baseUrl, _) => DioHttpClient(BaseOptions(baseUrl: baseUrl ?? '')));
    DI.registerFactoryParam<IPanelRepository, String, void>(
        (baseUrl, _) => HttpPanelRepository(baseUrl: baseUrl));
    DI.registerSingleton<IStorage>(SharedPreferencesStorage());
    DI.registerSingleton<IAudioPlayer>(MediaKitAudioAdapter());
    DI.registerSingleton<IWindowsService>(PowershellWindowsServiceAdapter());
    DI.registerSingleton<IWindowsFirewallRule>(
        WindowsFirewallRulePowershellAdapter());
  }

  static void reset() {
    DI.reset();
  }
}

import 'package:data7_panel/domain/repository/panel_repository.dart';
import 'package:data7_panel/infra/api/Http/dio_http.dart';
import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:data7_panel/infra/repository/http_panel_repository.dart';
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
  }

  static void reset() {
    DI.reset();
  }
}

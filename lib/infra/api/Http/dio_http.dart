import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:dio/dio.dart' as dio;

class DioHttpClient implements IHttpClient {
  late dio.Dio _dio;
  DioHttpClient([dio.BaseOptions? options]) {
    _dio = dio.Dio(options);
  }

  @override
  set baseUrl(String url) => _dio.options.baseUrl = url;

  @override
  String get baseUrl => _dio.options.baseUrl;

  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(url, queryParameters: queryParameters);
    return Response(response.data, response.statusCode!, response.headers.map);
  }

  @override
  Future<Response> post(String url,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    final response =
        await _dio.post(url, queryParameters: queryParameters, data: data);
    return Response(response.data, response.statusCode!, response.headers.map);
  }

  @override
  Future<Response> put(String url,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    final response =
        await _dio.put(url, queryParameters: queryParameters, data: data);
    return Response(response.data, response.statusCode!, response.headers.map);
  }

  @override
  Future<Response> delete(String url,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.delete(url, queryParameters: queryParameters);
    return Response(response.data, response.statusCode!, response.headers.map);
  }

  @override
  Future<Response> patch(String url,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    final response =
        await _dio.patch(url, queryParameters: queryParameters, data: data);
    return Response(response.data, response.statusCode!, response.headers.map);
  }

  @override
  Future<Response> download(String url, String savePath,
      {Map<String, dynamic>? queryParameters,
      ProgressCallback? onReceiveProgress}) async {
    final response = await _dio.download(url, savePath,
        queryParameters: queryParameters, onReceiveProgress: onReceiveProgress);
    return Response(response.data, response.statusCode!, response.headers.map);
  }
}

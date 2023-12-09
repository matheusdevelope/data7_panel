abstract class IHttpClient {
  String baseUrl = '';
  Future<Response> get(String url, {Map<String, dynamic> queryParameters});
  Future<Response> post(String url,
      {Map<String, dynamic> queryParameters, dynamic data});
  Future<Response> put(String url,
      {Map<String, dynamic> queryParameters, dynamic data});
  Future<Response> delete(String url, {Map<String, dynamic> queryParameters});
  Future<Response> patch(String url,
      {Map<String, dynamic> queryParameters, dynamic data});
  Future<Response> download(String url, String savePath,
      {Map<String, dynamic> queryParameters,
      ProgressCallback onReceiveProgress});
}

typedef ProgressCallback = void Function(int count, int total);

class Response<T> {
  final T data;
  final int statusCode;
  final Map<String, List<String>> headers;
  Response(this.data, this.statusCode, this.headers);
}

// class HttpClient {
//   final Dio dio = Dio();

//   static final HttpClient _instance = HttpClient._internal();

//   factory HttpClient() {
//     return _instance;
//   }

//   HttpClient._internal();

//   Future<Response> get(String url,
//       {Map<String, dynamic> queryParameters}) async {
//     return await dio.get(url, queryParameters: queryParameters);
//   }

//   Future<Response> post(String url,
//       {Map<String, dynamic> queryParameters, dynamic data}) async {
//     return await dio.post(url, queryParameters: queryParameters, data: data);
//   }

//   Future<Response> put(String url,
//       {Map<String, dynamic> queryParameters, dynamic data}) async {
//     return await dio.put(url, queryParameters: queryParameters, data: data);
//   }

//   Future<Response> delete(String url,
//       {Map<String, dynamic> queryParameters}) async {
//     return await dio.delete(url, queryParameters: queryParameters);
//   }

//   Future<Response> patch(String url,
//       {Map<String, dynamic> queryParameters, dynamic data}) async {
//     return await dio.patch(url, queryParameters: queryParameters, data: data);
//   }

//   Future<String> download(String url, String savePath,
//       {Map<String, dynamic> queryParameters,
//       ProgressCallback onReceiveProgress}) async {
//     return await dio.download(url, savePath,
//         queryParameters: queryParameters, onReceiveProgress: onReceiveProgress);
//   }
// }

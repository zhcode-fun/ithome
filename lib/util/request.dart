import 'package:dio/dio.dart';
import 'package:ithome_lite/util/api.dart';

class Request {
  static final Request _singleton = Request._internal();

  factory Request() {
    return _singleton;
  }

  Request._internal();

  static final BaseOptions _options =
      BaseOptions(baseUrl: Api.baseUrl);
  final Dio _dio = Dio(_options);

  Future<Response<dynamic>> get(String path, {Map<String, dynamic> data}) {
    return _dio.get(path, queryParameters: data);
  }
}

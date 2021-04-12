import 'package:dio/dio.dart';
import 'package:shareloc/data/endpoint.dart';

Dio request() {
  var dio = Dio();
  dio.options.baseUrl = BASE_URL;
  dio.options.headers = {Headers.contentTypeHeader: Headers.jsonContentType};
  return dio;
}

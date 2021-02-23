import 'package:dio/dio.dart';
import '../config.dart';

enum Method { get, post, delete }
Dio getMyDio() {
  Dio dio = new Dio();
// 配置dio实例
  dio.options.baseUrl = api;
  dio.options.connectTimeout = 5000; //5s
  dio.options.receiveTimeout = 3000;
  return dio;
}

String getMethodName(Method method) {
  switch (method) {
    case Method.get:
      return "get";
    case Method.post:
      return "post";
    case Method.delete:
      return "delete";
    default:
      return "get";
  }
}

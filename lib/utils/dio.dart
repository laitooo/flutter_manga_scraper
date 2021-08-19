import 'package:dio/dio.dart';

class DioFactory {
  static Dio create(Interceptors interceptors) {
    final dio = Dio();
    //..interceptors.addAll(interceptors);
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    return dio;
  }

  static Dio withDefaultInterceptors() {
    return create(getDefaultInterceptors());
  }

  static Interceptors getDefaultInterceptors() {
    return Interceptors()
      ..addAll([
        LogInterceptor(requestBody: false, responseBody: false),
      ]);
  }
}

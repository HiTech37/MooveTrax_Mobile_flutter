import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/common/network/dio_interceptor.dart';
import 'package:dio/dio.dart' show Dio, ResponseType;

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio
      ..options.baseUrl = ApiConfig.baseUrl
      ..options.connectTimeout = ApiConfig.connectionTimeout
      ..options.receiveTimeout = ApiConfig.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(DioInterceptor());
  }
}

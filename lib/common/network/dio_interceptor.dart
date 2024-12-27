import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:moovetrax/core/app_extension.dart';

class DioInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );
  final box = GetStorage();

  Map<String, dynamic>? get userData => box.read('loginInfo');
  String? get installerKey => box.read('installerKey');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('====================START====================');
    logger.i('HTTP method => ${options.method} ');
    logger.i(
        'Request => ${options.baseUrl}${options.path}${options.queryParameters.format}');
    logger.i('Header  => ${options.headers}');
    String token = userData == null
        ? installerKey == null
            ? ''
            : installerKey == ''
                ? ''
                : installerKey!
        : userData!['token'];
    options.headers = {
      'Authorization': 'Bearer $token',
      'content-Type': 'application/json',
    };
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    logger.e(options.method); // Debug log
    logger.e('Error: ${err.error}, Message: ${err.message}'); // Error log
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Response => StatusCode: ${response.statusCode}'); // Debug log
    logger.d('Response => Body: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}

import 'package:moovetrax/common/network/dio_client.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:moovetrax/core/app_extension.dart';
import 'package:dio/dio.dart';

class PaymentApi {
  final DioClient dioClient;

  PaymentApi({required this.dioClient});

  Future<dynamic> createPlan(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.createPlan, data: params);
    if (response.statusCode.success) {
      return response.data['id'].toString();
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> cancelSubscription(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.cancelSubscription, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> subscriptionComplete(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.subscriptionComplete, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> paymentComplete(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.paymentComplete, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> installerPaymentComplete(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.installerPaymentComplete, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updatePlanPrice(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.updatePlanPrice, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }
}

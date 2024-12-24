import 'package:moovetrax/common/network/dio_client.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:moovetrax/core/app_extension.dart';
import 'package:dio/dio.dart';

class ReportsApi {
  final DioClient dioClient;

  ReportsApi({required this.dioClient});

  Future<dynamic> getCommands(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.command, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getEvents(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.event, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getMileAgeList(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.deviceMileAgeData, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getUserNameList() async {
    final Response response = await dioClient.dio.get(ApiConfig.userNameList);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getTuroTrips(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.turoTrips, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getTuroTripParseQueue(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.turoTripParseQueue}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getBatchGeneratLinksPage() async {
    final Response response =
        await dioClient.dio.get(ApiConfig.batchGenerateLinks);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> addCoHost(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.addCoHost, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> saveTuroCallLinks(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.saveTuroCallLinks, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deleteCoHost(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.deleteCoHost, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deleteTuroTrips(String tripId) async {
    final Response response =
        await dioClient.dio.delete('${ApiConfig.turoTrips}/$tripId');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getSharedLinks(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.shareLinks, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getCoHosts(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.coHost, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deleteSharedLinks(String linkId) async {
    final Response response =
        await dioClient.dio.delete('${ApiConfig.updateShareLinks}/$linkId');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateSharedLinks(String linkId, dynamic params) async {
    final Response response = await dioClient.dio
        .put('${ApiConfig.updateShareLinks}/$linkId', data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }
}

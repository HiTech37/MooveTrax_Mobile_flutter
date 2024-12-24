import 'package:moovetrax/common/network/dio_client.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:moovetrax/core/app_extension.dart';
import 'package:dio/dio.dart';

class DeviceApi {
  final DioClient dioClient;
  DeviceApi({required this.dioClient});

  Future<dynamic> getMainPageData() async {
    final Response response = await dioClient.dio
        .get(ApiConfig.devices, queryParameters: {'source': 'mainPage'});
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getTollGuruPageData(dynamic params) async {
    final Response response = await dioClient.dio
        .get(ApiConfig.getTollGuruPageData, queryParameters: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> replayPositions(dynamic params) async {
    final Response response = await dioClient.dio
        .get(ApiConfig.replayPositions, queryParameters: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getDeviceCommandsDetail(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.deviceCommandDetail}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> sendCommand(dynamic params) async {
    final Response response = await dioClient.dio
        .get(ApiConfig.deviceCommand, queryParameters: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getDeviceMaintainData(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.maintain}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateDeviceMaintainData(String id, dynamic params) async {
    final Response response =
        await dioClient.dio.post('${ApiConfig.maintain}/$id', data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> submitTollGuru(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.submitTollGuru, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getSelectedDeviceData(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.devices}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getGeoFenceList() async {
    final Response response = await dioClient.dio.get(ApiConfig.geoFenceList);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deleteGeoFenceById(String id) async {
    final Response response =
        await dioClient.dio.delete('${ApiConfig.deleteGeoFenceById}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getGeoFenceById(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.getGeoFenceById}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> createGeoFence(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.createGeoFence, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getCreditLogsByDeviceId(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.creditLogsByDeviceId}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getPlData(dynamic params) async {
    final Response response =
        await dioClient.dio.get(ApiConfig.getPlData, queryParameters: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getChartData(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.getChartData, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deletePlItem(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.deletePlItem, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> addPlItem(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.addPlData, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> addCreditLogs(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.addCreditLogs, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> setBillingSource(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.setBillingSource, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateSelectedDeviceData(String id, dynamic params) async {
    final Response response =
        await dioClient.dio.put('${ApiConfig.devices}/$id', data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> saveLockUnlockSetting(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.saveLockUnlockSetting, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> setDeviceVoltage(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.setDeviceVoltage, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getDeviceCheckChargeRequired() async {
    final Response response =
        await dioClient.dio.get(ApiConfig.deviceCheckChargeRequired);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> checkEmnifyConnectivity(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.checkEmnifyConnectivity, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> cancelService(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.cancelService, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateNotficationSettings(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.notificationSetting, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> uploadDeviceImage(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.uploadImage, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> setUserDevicesAbi() async {
    final Response response =
        await dioClient.dio.post(ApiConfig.setUserDevicesAbi);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> setUserDevicesTintAi() async {
    final Response response =
        await dioClient.dio.post(ApiConfig.setUserDevicesTintAi);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> addDeviceData(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.devices, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getSelectedShareDevicePageData(String deviceId) async {
    final Response response = await dioClient.dio
        .get('${ApiConfig.getSelectedShareDevicePageData}/$deviceId');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateShareSetting(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.updateShareSetting, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateSelectedGeoFenceById(String id, dynamic params) async {
    final Response response = await dioClient.dio
        .put('${ApiConfig.updateGeoFenceById}/$id', data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getPositionsHistory(
      String deviceId, String from, String to) async {
    final queryParameters = <String, String>{
      'deviceId': deviceId,
      'from': from,
      'to': to
    };
    final String queryString = Uri(queryParameters: queryParameters).query;

    // Constructing the full URL with query parameters
    final String url = '${ApiConfig.positions}?$queryString';
    final Response response = await dioClient.dio.get(url);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getCreditLogs(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.creditLogs}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> checkChargeRequired(String id) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.checkChargeRequired}/$id');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateShockSensorSetting(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.updateShockSensorSetting, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateBluetoothSetting(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.updateBluetoothSetting, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> sendInstallerCommand(
      String command, String deviceId, String userId) async {
    final Response response = await dioClient.dio.get(
        '${ApiConfig.installerCommand}?command=$command&deviceId=$deviceId&userId=$userId');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getInstallerCommandDetails(String deviceId) async {
    final Response response = await dioClient.dio
        .get('${ApiConfig.installerCommandDetail}/$deviceId');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> lockAndUnlockInstallerDevices(
      String deviceId, dynamic params) async {
    final Response response = await dioClient.dio
        .put('${ApiConfig.installerDevices}/$deviceId', data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> installerDeviceSetVoltage(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.installerDeviceSetVoltage, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updateSharedTextTemplate(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.updateSharedTextTemplate, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }
}

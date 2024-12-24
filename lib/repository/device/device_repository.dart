import 'package:dio/dio.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:moovetrax/data/api/device/device_api.dart';

Future<Either<String, bool>> checkItemFailOrSuccess(
  Future<bool> apiCallback,
) async {
  try {
    await apiCallback;
    return const Right(true);
  } on DioException catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return Left(errorMessage);
  }
}

Future<Either<String, dynamic>> checkItemDataFailOrSuccess(
  Future<dynamic> apiCallback,
) async {
  try {
    final dynamic data = await apiCallback;
    return Right(data);
  } on DioException catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return Left(errorMessage);
  }
}

class DeviceRepository {
  final DeviceApi deviceApi;

  DeviceRepository({required this.deviceApi});

  Future<Either<String, dynamic>> getMainPageData() async {
    return checkItemDataFailOrSuccess(deviceApi.getMainPageData());
  }

  Future<Either<String, dynamic>> getSelectedDeviceData(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.getSelectedDeviceData(id));
  }

  Future<Either<String, dynamic>> getDeviceMaintainData(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.getDeviceMaintainData(id));
  }

  Future<Either<String, dynamic>> updateDeviceMaintainData(
      String id, dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateDeviceMaintainData(id, params));
  }

  Future<Either<String, dynamic>> getTollGuruPageData(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.getTollGuruPageData(params));
  }

  Future<Either<String, dynamic>> getDeviceCheckChargeRequired() async {
    return checkItemDataFailOrSuccess(deviceApi.getDeviceCheckChargeRequired());
  }

  Future<Either<String, dynamic>> getDeviceCommandsDetail(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.getDeviceCommandsDetail(id));
  }

  Future<Either<String, dynamic>> checkEmnifyConnectivity(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.checkEmnifyConnectivity(params));
  }

  Future<Either<String, dynamic>> replayPositions(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.replayPositions(params));
  }

  Future<Either<String, dynamic>> sendCommand(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.sendCommand(params));
  }

  Future<Either<String, dynamic>> submitTollGuru(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.submitTollGuru(params));
  }

  Future<Either<String, dynamic>> getCreditLogsByDeviceId(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.getCreditLogsByDeviceId(params));
  }

  Future<Either<String, dynamic>> getPlData(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.getPlData(params));
  }

  Future<Either<String, dynamic>> getChartData(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.getChartData(params));
  }

  Future<Either<String, dynamic>> deletePlItem(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.deletePlItem(params));
  }

  Future<Either<String, dynamic>> addPlItem(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.addPlItem(params));
  }

  Future<Either<String, dynamic>> addCreditLogs(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.addCreditLogs(params));
  }

  Future<Either<String, dynamic>> setBillingSource(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.setBillingSource(params));
  }

  Future<Either<String, dynamic>> updateSelectedDeviceData(
      String id, dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateSelectedDeviceData(id, params));
  }

  Future<Either<String, dynamic>> saveLockUnlockSetting(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.saveLockUnlockSetting(params));
  }

  Future<Either<String, dynamic>> setDeviceVoltage(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.setDeviceVoltage(params));
  }

  Future<Either<String, dynamic>> updateNotficationSettings(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateNotficationSettings(params));
  }

  Future<Either<String, dynamic>> uploadDeviceImage(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.uploadDeviceImage(params));
  }

  Future<Either<String, dynamic>> setUserDevicesAbi() async {
    return checkItemDataFailOrSuccess(deviceApi.setUserDevicesAbi());
  }

  Future<Either<String, dynamic>> setUserDevicesTintAi() async {
    return checkItemDataFailOrSuccess(deviceApi.setUserDevicesTintAi());
  }

  Future<Either<String, dynamic>> addDeviceData(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.addDeviceData(params));
  }

  Future<Either<String, dynamic>> getSelectedShareDevicePageData(
      String deviceId) async {
    return checkItemDataFailOrSuccess(
        deviceApi.getSelectedShareDevicePageData(deviceId));
  }

  Future<Either<String, dynamic>> updateShareSetting(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.updateShareSetting(params));
  }

  Future<Either<String, dynamic>> getGeoFenceList() async {
    return checkItemDataFailOrSuccess(deviceApi.getGeoFenceList());
  }

  Future<Either<String, dynamic>> deleteGeoFenceById(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.deleteGeoFenceById(id));
  }

  Future<Either<String, dynamic>> getGeoFenceById(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.getGeoFenceById(id));
  }

  Future<Either<String, dynamic>> createGeoFence(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.createGeoFence(params));
  }

  Future<Either<String, dynamic>> updateSelectedGeoFenceById(
      String id, dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateSelectedGeoFenceById(id, params));
  }

  Future<Either<String, dynamic>> getPositionsHistory(
      String deviceId, String from, String to) async {
    return checkItemDataFailOrSuccess(
        deviceApi.getPositionsHistory(deviceId, from, to));
  }

  Future<Either<String, dynamic>> getCreditLogs(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.getCreditLogs(id));
  }

  Future<Either<String, dynamic>> checkChargeRequired(String id) async {
    return checkItemDataFailOrSuccess(deviceApi.checkChargeRequired(id));
  }

  Future<Either<String, dynamic>> cancelService(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.cancelService(params));
  }

  Future<Either<String, dynamic>> updateShockSensorSetting(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateShockSensorSetting(params));
  }

  Future<Either<String, dynamic>> updateBluetoothSetting(dynamic params) async {
    return checkItemDataFailOrSuccess(deviceApi.updateBluetoothSetting(params));
  }

  Future<Either<String, dynamic>> sendInstallerCommand(
      String command, String deviceId, String userId) async {
    return checkItemDataFailOrSuccess(
        deviceApi.sendInstallerCommand(command, deviceId, userId));
  }

  Future<Either<String, dynamic>> getInstallerCommandDetails(
      String deviceId) async {
    return checkItemDataFailOrSuccess(
        deviceApi.getInstallerCommandDetails(deviceId));
  }

  Future<Either<String, dynamic>> lockAndUnlockInstallerDevices(
      String deviceId, dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.lockAndUnlockInstallerDevices(deviceId, params));
  }

  Future<Either<String, dynamic>> installerDeviceSetVoltage(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.installerDeviceSetVoltage(params));
  }

  Future<Either<String, dynamic>> updateSharedTextTemplate(
      dynamic params) async {
    return checkItemDataFailOrSuccess(
        deviceApi.updateSharedTextTemplate(params));
  }
}

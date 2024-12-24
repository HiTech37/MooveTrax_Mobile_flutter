import 'package:dartz/dartz.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:moovetrax/repository/device/device_repository.dart';

class DeviceController extends GetxController
    with StateMixin<dynamic>, BaseController {
  final DeviceRepository deviceRepository;
  Rx<dynamic> mainPageData = Rx<dynamic>(null);
  Rx<dynamic> cancelServiceData = Rx<dynamic>(null);
  Rx<dynamic> geoFenceData = Rx<dynamic>(null);
  Rx<String> createdGeoFenceId = Rx<String>('');
  Rx<String> sharedUrl = Rx<String>('');
  Rx<dynamic> selectedDeviceCheckChargeRequired = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceMaintainData = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceTollGuruPageData = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceData = Rx<dynamic>(null);
  Rx<dynamic> replayPositionsData = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceCreditLogsData = Rx<dynamic>(null);
  Rx<dynamic> submitTollGuruData = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceCommandDetailsData = Rx<dynamic>(null);
  Rx<dynamic> selectedDevicePlData = Rx<dynamic>(null);
  Rx<dynamic> addDeviceDataResult = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceEmnifyConnectivity = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceSharePageData = Rx<dynamic>(null);
  Rx<dynamic> selectedGeoFenceData = Rx<dynamic>(null);
  Rx<dynamic> positionsHistoryData = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceCreditLogs = Rx<dynamic>(null);
  Rx<dynamic> selectedDeviceChargeData = Rx<dynamic>(null);
  Rx<dynamic> installerCommandDetails = Rx<dynamic>(null);
  DeviceController({required this.deviceRepository});

  Future<void> getMainPageData() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getMainPageData();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        mainPageData.value = data;
      },
    );
  }

  Future<void> getDeviceMaintainData(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getDeviceMaintainData(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceMaintainData.value = data;
      },
    );
  }

  Future<void> getDeviceCommandsDetail(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getDeviceCommandsDetail(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceCommandDetailsData.value = data;
      },
    );
  }

  Future<void> updateDeviceMaintainData(String id, dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateDeviceMaintainData(id, params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceMaintainData.value = data;
      },
    );
  }

  Future<void> getSelectedDeviceData(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getSelectedDeviceData(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceData.value = data;
      },
    );
  }

  Future<void> getTollGuruPageData(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getTollGuruPageData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceTollGuruPageData.value = data;
      },
    );
  }

  Future<void> getDeviceCheckChargeRequired(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getDeviceCheckChargeRequired();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceCheckChargeRequired.value = data;
      },
    );
  }

  Future<void> checkEmnifyConnectivity(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.checkEmnifyConnectivity(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceEmnifyConnectivity.value = data;
      },
    );
  }

  Future<void> replayPositions(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getDeviceMaintainData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        replayPositionsData.value = data;
      },
    );
  }

  Future<void> sendCommand(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.sendCommand(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> submitTollGuru(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.submitTollGuru(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        submitTollGuruData.value = data;
      },
    );
  }

  Future<void> getCreditLogsByDeviceId(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getCreditLogsByDeviceId(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceCreditLogsData.value = data;
      },
    );
  }

  Future<void> getPlData(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getPlData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDevicePlData.value = data;
      },
    );
  }

  Future<void> getChartData(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getChartData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> deletePlItem(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.deletePlItem(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> addPlItem(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.addPlItem(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> addCreditLogs(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.addCreditLogs(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> setBillingSource(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.setBillingSource(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> updateSelectedDeviceData(String id, dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateSelectedDeviceData(id, params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> saveLockUnlockSetting(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.saveLockUnlockSetting(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> setDeviceVoltage(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.setDeviceVoltage(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> updateNotficationSettings(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateNotficationSettings(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> uploadDeviceImage(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.uploadDeviceImage(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> setUserDevicesTintAi() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.setUserDevicesTintAi();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> setUserDevicesAbi() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.setUserDevicesAbi();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> addDeviceData(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.addDeviceData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        addDeviceDataResult.value = data;
      },
    );
  }

  Future<void> getSelectedShareDevicePageData(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getSelectedShareDevicePageData(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceSharePageData.value = data;
      },
    );
  }

  Future<void> getGeoFenceList() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getGeoFenceList();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        geoFenceData.value = data;
      },
    );
  }

  Future<void> updateShareSetting(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateShareSetting(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        sharedUrl.value = data['shareUrl'];
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> deleteGeoFenceById(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.deleteGeoFenceById(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> getGeoFenceById(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getGeoFenceById(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedGeoFenceData.value = data;
      },
    );
  }

  Future<void> updateSelectedGeoFenceById(String id, dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateSelectedGeoFenceById(id, params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> createGeoFence(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.createGeoFence(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        createdGeoFenceId.value = data['id'].toString();
      },
    );
  }

  Future<void> getPositionsHistory(
      String deviceId, String from, String to) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getPositionsHistory(deviceId, from, to);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        positionsHistoryData.value = data;
      },
    );
  }

  Future<void> checkChargeRequired(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.checkChargeRequired(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceChargeData.value = data;
      },
    );
  }

  Future<void> getCreditLogs(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getCreditLogs(id);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        selectedDeviceCreditLogs.value = data;
      },
    );
  }

  Future<void> cancelService(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.cancelService(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        cancelServiceData.value = data;
      },
    );
  }

  Future<void> updateShockSensorSetting(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateShockSensorSetting(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> updateBluetoothSetting(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateBluetoothSetting(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> sendInstallerCommand(
      String command, String deviceId, String userId) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.sendInstallerCommand(command, deviceId, userId);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> getInstallerCommandDetails(String deviceId) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.getInstallerCommandDetails(deviceId);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        installerCommandDetails.value = data;
      },
    );
  }

  Future<void> lockAndUnlockInstallerDevices(
      String deviceId, dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.lockAndUnlockInstallerDevices(deviceId, params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> installerDeviceSetVoltage(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.installerDeviceSetVoltage(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> updateSharedTextTemplate(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await deviceRepository.updateSharedTextTemplate(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
      },
    );
  }
}

import 'package:get/get.dart';

class DataController extends GetxController {
  var currentIndex = 0.obs;
  var geoGeoFenceEditingEnabled = false.obs;
  var playingPostionsHistory = false.obs;
  var showPlayPositionsHistory = false.obs;
  var currentDeviceId = ''.obs;
  var currentScaleFactor = 1.0.obs;
  var selectedGeoFenceId = ''.obs;
  var onetimePaymentAmount = ''.obs;
  var installerPaymentUserId = ''.obs;
  var appBarTitleSize = 20.0.obs;
  var appBarHeight = 56.0.obs;
  var bottomAppBarHeight = 70.0.obs;
  var iconSize = 24.0.obs;
  var titleTextSize = 18.0.obs;
  var normalTextSize = 14.0.obs;
  var smallTextSize = 12.0.obs;
  var currentPaymentItemId = ''.obs;
  var updateMap = 0.obs;
  var updateDevice = 0.obs;
  // ignore: non_constant_identifier_names
  var webBaseURI = 'https://test.moovetrax.com'.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void setGeoFenceEditing(bool flag) {
    geoGeoFenceEditingEnabled.value = flag;
  }

  void setPlayingPostionsHistory(bool flag) {
    playingPostionsHistory.value = flag;
  }

  void updateMapScreen() {
    updateMap.value = updateMap.value + 1;
  }

  void setCurrentPaymentItemId(String id) {
    currentPaymentItemId.value = id;
  }

  void setOneTimePaymentAmountValue(String value) {
    onetimePaymentAmount.value = value;
  }

  void setInstallerPaymentUserId(String value) {
    installerPaymentUserId.value = value;
  }

  void updateCurrentDeviceId(String id) {
    currentDeviceId.value = id;
  }

  void setGeoFenceId(String id) {
    selectedGeoFenceId.value = id;
  }

  void setShowPlayPositionsHistory(bool flag) {
    showPlayPositionsHistory.value = flag;
  }

  void updateDevices() {
    updateDevice.value = updateDevice.value + 1;
  }

  void updateCurrentScaleFactor(double value) {
    if (value == 0) return;
    if (value < 0) return;
    currentScaleFactor.value = value;
    iconSize.value = 24.0 * value;
    appBarHeight.value = 56.0 * value;
    bottomAppBarHeight.value = 70.0 * value;
    appBarTitleSize.value = 20.0 * value;
    titleTextSize.value = 18.0 * value;
    normalTextSize.value = 14.0 * value;
    smallTextSize.value = 12.0 * value;
  }
}

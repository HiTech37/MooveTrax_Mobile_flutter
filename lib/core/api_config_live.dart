class ApiConfig {
  ApiConfig._();

  static const token = "";
  static const paypalSubscriptionUrl =
      "https://moovetrax.com/app-subscription-payment.html";
  static const paypalOneTimePaymentUrl =
      "https://moovetrax.com/app-one-time-payment.html";
  static const String siteUrl = "https://moovetrax.com/";
  static const String baseUrl = "https://moovetrax.com:8088/api";
  static const String shareSettingUrl = "https://moovetrax.com/temporary/";

  static const String webSocketUrl = "wss://moovetrax.com:8000/websocket";

  static const googleMapAkey = "AIzaSyBnxnshloFKsE9cI5xXgx4F_L9RZ1TQZhk";
  static const schematicsUrl = "http://install.moovetrax.com";
  static const String oemSignUpUrl = "https://moovetrax.com/oem-signup";
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String gogleMapAapiUrl = "https://maps.googleapis.com/maps/api/";
  // api urls
  static const String auth = '/auth';
  static const String installerAuth = '/installer-auth';
  static const String installerSignUp = '/installer-signup';
  static const String deviceSignUp = '/device-signup';
  static const String getTeslaSignupUri = '/tesla/get-login-url';
  static const String getSmartcarSignupUri = '/smartcar/get-login-url';
  static const String resetPassword = '/password/reset';
  static const String deleteAccount = '/user-profile/delete';
  static const String getIccidPrefixList = '/get-iccid-prefix-list';
  static const String checkGpsidIccidMatched = '/check-gpsid-iccid-matched';
  static const String checkInstallerDevice = '/check-installer-device';
  static const String event = '/warning/get-data-table';
  static const String command = '/command/get-data-table';
  static const String shareLinks = '/links/get-data-table';
  static const String coHost = '/devices/co-host/get-data-table';
  static const String addCoHost = '/devices/add-co-host';
  static const String deleteCoHost = '/devices/delete-co-host';
  static const String turoTrips = '/turo-trip/get-data-table';
  static const String turoTripParseQueue = '/turo-trip/parse-queue';
  static const String userNameList = '/user-name-list';
  static const String deviceMileAgeData = '/get-device-mileage-data';
  static const String userProfile = '/user-profile';
  static const String batchGenerateLinks =
      "/get-batch-generate-links-page-data";
  static const String saveTuroCallLinks = "/links/saveTuroCalLink";
  static const String setDevicesBillingSource =
      '/users/set-devices-billing-source';
  static const String getUserEscrowCarBalance = "/getUserEscrowCarBalance";
  static const String escrowLogs = "/escrowLogs";
  static const String devices = "/devices";
  static const String updateShareLinks = '/links';

  static const String deviceCheckChargeRequired =
      "/device-check-charge-required";
  static const String checkEmnifyConnectivity =
      "/devices/check-emnify-connectivity";
  static const String maintain = "/maint";
  static const String getTollGuruPageData =
      "/device-tollguru/get-tollguru-page-data";

  static const String submitTollGuru = "/device-tollguru/submit-tollguru";
  static const String replayPositions = "/positions";
  static const String deviceCommandDetail = '/userDeviceCommandsDetail';
  static const String deviceCommand = '/command';
  static const String saveLockUnlockSetting = '/devices/saveLockUnlockSetting';
  static const String setDeviceVoltage = "/device/set-device-voltage";
  static const String creditLogsByDeviceId = "/creditLogsByDeviceId";
  static const String addCreditLogs = "/creditLogs";
  static const String setBillingSource = "/devices/set-billing-source";
  static const String getPlData = "/device-pl/get-pl-data";
  static const String deletePlItem = "/device-pl/delete-pl";
  static const String addPlData = "/device-pl/save-pl-data";
  static const String getChartData = "/device-pl/get-chart-data";
  static const String notificationSetting = "/devices/notificationSetting";
  static const String uploadImage = "/devices/uploadImage";
  static const String cancelService = "/devices/cancel-service";
  static const String setUserDevicesAbi = "/users/set-user-devices-abi";
  static const String setUserDevicesTintAi = "/users/set-user-devices-tint-ai";
  static const String updateShareSetting = "/links/updateSetting";
  static const String geoFenceList = "/geofences/get-list";
  static const String deleteGeoFenceById = "/geofences";
  static const String getGeoFenceById = "/geofences";
  static const String createGeoFence = "/geofences";
  static const String updateGeoFenceById = "/geofences";
  static const String getSelectedShareDevicePageData =
      "/get-share-device-page-data";
  static const String positions = "/positions";
  static const String checkChargeRequired = "/device-check-charge-required";
  static const String creditLogs = "/creditLogsByDeviceId";
  static const String createPlan = "/payment/paypal/create-plan";
  static const String subscriptionComplete =
      "/payment/paypal/subscription-complete";
  static const String paymentComplete = "/payment/paypal/payment-complete";
  static const String installerPaymentComplete =
      "/payment/paypal/installer-payment-complete";
  static const String cancelSubscription =
      "/payment/paypal/cancel-subscription";
  static const String updatePlanPrice = "/payment/paypal/update-plan-price";
  static const String updateShockSensorSetting =
      "/devices/update-shock-sensor-setting";

  static const String updateBluetoothSetting =
      "/devices/update-bluetooth-setting";
  static const String sendInstallerAuthEmail = "/send-installer-auth-email";
  static const String installerCommand = "/installer-command";
  static const String installerCommandDetail = "/installer-commandsDetail";
  static const String installerDevices = "/installer-devices";
  static const String installerDeviceSetVoltage =
      "/installer-device/set-device-voltage";
  static const String updateSharedTextTemplate =
      '/devices/updateSharedTextTemplate';
  static const String updatePushToken = '/user/update_pushtoken';
  static const header = {
    'Authorization': 'Bearer $token',
    'content-Type': 'application/json',
  };
}

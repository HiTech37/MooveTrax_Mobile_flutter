import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/repository/auth/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController
    with StateMixin<dynamic>, BaseController {
  final AuthRepository authRepository;
  AuthController({required this.authRepository});

  final box = GetStorage();

  Map<String, dynamic>? get storageUserData => box.read('loginInfo');
  Rx<dynamic> iccidPrefixList = Rx<dynamic>(null);
  Rx<dynamic> checkInstallerDeviceResult = Rx<dynamic>(null);
  Rx<dynamic> checkGpsidIccidMatchedResult = Rx<dynamic>(null);
  Rx<dynamic> profileData = Rx<dynamic>(null);
  Rx<dynamic> teslaSignupUri = Rx<dynamic>(null);
  Rx<dynamic> smartcarSignupUri = Rx<dynamic>(null);
  Rx<dynamic> userEscrowCarBalance = Rx<dynamic>(null);
  Rx<dynamic> escrowLogs = Rx<dynamic>(null);
  Rx<dynamic> deviceLoginData = Rx<dynamic>(null);
  Rx<dynamic> installerSignUpResult = Rx<dynamic>(null);
  Rx<dynamic> deviceSignupResult = Rx<dynamic>(null);
  Rx<dynamic> installerData = Rx<dynamic>(null);

  String? get installerKey => box.read('installerKey');
  Future<void> saveUserData(Map<String, dynamic> storageUserData) async {
    await box.write('loginInfo', storageUserData);
  }

  Future<void> saveInstallerKey(String installerKey) async {
    await box.write('installerKey', installerKey);
  }

  Future<void> removeUserData() async {
    await box.write('loginInfo', null);
    await box.write('deviceSortKey', '');
    await box.write('installerKey', null);
  }

  Future<void> saveSortKey(String key) async {
    await box.write('deviceSortKey', key);
  }

  Future<void> saveSortDirection(String direction) async {
    await box.write('sortDirection', direction);
  }

  Future<void> login(dynamic userInfo) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.login(userInfo);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) async {
        await saveUserData(data);
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> updatePushToken(dynamic tokenInfo) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.updatePushToken(tokenInfo);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) async {
        apiStatus.value = ApiState.success;
      },
    );
  }

  Future<void> installerLogin(dynamic deviceInfo) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.installerLogin(deviceInfo);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        deviceLoginData.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> installerSignUp(dynamic data) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.installerSignUp(data);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        installerSignUpResult.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> deviceSignup(dynamic data) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.deviceSignup(data);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        deviceSignupResult.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> getUserProfile() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getUserProfile();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        profileData.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> getTeslaSignupUri() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getTeslaSignupUri();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        teslaSignupUri.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> getSmartcarSignupUri() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getSmartcarSignupUri();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        smartcarSignupUri.value = data;
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> updateUserProfile(dynamic profile) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.updateUserProfile(profile);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> checkInstallerDevice(dynamic deviceInfo) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.checkInstallerDevice(deviceInfo);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        checkInstallerDeviceResult.value = data['device'];
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> checkGpsidIccidMatched(dynamic data) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.checkGpsidIccidMatched(data);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        checkGpsidIccidMatchedResult.value = data;
        if (data['token'] != null && data['token'] != '') {
          saveInstallerKey(data['token']);
        }
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> getIccidPrefixList() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getIccidPrefixList();
    failureOrSuccess.fold(
      (String failure) {
        iccidPrefixList.value = [];
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        iccidPrefixList.value = data['iccidPrefixList'];
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> resetPassword(dynamic emailInfo) async {
    apiStatus.value = ApiState.loading;
    Either<String, bool> failureOrSuccess =
        await authRepository.resetPassword(emailInfo);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (bool flag) {
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
      },
    );
  }

  Future<void> logOut() async {
    apiStatus.value = ApiState.loading;
    Either<String, bool> failureOrSuccess = await authRepository.logout();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (bool flag) async {
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
        await removeUserData();
        await resetApp();
      },
    );
  }

  Future<void> installerLogOut(String key) async {
    apiStatus.value = ApiState.loading;
    Either<String, bool> failureOrSuccess =
        await authRepository.installerLogOut(key);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (bool flag) async {
        apiStatus.value = ApiState.success;
        errorMessage.value = '';
        await resetApp();
        await removeUserData();
      },
    );
  }

  Future<void> getUserEscrowCarBalance() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getUserEscrowCarBalance();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        userEscrowCarBalance.value = data;
      },
    );
  }

  Future<void> getEscrowLogs() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getEscrowLogs();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        escrowLogs.value = data;
      },
    );
  }

  Future<void> setDevicesBillingSource() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.setDevicesBillingSource();
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

  Future<void> getInstallerAuth(String key) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.getInstallerAuth(key);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        installerData.value = data;
      },
    );
  }

  Future<void> sendInstallerAuthEmail(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.sendInstallerAuthEmail(params);
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

  Future<void> deleteAccount(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await authRepository.deleteAccount(params);
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

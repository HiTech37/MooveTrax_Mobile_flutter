import 'package:dio/dio.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:moovetrax/data/api/auth/auth_api.dart';
import 'package:dartz/dartz.dart';

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

class AuthRepository {
  final AuthApi authApi;

  AuthRepository({required this.authApi});

  Future<Either<String, dynamic>> login(dynamic userInfo) async {
    return checkItemDataFailOrSuccess(authApi.login(userInfo));
  }

  Future<Either<String, dynamic>> updatePushToken(dynamic tokenInfo) async {
    return checkItemDataFailOrSuccess(authApi.updatePushToken(tokenInfo));
  }

  Future<Either<String, dynamic>> checkGpsidIccidMatched(dynamic data) async {
    return checkItemDataFailOrSuccess(authApi.checkGpsidIccidMatched(data));
  }

  Future<Either<String, dynamic>> checkInstallerDevice(
      dynamic deviceInfo) async {
    return checkItemDataFailOrSuccess(authApi.checkInstallerDevice(deviceInfo));
  }

  Future<Either<String, dynamic>> getIccidPrefixList() async {
    return checkItemDataFailOrSuccess(authApi.getIccidPrefixList());
  }

  Future<Either<String, dynamic>> setDevicesBillingSource() async {
    return checkItemDataFailOrSuccess(authApi.setDevicesBillingSource());
  }

  Future<Either<String, dynamic>> getUserEscrowCarBalance() async {
    return checkItemDataFailOrSuccess(authApi.getUserEscrowCarBalance());
  }

  Future<Either<String, dynamic>> getEscrowLogs() async {
    return checkItemDataFailOrSuccess(authApi.getEscrowLogs());
  }

  Future<Either<String, dynamic>> getUserProfile() async {
    return checkItemDataFailOrSuccess(authApi.getUserProfile());
  }

  Future<Either<String, dynamic>> updateUserProfile(dynamic profile) async {
    return checkItemDataFailOrSuccess(authApi.updateUserProfile(profile));
  }

  Future<Either<String, bool>> logout() async {
    return checkItemFailOrSuccess(authApi.logOut());
  }

  Future<Either<String, bool>> installerLogOut(String key) async {
    return checkItemFailOrSuccess(authApi.installerLogOut(key));
  }

  Future<Either<String, dynamic>> installerLogin(dynamic deviceInfo) async {
    return checkItemDataFailOrSuccess(authApi.installerLogin(deviceInfo));
  }

  Future<Either<String, dynamic>> installerSignUp(dynamic data) async {
    return checkItemDataFailOrSuccess(authApi.installerSignUp(data));
  }

  Future<Either<String, dynamic>> deviceSignup(dynamic data) async {
    return checkItemDataFailOrSuccess(authApi.deviceSignup(data));
  }

  Future<Either<String, bool>> resetPassword(dynamic emailInfo) async {
    return checkItemFailOrSuccess(authApi.resetPassword(emailInfo));
  }

  Future<Either<String, dynamic>> getInstallerAuth(String key) async {
    return checkItemDataFailOrSuccess(authApi.getInstallerAuth(key));
  }

  Future<Either<String, dynamic>> sendInstallerAuthEmail(dynamic params) async {
    return checkItemDataFailOrSuccess(authApi.sendInstallerAuthEmail(params));
  }

  Future<Either<String, dynamic>> deleteAccount(dynamic userID) async {
    return checkItemDataFailOrSuccess(authApi.deleteAccount(userID));
  }
}

import 'package:flutter/foundation.dart';
import 'package:moovetrax/common/network/dio_client.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:moovetrax/core/app_extension.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final DioClient dioClient;
  AuthApi({required this.dioClient});

  Future<bool> registerUser(dynamic userInfo) async {
    return true;
  }

  Future<dynamic> login(dynamic userInfo) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.auth, data: userInfo);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> updatePushToken(dynamic tokenInfo) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.updatePushToken, data: tokenInfo);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> checkInstallerDevice(dynamic deviceInfo) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.checkInstallerDevice, data: deviceInfo);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> checkGpsidIccidMatched(dynamic gpsIdIccidInfo) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.checkGpsidIccidMatched, data: gpsIdIccidInfo);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> setDevicesBillingSource() async {
    final Response response =
        await dioClient.dio.post(ApiConfig.setDevicesBillingSource);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getUserEscrowCarBalance() async {
    final Response response =
        await dioClient.dio.get(ApiConfig.getUserEscrowCarBalance);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getEscrowLogs() async {
    final Response response = await dioClient.dio.get(ApiConfig.escrowLogs);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getIccidPrefixList() async {
    final Response response = await dioClient.dio.get(
      ApiConfig.getIccidPrefixList,
    );
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getUserProfile() async {
    try {
      final Response response = await dioClient.dio.get(
        ApiConfig.userProfile,
      );
      if (response.statusCode.success) {
        return response.data;
      } else {
        throw DioExceptions;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<dynamic> getTeslaSignupUri() async {
    try {
      final Response response = await dioClient.dio.get(
        ApiConfig.getTeslaSignupUri,
      );
      if (response.statusCode.success) {
        return response.data;
      } else {
        throw DioExceptions;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<dynamic> getSmartcarSignupUri() async {
    try {
      final Response response = await dioClient.dio.get(
        ApiConfig.getSmartcarSignupUri,
      );
      if (response.statusCode.success) {
        return response.data;
      } else {
        throw DioExceptions;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<dynamic> updateUserProfile(dynamic profileData) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.userProfile, data: profileData);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<bool> resetPassword(dynamic emailInfo) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.resetPassword, data: emailInfo);
    if (response.statusCode.success) {
      return true;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> installerLogin(dynamic deviceInfo) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.installerAuth, data: deviceInfo);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> installerSignUp(dynamic data) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.installerSignUp, data: data);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deviceSignup(dynamic data) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.deviceSignUp, data: data);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<bool> logOut() async {
    final Response response = await dioClient.dio.delete(ApiConfig.auth);
    if (response.statusCode.success) {
      return true;
    } else {
      throw DioExceptions;
    }
  }

  Future<bool> installerLogOut(String key) async {
    final Response response =
        await dioClient.dio.delete('${ApiConfig.installerAuth}/$key');
    if (response.statusCode.success) {
      return true;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> getInstallerAuth(String key) async {
    final Response response =
        await dioClient.dio.get('${ApiConfig.installerAuth}/$key');
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> sendInstallerAuthEmail(dynamic params) async {
    final Response response = await dioClient.dio
        .post(ApiConfig.sendInstallerAuthEmail, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }

  Future<dynamic> deleteAccount(dynamic params) async {
    final Response response =
        await dioClient.dio.post(ApiConfig.deleteAccount, data: params);
    if (response.statusCode.success) {
      return response.data;
    } else {
      throw DioExceptions;
    }
  }
}

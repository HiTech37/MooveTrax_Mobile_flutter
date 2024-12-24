import 'package:moovetrax/data/api/device/device_api.dart';
import 'package:moovetrax/data/api/payment/payment_api.dart';
import 'package:moovetrax/data/api/reports/reports_api.dart';
import 'package:moovetrax/repository/device/device_repository.dart';
import 'package:moovetrax/repository/reports/reports_repository.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/common/network/dio_client.dart';
import 'package:moovetrax/data/api/auth/auth_api.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';
import 'repository/auth/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //Dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // Auth api
  getIt.registerLazySingleton<AuthApi>(
      () => AuthApi(dioClient: getIt<DioClient>()));

  // Auth repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authApi: getIt<AuthApi>()),
  );

  //AuthController
  getIt.registerFactory(
    () => AuthController(authRepository: getIt<AuthRepository>()),
  );

  // Reports api
  getIt.registerLazySingleton<ReportsApi>(
      () => ReportsApi(dioClient: getIt<DioClient>()));

  getIt.registerLazySingleton<PaymentApi>(
      () => PaymentApi(dioClient: getIt<DioClient>()));

  // Reports repository
  getIt.registerLazySingleton<ReportsRepository>(
    () => ReportsRepository(reportsApi: getIt<ReportsApi>()),
  );

  //Reports Controller
  getIt.registerFactory(
    () => ReportsController(reportsRepository: getIt<ReportsRepository>()),
  );

  // Device api
  getIt.registerLazySingleton<DeviceApi>(
      () => DeviceApi(dioClient: getIt<DioClient>()));

  // Device repository
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepository(deviceApi: getIt<DeviceApi>()),
  );

  //Device Controller
  getIt.registerFactory(
    () => DeviceController(deviceRepository: getIt<DeviceRepository>()),
  );
}

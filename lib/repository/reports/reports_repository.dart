import 'package:dio/dio.dart';
import 'package:moovetrax/common/network/dio_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:moovetrax/data/api/reports/reports_api.dart';

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

class ReportsRepository {
  final ReportsApi reportsApi;

  ReportsRepository({required this.reportsApi});

  Future<Either<String, dynamic>> getEvents(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getEvents(params));
  }

  Future<Either<String, dynamic>> getCommands(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getCommands(params));
  }

  Future<Either<String, dynamic>> addCoHost(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.addCoHost(params));
  }

  Future<Either<String, dynamic>> saveTuroCallLinks(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.saveTuroCallLinks(params));
  }

  Future<Either<String, dynamic>> getBatchGeneratLinksPage() async {
    return checkItemDataFailOrSuccess(reportsApi.getBatchGeneratLinksPage());
  }

  Future<Either<String, dynamic>> deleteCoHost(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.deleteCoHost(params));
  }

  Future<Either<String, dynamic>> getTuroTrips(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getTuroTrips(params));
  }

  Future<Either<String, dynamic>> getTuroTripParseQueue(String id) async {
    return checkItemDataFailOrSuccess(reportsApi.getTuroTripParseQueue(id));
  }

  Future<Either<String, dynamic>> getSharedLinks(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getSharedLinks(params));
  }

  Future<Either<String, dynamic>> deleteSharedLinks(String linkId) async {
    return checkItemDataFailOrSuccess(reportsApi.deleteSharedLinks(linkId));
  }

  Future<Either<String, dynamic>> updateSharedLinks(
      String linkId, dynamic params) async {
    return checkItemDataFailOrSuccess(
        reportsApi.updateSharedLinks(linkId, params));
  }

  Future<Either<String, dynamic>> getCoHosts(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getCoHosts(params));
  }

  Future<Either<String, dynamic>> getMileAgeList(dynamic params) async {
    return checkItemDataFailOrSuccess(reportsApi.getMileAgeList(params));
  }

  Future<Either<String, dynamic>> getUserNameList() async {
    return checkItemDataFailOrSuccess(reportsApi.getUserNameList());
  }
}

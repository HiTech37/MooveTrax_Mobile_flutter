import 'package:dartz/dartz.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:moovetrax/repository/reports/reports_repository.dart';

class ReportsController extends GetxController
    with StateMixin<dynamic>, BaseController {
  final ReportsRepository reportsRepository;
  Rx<dynamic> eventsData = Rx<dynamic>(null);
  Rx<dynamic> commandsData = Rx<dynamic>(null);
  Rx<dynamic> userNameList = Rx<dynamic>(null);
  Rx<dynamic> mileAgeData = Rx<dynamic>(null);
  Rx<dynamic> turoTripsData = Rx<dynamic>(null);
  Rx<dynamic> sharedLinksData = Rx<dynamic>(null);
  Rx<dynamic> coHostData = Rx<dynamic>(null);
  Rx<dynamic> batchGenerateData = Rx<dynamic>(null);

  ReportsController({required this.reportsRepository});

  Future<void> getEvents(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getEvents(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        eventsData.value = data;
      },
    );
  }

  Future<void> getTuroTrips(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getTuroTrips(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        turoTripsData.value = data;
      },
    );
  }

  Future<void> getTuroTripParseQueue(String id) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getTuroTripParseQueue(id);
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

  Future<void> getBatchGeneratLinksPage() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getBatchGeneratLinksPage();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        batchGenerateData.value = data;
      },
    );
  }

  Future<void> addCoHost(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.addCoHost(params);
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

  Future<void> saveTuroCallLinks(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.saveTuroCallLinks(params);
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

  Future<void> deleteCoHost(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.deleteCoHost(params);
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

  Future<void> getSharedLinks(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getSharedLinks(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        sharedLinksData.value = data;
      },
    );
  }

  Future<void> updateSharedLinks(String linkeId, dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.updateSharedLinks(linkeId, params);
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

  Future<void> deleteSharedLinks(String linkeId) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.deleteSharedLinks(linkeId);
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

  Future<void> getCoHosts(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getCoHosts(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        coHostData.value = data;
      },
    );
  }

  Future<void> getCommands(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getCommands(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        commandsData.value = data;
      },
    );
  }

  Future<void> getMileAgeList(dynamic params) async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getMileAgeList(params);
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        mileAgeData.value = data;
      },
    );
  }

  Future<void> getUserNameList() async {
    apiStatus.value = ApiState.loading;
    Either<String, dynamic> failureOrSuccess =
        await reportsRepository.getUserNameList();
    failureOrSuccess.fold(
      (String failure) {
        apiStatus.value = ApiState.failure;
        errorMessage.value = failure;
      },
      (dynamic data) {
        apiStatus.value = ApiState.success;
        userNameList.value = data;
      },
    );
  }
}

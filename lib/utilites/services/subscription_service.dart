import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/subscription.dart';
import 'package:upstorage_desktop/models/tariff.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

@injectable
class SubscriptionService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  SubscriptionService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<Subscription?> getCurrentSubscription() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        var path = '/subscription/current';

        var response = await _dio.get(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );

        if (response.statusCode == 200) {
          var currentSub = Subscription.fromMap(response.data);
          return currentSub;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Tariff?> getNumberTariffAll() async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/tariff/all';

      var response = await _dio.get(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        var numberTariff = Tariff.fromMap(response.data[0]);
        return numberTariff;
      }
    } catch (e) {
      print(e);
    }
  }
}

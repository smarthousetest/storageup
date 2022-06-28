import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';
import 'package:upstorage_desktop/constants.dart';

@Injectable()
class KeeperService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  KeeperService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<List<Keeper>?> getAllKeepers() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        var response = await _dio.get(
          '/keeper/own',
          options: Options(headers: {
            'Authorization': ' Bearer $token',
          }),
        );

        if (response.statusCode == 200) {
          //final body = Keeper.fromJson(response);
          List<Keeper> allKeeper = [];
          (response.data as List).forEach((element) {
            allKeeper.add(Keeper.fromMap(element));
          });
          return allKeeper;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> addNewKeeper(String name, int countGb) async {
    for (int i = 0; i < 5; i++) {
      try {
        String? token = await _tokenRepository.getApiToken();
        var response = await _dio.post(
          '/keeper',
          options: Options(headers: {'Authorization': ' Bearer $token'}),
          data: {
            'data': {
              'name': name,
              "space": countGb * GB,
            }
          },
        );
        return response.data['id'];
      } on DioError catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<String?> changeKeeper(String name, int countGb, String id) async {
    for (int i = 0; i < 5; i++) {
      try {
        String? token = await _tokenRepository.getApiToken();
        var response = await _dio.put(
          '/keeper/$id',
          options: Options(headers: {'Authorization': ' Bearer $token'}),
          data: {
            'data': {
              'name': name,
              "space": countGb * GB,
            }
          },
        );
        return response.data['id'];
      } on DioError catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<bool?> changeSleepStatus(String id) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var response = await _dio.get(
        '/keeper/$id/change/sleepStatus',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print(response);
        return response.data['sleepStatus'];
      } else
        return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

import 'package:cpp_native/cpp_native.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/keeper/keeper.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';

@Injectable()
class KeeperService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  KeeperService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<Either<ResponseStatus, List<Keeper>?>> getAllKeepers() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        var response = await _dio.get(
          '/keeper/own',
          options: Options(headers: {
            'Authorization': ' Bearer $token',
          }),
        );
        List<Keeper> allKeeper = [];
        (response.data as List).forEach((element) {
          allKeeper.add(Keeper.fromMap(element));
        });
        return Either.right(allKeeper);
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 429 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 504) {
        return Either.left(ResponseStatus.declined);
      } else {
        return Either.left(ResponseStatus.failed);
      }
    }
    return Either.left(ResponseStatus.ok);
  }

  Future<Either<ResponseStatus, String?>> addNewKeeper(
      String name, int countGb) async {
    for (int i = 0; i < 5; i++) {
      try {
        String? token = await _tokenRepository.getApiToken();
        var response = await _dio.post(
          '/keeper',
          options: Options(
            headers: {
              'Authorization': ' Bearer $token',
            },
          ),
          data: {
            'data': {
              'name': name,
              "space": countGb * GB,
            }
          },
        );
        return Either.right(response.data['id']);
      } on DioError catch (e) {
        print(e);
        if (e.response?.statusCode == 401 ||
            e.response?.statusCode == 429 ||
            e.response?.statusCode == 500 ||
            e.response?.statusCode == 502 ||
            e.response?.statusCode == 504) {
          return Either.left(ResponseStatus.declined);
        } else {
          return Either.left(ResponseStatus.failed);
        }
      }
    }
    return Either.left(ResponseStatus.ok);
  }

  Future<Either<ResponseStatus, bool?>> changeSleepStatus(
      String id, bool sleepStatus) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var response = await _dio.put(
        '/keeper/$id',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: {
          'data': {
            'sleepStatus': sleepStatus,
          }
        },
      );

      if (response.statusCode == 200) {
        print(response);
        return Either.right(response.data['sleepStatus']);
      } else
        return Either.right(response.data);
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 429 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 504) {
        return Either.left(ResponseStatus.declined);
      } else {
        return Either.left(ResponseStatus.failed);
      }
    }
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
}

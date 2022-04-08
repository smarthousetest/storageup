import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/list.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

@Injectable()
class KeeperService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  KeeperService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<List<Keeper>?> getAllKeepers() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        var path = '/keeper/own';

        var response = await _dio.get(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
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
  }

  Future<String?> addNewKeeper(String name, int countGb) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/keeper';

      var data = {
        'data': {
          'name': name,
          "space": countGb,
        }
      };

      var response = await _dio.post(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data['id'];
      }
    } catch (e) {
      print(e);
    }
  }
}

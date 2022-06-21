import 'package:cpp_native/cpp_native.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/packet/packet.dart';
import 'package:upstorage_desktop/models/subscription.dart';
import 'package:upstorage_desktop/models/tariff.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/packet_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/token_repository.dart';

@Injectable()
class SubscriptionService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  SubscriptionService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final PacketRepository _packetRepository =
      getIt<PacketRepository>(instanceName: 'packet_repo');

  Future<Either<Subscription?, ResponseStatus>> getCurrentSubscription() async {
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
          return Either(left: currentSub);
        }
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 429 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 504) {
        return Either(right: ResponseStatus.declined);
      } else {
        return Either(right: ResponseStatus.failed);
      }
    }
    return Either(right: ResponseStatus.ok);
  }

  Future<List<Tariff>?> getAllTariffs() async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/tariff/all';

      var response = await _dio.get(
        path,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        List<Tariff> tariffs = [];
        (response.data as List).forEach((element) {
          tariffs.add(Tariff.fromMap(element));
        });
        return tariffs;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ResponseStatus?> changeSubscription(String currentSub) async {
    try {
      String? token = await _tokenRepository.getApiToken();

      var path = '/subscription/current';

      var data = {
        'tariff': currentSub,
      };

      var response = await _dio.put(
        path,
        data: data,
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return ResponseStatus.ok;
      } else
        return ResponseStatus.failed;
    } catch (e) {
      print(e);
      return ResponseStatus.failed;
    }
  }

  Future<ResponseStatus?> getPacketInfo() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        var path = '/packet/current';

        var response = await _dio.get(
          path,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );

        if (response.statusCode == 200) {
          // List<Packet> packetInfo = [];
          // (response.data as List).forEach((element) {
          //   packetInfo.add(Packet.fromMap(element));
          // });
          _packetRepository.setPacketInfo = Packet.fromMap(response.data);
          return ResponseStatus.ok;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

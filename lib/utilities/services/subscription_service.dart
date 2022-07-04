import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/packet/packet.dart';
import 'package:storageup/models/subscription.dart';
import 'package:storageup/models/tariff.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/packet_repository.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';

@Injectable()
class SubscriptionService {
  final Dio _dio = getIt<Dio>(instanceName: 'record_dio');

  SubscriptionService();

  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final PacketRepository _packetRepository =
      getIt<PacketRepository>(instanceName: 'packet_repo');

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
    return null;
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

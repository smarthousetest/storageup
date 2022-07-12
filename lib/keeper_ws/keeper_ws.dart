import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:storageup/keeper_ws/types/ProxyProperties.dart';
import 'package:web_socket_channel/io.dart';
import 'package:storageup/constants.dart';

class KeeperWs {
  String bearerToken;
  late String proxyUrl;
  Dio storageup = Dio(
    BaseOptions(
      baseUrl: "$kServerUrl/api/tenant/tenant",
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  );

  KeeperWs({required this.bearerToken});

  Future setProxyUrl() async {
    try {
      var response = await storageup.get("/proxy");
      var proxyProperties = proxyPropertiesFromJson(response.data);
      if (proxyProperties.proxyIP != null &&
          proxyProperties.proxyPORT != null) {
        proxyUrl = "${proxyProperties.proxyIP}:${proxyProperties.proxyPORT}";
      }
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }

  void sendKeeperDeleteToProxy(String keeperId) async {
    var proxyUrl = await setProxyUrl();
    if (proxyUrl == null) {
      return;
    }
    var channel = IOWebSocketChannel.connect(proxyUrl);
    try {
      channel.sink.add(
        json.encode({
          "messageType": "delete_keeper",
          "keeperId": keeperId,
        }),
      );
    } catch (e) {
      print("[sendKeeperDeleteToProxy] $e");
    }
  }
}

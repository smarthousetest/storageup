import 'dart:io';

import 'package:cpp_native/interfaces/load_interfaces.dart';
import 'package:injectable/injectable.dart';
import 'package:os_specification/os_specification.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _api_token = "bearer_token";

enum RepositoryEnum { goodResponse, error }

@singleton
class TokenRepository extends ITokenRepository {
  String? token = null;

  Future<RepositoryEnum> setApiToken(String token,
      [bool isNeedSave = true]) async {
    try {
      if (isNeedSave) {
        writeBearerTokenToFile(token);
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString(_api_token, token);
        return RepositoryEnum.goodResponse;
      } else {
        this.token = token;
        return RepositoryEnum.goodResponse;
      }
    } on Exception {
      return RepositoryEnum.error;
    }
  }

  Future<String?> getApiToken() async {
    try {
      await null;
      if (token != null) {
        return token;
      }

      var prefs = await SharedPreferences.getInstance();
      final result = prefs.getString(_api_token);
      return result;
    } on Exception {
      return null;
    }
  }

  File writeBearerTokenToFile(String bearerToken) {
    var os = OsSpecifications.getOs();
    if (os.supportDir.isEmpty) {
      os.supportDir = "${Directory.current.path}${Platform.pathSeparator}";
    }
    var bearerTokenFile = File('${os.supportDir}/bearerToken');

    if (!bearerTokenFile.existsSync()) {
      bearerTokenFile.createSync(recursive: true);
    }
    bearerTokenFile.writeAsStringSync(bearerToken);
    return bearerTokenFile;
  }
}

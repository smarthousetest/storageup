import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

  const _api_token = "bearer_token";

enum RepositoryEnum { goodResponse, error }

@injectable
class TokenRepository {
  Future<RepositoryEnum> setApiToken(String token) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString(_api_token, token);
      return RepositoryEnum.goodResponse;
    } on Exception {
      return RepositoryEnum.error;
    }
  }

  Future<String?> getApiToken() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      final result = prefs.getString(_api_token);
      return result;
    } on Exception {
      return null;
    }
  }
}

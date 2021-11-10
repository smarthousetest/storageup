import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/utilities/repositories/token_repository.dart';

import '../enums.dart';
import '../injection.dart';

@Injectable()
class AuthService {
  static const BASE_URL = 'https://upstorage.net/api/auth';

  final Dio _dio;
  AuthService(@Named('auth_dio') this._dio);

  final TokenRepository _tokenRepository = getIt<TokenRepository>();

  Future<AuthenticationStatus> signInByCredentials(
      {required String email, required String password}) async {
    try {
      final query = {'email': email, 'password': password};
      final response = await _dio.post('/sign-in', data: query);
      if (response.statusCode == 200) {
        await _tokenRepository.setApiToken(response.toString());
        return AuthenticationStatus.authenticated;
      } else {
        return AuthenticationStatus.unauthenticated;
      }
    } on DioError catch (e) {
      _printDioError(e);
      if (e.response?.statusCode == 400)
        return AuthenticationStatus.wrongPassword;
      else
        return AuthenticationStatus.unauthenticated;
    }
  }

  Future<AuthenticationStatus> restorePassword({required String email}) async {
    try {
      final query = {'email': email};
      final response =
          await _dio.post('/send-password-reset-email', data: query);
      if (response.statusCode == 200) {
        return AuthenticationStatus.authenticated;
      } else {
        return AuthenticationStatus.unauthenticated;
      }
    } on DioError catch (e) {
      _printDioError(e);
      return AuthenticationStatus.unauthenticated;
    }
  }

  Future<AuthenticationStatus> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final query = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };

      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.put(
          '/change-password',
          data: query,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        if (response.statusCode == 200)
          return AuthenticationStatus.authenticated;
        else
          return AuthenticationStatus.unauthenticated;
      } else
        return AuthenticationStatus.externalError;
    } on DioError catch (e) {
      if (e.response?.statusCode == 400)
        return AuthenticationStatus.wrongPassword;
      else
        return AuthenticationStatus.unauthenticated;
    }
  }

  // Future<AuthEnum> signInByToken() {
  //   try {
  //     final token = _tokenRepository.getApiToken();
  //     final query = {}
  //   } catch (e) {

  //   }
  // }

  Future<AuthenticationStatus> register(
      {required String email, required String password}) async {
    try {
      final query = {'email': email, 'password': password};
      final response = await _dio.post('/sign-up', data: query);
      print(response);
      if (response.statusCode == 200) {
        await _tokenRepository.setApiToken(response.toString());
        return AuthenticationStatus.authenticated;
      } else {
        return AuthenticationStatus.unauthenticated;
      }
    } on DioError catch (e) {
      _printDioError(e);
      if (e.response?.statusCode == 400)
        return AuthenticationStatus.emailAllreadyRegistered;
      else
        return AuthenticationStatus.unauthenticated;
    }
  }

  Future<AuthenticationStatus> verifyEmail() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      //final query = {'token': token};
      final response = await _dio.post(
        '/send-email-address-verification-email',
        options: Options(headers: {'Authorization': ' Bearer $token'}),
      );
      print(response);
      if (response.statusCode == 200) {
        return AuthenticationStatus.authenticated;
      } else {
        return AuthenticationStatus.unauthenticated;
      }
    } on DioError catch (e) {
      print('email verification failed');
      return AuthenticationStatus.unauthenticated;
    }
  }

  void _printDioError(DioError e) {
    if (e.response != null) {
      print(e.response?.data);
      print(e.response?.statusCode);
      print(e.response?.realUri);
    } else {
      print(e.error);
      print(e.message);
    }
  }
}

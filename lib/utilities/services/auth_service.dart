import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/utilities/repositories/token_repository.dart';
import 'package:storageup/utilities/repositories/user_repository.dart';

import '../injection.dart';

@Injectable()
class AuthService {
  static const BASE_URL = 'https://storageup.net/api/auth';

  final Dio _dio;

  AuthService(@Named('auth_dio') this._dio);

  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final UserRepository _userRepository =
      getIt<UserRepository>(instanceName: 'user_repo');

  Future<AuthenticationStatus> signInByCredentials(
      {required String email,
      required String password,
      bool isNeedSave = true}) async {
    try {
      final query = {'email': email, 'password': password};
      final response = await _dio.post('/sign-in', data: query);
      if (response.statusCode == 200) {
        await _tokenRepository.setApiToken(response.toString(), isNeedSave);
        await getUserInfo();
        return AuthenticationStatus.authenticated;
      } else {
        return AuthenticationStatus.unauthenticated;
      }
    } on DioError catch (e) {
      _printDioError(e);
      if (e.response?.statusCode == 400)
        return AuthenticationStatus.wrongPassword;
      else if (e.response?.statusCode == 403)
        return AuthenticationStatus.notVerifiedEmail;
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
      if (e.response?.statusCode == 400) {
        return AuthenticationStatus.unauthenticated;
      } else if (e.response?.statusCode == 429 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 504)
        return AuthenticationStatus.externalError;
      else
        return AuthenticationStatus.noInternet;
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
      else if (e.response?.statusCode == 401)
        return AuthenticationStatus.unauthenticated;
      else if (e.response?.statusCode == 403 ||
          e.response?.statusCode == 429 ||
          e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 504)
        return AuthenticationStatus.externalError;
      else
        return AuthenticationStatus.noInternet;
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
      print(e);
      print('email verification failed');
      return AuthenticationStatus.unauthenticated;
    }
  }

  Future<AuthenticationStatus> getUserInfo() async {
    try {
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.get(
          '/me',
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        if (response.statusCode == 200 &&
            response.data['emailVerified'] == true) {
          _userRepository.setUser = User.fromJson(response.data);
          return AuthenticationStatus.authenticated;
        } else
          return AuthenticationStatus.unauthenticated;
      } else
        return AuthenticationStatus.externalError;
    } on DioError catch (_) {
      return AuthenticationStatus.unauthenticated;
    }
  }

  Future<AuthenticationStatus> changeName({required String name}) async {
    try {
      var user = _userRepository.getUser;
      String? url = '';
      if (user?.avatars != null && user!.avatars!.isNotEmpty)
        url = user.avatars?.first.publicUrl;
      final query = {
        'data': {
          "firstName": name,
          'lastName': user?.lastName,
          'phoneNumber': user?.phoneNumber,
          'avatars': [
            {
              'publicUrl': url,
            }
          ]
        }
      };
      String? token = await _tokenRepository.getApiToken();
      if (token != null && token.isNotEmpty) {
        final response = await _dio.put(
          '/profile',
          data: query,
          options: Options(headers: {'Authorization': ' Bearer $token'}),
        );
        if (response.statusCode == 200)
          return AuthenticationStatus.authenticated;
        else
          return AuthenticationStatus.unknown;
      }
      return AuthenticationStatus.unknown;
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401)
        return AuthenticationStatus.unauthenticated;
      else if (e.response?.statusCode == null)
        return AuthenticationStatus.noInternet;
      else
        return AuthenticationStatus.externalError;
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

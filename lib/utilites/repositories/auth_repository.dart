import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/utilites/services/auth_service.dart';

import 'package:upstorage_desktop/models/enums.dart';
import '../injection.dart';

@Singleton()
class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final AuthService _authService = getIt<AuthService>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield* _controller.stream;
  }

  Future<AuthenticationStatus> logIn({
    required String email,
    required String password,
  }) async {
    final response = await _authService.signInByCredentials(
        email: email, password: password);
    _controller.add(response);
    return response;
  }

  Future<AuthenticationStatus> restorePassword({required String email}) async {
    final response = await _authService.restorePassword(email: email);
    _controller.add(response);
    return response;
  }

  Future<AuthenticationStatus> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _authService.changePassword(
        oldPassword: oldPassword, newPassword: newPassword);
    _controller.add(response);
    return response;
  }

  Future<AuthenticationStatus> sendEmailConfirm() async {
    final response = await _authService.verifyEmail();
    _controller.add(response);
    return response;
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<AuthenticationStatus> register(
      {required String email, required String password}) async {
    final response =
        await _authService.register(email: email, password: password);
    _controller.add(response);
    return response;
  }

  void dispose() => _controller.close();
}

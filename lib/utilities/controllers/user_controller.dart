import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/repositories/user_repository.dart';
import 'package:storageup/utilities/services/auth_service.dart';
import 'package:storageup/utilities/services/files_service.dart';

@Injectable()
class UserController {
  UserRepository _repository = getIt<UserRepository>(instanceName: 'user_repo');

  AuthService _authService = getIt<AuthService>();
  FilesService _filesService = getIt<FilesService>();

  UserController() {
    if (!_repository.containUser()) {
      _authService.getUserInfo();
    }
  }

  Future<User?> updateUser() async {
    await _authService.getUserInfo();
    return _repository.getUser;
  }

  Future<User?> get getUser async => _repository.getUser;

  Future<void> changeName(String name) async {
    var user = _repository.getUser;
    var response = await _authService.changeName(name: name);

    if (response == AuthenticationStatus.authenticated) user?.firstName = name;

    _repository.setUser = user;
  }

  ValueNotifier<User?> getValueNotifier() => _repository.getValueNotifier;

  Future<ResponseStatus> changeProfilePic(String publicUrl) async {
    var user = _repository.getUser;
    var response = await _filesService.setProfilePic(
      url: publicUrl,
      user: user!,
    );
    if (response == ResponseStatus.ok) {
      await updateUser();

      // _repository.setUser = upUser;
      return ResponseStatus.ok;
    } else {
      return ResponseStatus.failed;
    }
  }

  set setUser(User user) => _repository.setUser = user;
}

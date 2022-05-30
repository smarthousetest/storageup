import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/repositories/user_repository.dart';
import 'package:upstorage_desktop/utilites/services/auth_service.dart';
import 'package:upstorage_desktop/utilites/services/files_service.dart';

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

  Future<ResponseStatus> changeProfilePic(String publicUrl) async {
    var user = _repository.getUser;
    var response =
        await _filesService.setProfilePic(url: publicUrl, user: user!);
    if (response == ResponseStatus.ok) {
      _repository.setUser = user;
      return ResponseStatus.ok;
    } else {
      return ResponseStatus.failed;
    }
  }

  set setUser(User user) => _repository.setUser = user;
}

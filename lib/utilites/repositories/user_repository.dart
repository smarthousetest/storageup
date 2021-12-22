import 'package:upstorage_desktop/models/user.dart';

class UserRepository {
  User? _user;

  bool containUser() {
    return _user != null;
  }

  User? get getUser => _user;

  set setUser(User? user) => _user = user;
}

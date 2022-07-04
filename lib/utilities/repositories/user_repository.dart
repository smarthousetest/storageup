import 'package:flutter/foundation.dart';
import 'package:storageup/models/user.dart';

class UserRepository {
  User? _user;

  final ValueNotifier<User?> _valueNotifier = ValueNotifier<User?>(null);

  ValueNotifier<User?> get getValueNotifier => _valueNotifier;

  bool containUser() {
    return _user != null;
  }

  User? get getUser => _valueNotifier.value;

  set setUser(User? user) => _valueNotifier.value = user;
}

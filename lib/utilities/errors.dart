import 'package:cpp_native/cpp_native.dart';

class ServerError extends Error {}

class LoadError extends Error {
  ErrorReason? reason;

  LoadError({required this.reason});
}

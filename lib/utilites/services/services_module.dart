import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/generated/l10n.dart';

@module
abstract class ServiceModule {
  @Singleton()
  S get s => S();

  @Named('auth_dio')
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: 'https://upstorage.net/api/auth'));
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/load_controller.dart';
import 'package:upstorage_desktop/utilites/controllers/packet_controllers.dart';
import 'package:upstorage_desktop/utilites/repositories/file_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/media_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/packet_repository.dart';
import 'package:upstorage_desktop/utilites/repositories/user_repository.dart';

@module
abstract class ServiceModule {
  @Singleton()
  S get s => S();

  @Named('auth_dio')
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: '$kServerUrl/api/auth'));

  @Named('record_dio')
  @lazySingleton
  Dio get recordDio => Dio(
        BaseOptions(
          baseUrl: '$kServerUrl/api/tenant/tenant',
        ),
      );

  @Named('media_repo')
  @lazySingleton
  MediaRepository get mediaRepo => MediaRepository();

  @Named('files_repo')
  @lazySingleton
  FilesRepository get filesRepo => FilesRepository();

  @Named('files_controller')
  FilesController get filesController => FilesController();

  @lazySingleton
  LoadController get leadController => LoadController();

  @Named('user_repo')
  @lazySingleton
  UserRepository get userRepository => UserRepository();

  @Named('packet_repo')
  @lazySingleton
  PacketRepository get packetRepository => PacketRepository();

  @Named('packet_controller')
  PacketController get packetController => PacketController();
}

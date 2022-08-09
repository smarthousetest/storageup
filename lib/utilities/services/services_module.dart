import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/controllers/files_controller.dart';
import 'package:storageup/utilities/controllers/subscription_controllers.dart';
import 'package:storageup/utilities/repositories/file_repository.dart';
import 'package:storageup/utilities/repositories/media_repository.dart';
import 'package:storageup/utilities/repositories/subscription_repository.dart';
import 'package:storageup/utilities/repositories/user_repository.dart';

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

  @Named('user_repo')
  @lazySingleton
  UserRepository get userRepository => UserRepository();

  @Named('subscription_repo')
  @lazySingleton
  SubscriptionRepository get subscriptionRepository => SubscriptionRepository();

  @Named('subscription_controller')
  SubscriptionController get subscriptionController => SubscriptionController();
}

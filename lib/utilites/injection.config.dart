// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:upstorage_desktop/utilites/autoupload/autoupload_controller.dart';

import '../generated/l10n.dart' as _i13;
import '../pages/auth/auth_bloc.dart' as _i3;
import '../pages/auth/forgot_password/forgot_password_bloc.dart' as _i9;
import '../pages/files/file_bloc.dart' as _i17;
import '../pages/home/home_bloc.dart' as _i10;
import 'controllers/files_controller.dart' as _i6;
import 'controllers/load_controller.dart' as _i11;
import 'repositories/auth_repository.dart' as _i4;
import 'repositories/file_repository.dart' as _i7;
import 'repositories/media_repository.dart' as _i12;
import 'repositories/token_repository.dart' as _i14;
import 'repositories/user_repository.dart' as _i15;
import 'services/auth_service.dart' as _i16;
import 'services/files_service.dart' as _i8;
import 'services/services_module.dart'
    as _i18; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();

  gh.lazySingletonAsync<AutouploadController>(
      () async => await AutouploadController());
  gh.lazySingleton<_i5.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.lazySingleton<_i5.Dio>(() => serviceModule.recordDio,
      instanceName: 'record_dio');
  gh.factory<_i6.FilesController>(() => _i6.FilesController());
  gh.factory<_i6.FilesController>(() => serviceModule.filesController,
      instanceName: 'files_controller');
  gh.factory<_i7.FilesRepository>(() => _i7.FilesRepository());
  gh.lazySingleton<_i7.FilesRepository>(() => serviceModule.filesRepo,
      instanceName: 'files_repo');
  gh.factory<_i8.FilesService>(
      () => _i8.FilesService(get<_i5.Dio>(instanceName: 'record_dio')));
  gh.factory<_i9.ForgotPasswordBloc>(() => _i9.ForgotPasswordBloc());
  gh.factory<_i10.HomeBloc>(() => _i10.HomeBloc());
  gh.lazySingleton<_i11.LoadController>(() => serviceModule.leadController);
  gh.factory<_i12.MediaRepository>(() => _i12.MediaRepository());
  gh.lazySingleton<_i12.MediaRepository>(() => serviceModule.mediaRepo,
      instanceName: 'media_repo');
  gh.singleton<_i13.S>(serviceModule.s);
  gh.factory<_i14.TokenRepository>(() => _i14.TokenRepository());
  gh.lazySingleton<_i15.UserRepository>(() => serviceModule.userRepository);
  gh.factory<_i16.AuthService>(
      () => _i16.AuthService(get<_i5.Dio>(instanceName: 'auth_dio')));
  gh.factory<_i17.FilesBloc>(() => _i17.FilesBloc(
      get<_i6.FilesController>(instanceName: 'files_controller')));
  gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  return get;
}

class _$ServiceModule extends _i18.ServiceModule {}

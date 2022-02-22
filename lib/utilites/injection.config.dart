// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../generated/l10n.dart' as _i15;
import '../pages/auth/auth_bloc.dart' as _i3;
import '../pages/auth/forgot_password/forgot_password_bloc.dart' as _i10;
import '../pages/files/file_bloc.dart' as _i22;
import '../pages/home/home_bloc.dart' as _i11;
import '../pages/info/info_bloc.dart' as _i12;
import '../pages/settings/settings_bloc.dart' as _i16;
import 'controllers/files_controller.dart' as _i7;
import 'controllers/load_controller.dart' as _i13;
import 'controllers/user_controller.dart' as _i19;
import 'repositories/auth_repository.dart' as _i4;
import 'repositories/file_repository.dart' as _i8;
import 'repositories/media_repository.dart' as _i14;
import 'repositories/space_repository.dart' as _i6;
import 'repositories/token_repository.dart' as _i18;
import 'repositories/user_repository.dart' as _i20;
import 'services/auth_service.dart' as _i21;
import 'services/files_service.dart' as _i9;
import 'services/services_module.dart' as _i23;
import 'services/subscription_service.dart'
    as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());
  gh.lazySingleton<_i5.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.lazySingleton<_i5.Dio>(() => serviceModule.recordDio,
      instanceName: 'record_dio');
  gh.lazySingletonAsync<_i6.DownloadLocationsRepository>(
      () => _i6.DownloadLocationsRepository.create());
  gh.factory<_i7.FilesController>(() => serviceModule.filesController,
      instanceName: 'files_controller');
  gh.factory<_i8.FilesRepository>(() => _i8.FilesRepository());
  gh.lazySingleton<_i8.FilesRepository>(() => serviceModule.filesRepo,
      instanceName: 'files_repo');
  gh.factory<_i9.FilesService>(
      () => _i9.FilesService(get<_i5.Dio>(instanceName: 'record_dio')));
  gh.factory<_i10.ForgotPasswordBloc>(() => _i10.ForgotPasswordBloc());
  gh.factory<_i11.HomeBloc>(() => _i11.HomeBloc());
  gh.factory<_i12.InfoBloc>(() => _i12.InfoBloc());
  gh.lazySingleton<_i13.LoadController>(() => serviceModule.leadController);
  gh.factory<_i14.MediaRepository>(() => _i14.MediaRepository());
  gh.lazySingleton<_i14.MediaRepository>(() => serviceModule.mediaRepo,
      instanceName: 'media_repo');
  gh.singleton<_i15.S>(serviceModule.s);
  gh.factory<_i16.SettingsBloc>(() => _i16.SettingsBloc());
  gh.factory<_i17.SubscriptionService>(() => _i17.SubscriptionService());
  gh.factory<_i18.TokenRepository>(() => _i18.TokenRepository());
  gh.factory<_i19.UserController>(() => _i19.UserController());
  gh.lazySingleton<_i20.UserRepository>(() => serviceModule.userRepository,
      instanceName: 'user_repo');
  gh.factory<_i21.AuthService>(
      () => _i21.AuthService(get<_i5.Dio>(instanceName: 'auth_dio')));
  gh.factory<_i22.FilesBloc>(() => _i22.FilesBloc(
      get<_i7.FilesController>(instanceName: 'files_controller')));
  return get;
}

class _$ServiceModule extends _i23.ServiceModule {}

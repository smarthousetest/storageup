// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:upstorage_desktop/pages/files/file_bloc.dart';

import '../generated/l10n.dart' as _i14;
import '../pages/auth/auth_bloc.dart' as _i3;
import '../pages/auth/forgot_password/forgot_password_bloc.dart' as _i10;
import '../pages/home/home_bloc.dart' as _i11;
import '../pages/like/like_bloc.dart' as _i12;
import '../pages/sell_space/space_bloc.dart' as _i15;
import 'autoupload/upload_media_repository.dart' as _i17;
import 'controllers/files_controller.dart' as _i6;
import 'repositories/auth_repository.dart' as _i4;
import 'repositories/file_repository.dart' as _i7;
import 'repositories/media_repository.dart' as _i13;
import 'repositories/token_repository.dart' as _i16;
import 'repositories/upstorage_desktop.dart' as _i8;
import 'services/auth_service.dart' as _i18;
import 'services/files_service.dart' as _i9;
import 'services/services_module.dart'
    as _i19; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();

  gh.lazySingleton<_i5.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.lazySingleton<_i5.Dio>(() => serviceModule.recordDio,
      instanceName: 'record_dio');
  gh.factory<_i6.FilesController>(() => _i6.FilesController());
  gh.factory<_i6.FilesController>(() => serviceModule.filesController,
      instanceName: 'files_controller');
  gh.factory<_i7.FilesRepository>(() => _i7.FilesRepository());
  gh.factory<_i8.FilesRepository>(() => _i8.FilesRepository());
  gh.lazySingleton<_i7.FilesRepository>(() => serviceModule.filesRepo,
      instanceName: 'files_repo');
  gh.factory<_i9.FilesService>(
      () => _i9.FilesService(get<_i5.Dio>(instanceName: 'record_dio')));
  gh.factory<_i10.ForgotPasswordBloc>(() => _i10.ForgotPasswordBloc());
  gh.factory<_i11.HomeBloc>(() => _i11.HomeBloc());
  gh.factory<_i12.LikeBloc>(() => _i12.LikeBloc());
  gh.factory<_i13.MediaRepository>(() => _i13.MediaRepository());
  gh.lazySingleton<_i13.MediaRepository>(() => serviceModule.mediaRepo,
      instanceName: 'media_repo');
  gh.singleton<_i14.S>(serviceModule.s);
  gh.factory<_i15.SpaceBloc>(() => _i15.SpaceBloc());
  gh.factory<_i16.TokenRepository>(() => _i16.TokenRepository());
  gh.factory<_i17.UploadMediaRepo>(() => _i17.UploadMediaRepo());
  gh.factory<_i18.AuthService>(
      () => _i18.AuthService(get<_i5.Dio>(instanceName: 'auth_dio')));
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());

  return get;
}

class _$ServiceModule extends _i19.ServiceModule {}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../generated/l10n.dart' as _i23;
import '../pages/auth/auth_bloc.dart' as _i3;
import '../pages/auth/forgot_password/forgot_password_bloc.dart' as _i10;
import '../pages/files/file_bloc.dart' as _i6;
import '../pages/finance/finance_bloc.dart' as _i9;
import '../pages/home/home_bloc.dart' as _i11;
import '../pages/info/info_bloc.dart' as _i12;
import '../pages/loadind_files.dart/loading_container_bloc.dart' as _i15;
import '../pages/media/media_open/media_open_bloc.dart' as _i17;
import '../pages/settings/settings_bloc.dart' as _i24;
import 'controllers/files_controller.dart' as _i30;
import 'controllers/open_file_controller.dart' as _i20;
import 'controllers/packet_controllers.dart' as _i21;
import 'controllers/user_controller.dart' as _i27;
import 'repositories/auth_repository.dart' as _i30;
import 'repositories/file_repository.dart' as _i7;
import 'repositories/latest_file_repository.dart' as _i14;
import 'repositories/storage_files.dart' as _i7;
import 'repositories/media_repository.dart' as _i19;
import 'repositories/packet_repository.dart' as _i22;
import 'repositories/space_repository.dart' as _i5;
import 'repositories/storage_files.dart' as _i16;
import 'repositories/token_repository.dart' as _i26;
import 'repositories/user_repository.dart' as _i28;
import 'services/auth_service.dart' as _i29;
import 'services/files_service.dart' as _i8;
import 'services/keeper_service.dart' as _i13;
import 'services/services_module.dart' as _i31;
import 'services/subscription_service.dart'
    as _i25; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.factory<_i3.AuthBloc>(() => _i3.AuthBloc());
  gh.lazySingleton<_i4.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.lazySingleton<_i4.Dio>(() => serviceModule.recordDio,
      instanceName: 'record_dio');
  gh.lazySingletonAsync<_i5.DownloadLocationsRepository>(
      () => _i5.DownloadLocationsRepository.create());

  gh.lazySingletonAsync<_i7.LocalStorage>(() => _i7.LocalStorage.create());

  gh.factory<_i6.FilesBloc>(() => _i6.FilesBloc());
  gh.factory<_i7.FilesRepository>(() => _i7.FilesRepository());
  gh.lazySingleton<_i7.FilesRepository>(() => serviceModule.filesRepo,
      instanceName: 'files_repo');
  gh.factory<_i8.FilesService>(
      () => _i8.FilesService(get<_i4.Dio>(instanceName: 'record_dio')));
  gh.factory<_i9.FinanceBloc>(() => _i9.FinanceBloc());
  gh.factory<_i10.ForgotPasswordBloc>(() => _i10.ForgotPasswordBloc());
  gh.factory<_i11.HomeBloc>(() => _i11.HomeBloc());
  gh.factory<_i12.InfoBloc>(() => _i12.InfoBloc());
  gh.factory<_i13.KeeperService>(() => _i13.KeeperService());
  gh.lazySingletonAsync<_i14.LatestFileRepository>(
      () => _i14.LatestFileRepository.create());
  gh.factory<_i15.LoadingContainerBloc>(() => _i15.LoadingContainerBloc());
  gh.factory<_i19.MediaRepository>(() => _i19.MediaRepository());
  gh.lazySingleton<_i19.MediaRepository>(() => serviceModule.mediaRepo,
      instanceName: 'media_repo');
  gh.singleton<_i20.OpenFileController>(_i20.OpenFileController());
  gh.factory<_i21.PacketController>(() => _i21.PacketController());
  gh.factory<_i21.PacketController>(() => serviceModule.packetController,
      instanceName: 'packet_controller');
  gh.lazySingleton<_i22.PacketRepository>(() => serviceModule.packetRepository,
      instanceName: 'packet_repo');
  gh.singleton<_i23.S>(serviceModule.s);
  gh.factory<_i24.SettingsBloc>(() => _i24.SettingsBloc());
  gh.factory<_i25.SubscriptionService>(() => _i25.SubscriptionService());
  gh.singleton<_i26.TokenRepository>(_i26.TokenRepository());
  gh.factory<_i27.UserController>(() => _i27.UserController());
  gh.lazySingleton<_i28.UserRepository>(() => serviceModule.userRepository,
      instanceName: 'user_repo');
  gh.factory<_i29.AuthService>(
      () => _i29.AuthService(get<_i4.Dio>(instanceName: 'auth_dio')));
  gh.singleton<_i30.AuthenticationRepository>(
      _i30.AuthenticationRepository(get<_i29.AuthService>()));
  gh.singletonAsync<_i30.FilesController>(
      () async => _i30.FilesController(await get.getAsync<_i7.LocalStorage>()));

  return get;
}

class _$ServiceModule extends _i31.ServiceModule {}
